extends Sprite2D

signal drawtower  # 定义一个信号 drawtower

var dragging = false  # 是否正在拖动
var drag_offset = Vector2.ZERO  # 拖动偏移量
var tower_count = 0  # 塔的计数
var original_position = Vector2.ZERO  # 原始位置
var can_drag_and_duplicate = true  # 是否可以拖动和复制
var preview_tower = null  # 预览塔变量

func _ready():
	# 将塔移到屏幕外并隐藏
	global_position = Vector2(-1000, -1000)
	visible = false
	connect("drawtower", Callable(self, "_on_drawtower"))  # 连接 drawtower 信号到 _on_drawtower 函数

func _on_drawtower():
	print("Received drawtower signal")  # 打印接收到 drawtower 信号
	# 根据 Globals["tower"]["value"] 更改纹理
	var i = 0
	for tower_data in Globals.data["tower"]["value"]:
		var new_tower = _create_tower(tower_data["type"])
		get_parent().add_child(new_tower)  # 将新塔添加到父节点
		new_tower.global_position = Vector2(Globals.data["coords"]["origin"][0] + Globals.data["coords"]["size"] * i, Globals.data["coords"]["origin"][1] - Globals.data["coords"]["size"] - 20)  # 设置新塔的初始位置
		new_tower.visible = true  # 显示新塔
		new_tower.set_script(self.get_script())  # 设置新塔的脚本
		print("Added tower: ", new_tower.name, " at position: ", new_tower.global_position)  # 打印新塔的信息
		i += 1

func _input(event):
	if can_drag_and_duplicate:
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				if get_global_mouse_position().distance_to(global_position) < 60:
					dragging = true  # 开始拖动
					drag_offset = global_position - get_global_mouse_position()  # 计算拖动偏移量
					original_position = global_position  # 记录原始位置
					_show_preview_tower()  # 显示预览塔
			elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				if dragging:
					dragging = false  # 停止拖动
					_hide_preview_tower()  # 隐藏预览塔
					snap_to_grid()  # 停止拖动时对齐到网格
					_on_DragBegin()  # 处理拖动开始事件
					_create_new_tower_at_original_position()  # 在原始位置创建新塔
					can_drag_and_duplicate = false  # 禁止拖动和复制

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset  # 更新塔的位置
		_update_preview_tower_position()  # 更新预览塔位置

func _show_preview_tower():
	if preview_tower == null:
		preview_tower = _create_tower()  # 调用实际塔的生成逻辑生成预览塔
		preview_tower.modulate.a = 0.5  # 设置预览塔为半透明
		get_parent().add_child(preview_tower)  # 将预览塔添加到父节点
		# 不再需要调整预览塔的位置，因为锚点已经设置为中心
	preview_tower.visible = true

func _hide_preview_tower():
	if preview_tower:
		preview_tower.visible = false  # 隐藏预览塔
		get_parent().remove_child(preview_tower)  # 从父节点移除预览塔
		preview_tower = null  # 清空预览塔变量

func _update_preview_tower_position():
	if preview_tower:
		var grid_size = Globals.data["coords"]["size"]
		var grid_origin = Vector2(Globals.data["coords"]["origin"][0], Globals.data["coords"]["origin"][1])

		# 使用当前对象的全局位置
		var object_global_pos = global_position

		# 计算当前对象所在的网格坐标 x 和 y
		var x = floor((object_global_pos.x - grid_origin.x + grid_size / 2) / grid_size)
		var y = floor((object_global_pos.y - grid_origin.y + grid_size / 2) / grid_size)

		# 检查位置是否在 Globals.void_area 范围内
		if x >= 0 and x < Globals.void_area.size() and y >= 0 and y < Globals.void_area[0].size():
			# 检查该位置是否可以放置塔
			if Globals.void_area[x][y] != 0:
				# 有效位置，更新预览塔的位置并显示
				var closest_grid_point = Vector2(
					x * grid_size + grid_origin.x,
					y * grid_size + grid_origin.y
				)
				preview_tower.global_position = closest_grid_point
				preview_tower.texture = self.texture
				preview_tower.visible = true
			else:
				# 不可放置塔的位置，隐藏预览塔
				preview_tower.visible = false
		else:
			# 位置不存在，隐藏预览塔
			preview_tower.visible = false

func snap_to_grid():
	var grid_size = Globals.data["coords"]["size"]
	var grid_origin = Vector2(Globals.data["coords"]["origin"][0], Globals.data["coords"]["origin"][1])
	var closest_grid_point = Vector2(
		round((global_position.x - grid_origin.x) / grid_size) * grid_size + grid_origin.x,
		round((global_position.y - grid_origin.y) / grid_size) * grid_size + grid_origin.y
	)
	if global_position.distance_to(closest_grid_point) < Globals.data["coords"]["size"]: # Adjust the snap distance as needed
		global_position = closest_grid_point.round()  # Round to the nearest integer

func _on_DragBegin():
	var grid_size = Globals.data["coords"]["size"]
	var grid_origin = Vector2(Globals.data["coords"]["origin"][0], Globals.data["coords"]["origin"][1])
	var closest_grid_point = Vector2(
		round((global_position.x - grid_origin.x) / grid_size) * grid_size + grid_origin.x,
		round((global_position.y - grid_origin.y) / grid_size) * grid_size + grid_origin.y
	)
	if global_position.distance_to(closest_grid_point) < Globals.data["coords"]["size"]: # Adjust the snap distance as needed
		global_position = closest_grid_point.round()  # Round to the nearest integer
		print("Moved tower to position: ", global_position)

func _create_new_tower_at_original_position():
	var new_tower = duplicate()
	new_tower.name = "tower_%d" % tower_count
	tower_count += 1
	get_parent().add_child(new_tower)
	new_tower.global_position = original_position
	new_tower.visible = true
	new_tower.set_script(self.get_script())
	print("Created new tower at original position: ", new_tower.global_position)
	# Disable dragging and duplicating for the original tower
	self.disconnect("input_event", Callable(self, "_input"))

# 创建塔的函数，包括预览塔和实际塔
func _create_tower(type=1, is_preview=false):
	var new_tower = duplicate()
	if not is_preview:
		new_tower.name = "tower_%d" % type
	else:
		new_tower.name = "preview_tower"
	new_tower.texture = load("res://Pic/tower/tower_%d.png" % type)
	if is_preview:
		new_tower.modulate.a = 0.5
	return new_tower
