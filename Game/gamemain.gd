extends Node2D

var original_sprite : Sprite2D
var original_enemy_1 : Sprite2D
var original_enemy_2 : Sprite2D
var data : Dictionary
var HP : int

signal attack
signal refresh(hp: int)
signal GameBGM
signal drawtower

func read_json(filepath: String) -> Dictionary:
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var json = JSON.new()
		var error = json.parse(content)
		if error == OK:
			return json.get_data()
		else:
			print("Error parsing JSON: ", json.get_error_message())
			return {}
	else:
		print("Failed to open file: ", filepath)
		return {}

func _ready():
	Autobgm.emit_signal("GameBGM")
	var game_num = Globals.current_scene_number
	print("Current game number: ", game_num)
	# 根据game_num确定读取的文件路径
	var file_path = "res://Game/game%d.json" % game_num
	print("Loading data from: ", file_path)
	original_sprite = $OriginalRoad  # 确认节点名是否准确
	original_enemy_1 = $enemy_1  # 确认节点名是否准确，并附加了 enemy_1.gd 脚本
	original_enemy_2 = $enemy_2  # 确认节点名是否准确，并附加了 enemy_1.gd 脚本
	data = read_json(file_path)
	print("Data loaded: ", data)
	Globals.data = data
	HP = data["player"]["HP"]
	emit_signal("refresh", HP)
	connect("attack", Callable(self, "_on_attack"))
	drawmap()
	drawtowers()
	await get_tree().create_timer(0).timeout
	for i in range(data["enemy"]["num"]):
		drawenemy(i)
		await get_tree().create_timer(4.0).timeout  # 控制敌人生成的间隔

func drawtowers():
	# 广播信号
	print("Emitting drawtower signal")
	get_node("Towers").get_node("Original").emit_signal("drawtower")

func drawmap():
	var num = data["map"]["num"]
	var val = data["map"]["value"]
	var size = data["coords"]["size"]
	for i in range(num):
		var x = val[i][0]
		var y = val[i][1]
		var copied_sprite = original_sprite.duplicate() as Sprite2D
		print("x,y: ", x, y)
		copied_sprite.position = Vector2(data["coords"]["origin"][0] + size * x, data["coords"]["origin"][1] + size * y)
		if i == num - 1:
			copied_sprite.texture = load("res://Pic/road/destination.png")
			copied_sprite.name = "destination"
		else:
			copied_sprite.name = "road_%d" % i
			var direction = copied_sprite.position - Vector2(data["coords"]["origin"][0] + data["coords"]["size"] * val[i+1][0], data["coords"]["origin"][1] + data["coords"]["size"] * val[i+1][1])
			var angle = direction.angle()
			copied_sprite.rotation = angle
			copied_sprite.rotation -= PI / 2
		copied_sprite.visible = true
		print("Added road: ", copied_sprite.name, " at position: ", copied_sprite.position)
		add_child(copied_sprite)
		#加入组
		copied_sprite.add_to_group("roads")
		#print("Added road: ", copied_sprite.name, " at position: ", copied_sprite.position)
		#更新全局变量void_area为0
		Globals.void_area[x][y] = 0
		await get_tree().create_timer(0.05).timeout
	get_tree().call_group("roads", "begin")

func drawenemy(id: int):
	var enemy_type = data["enemy"]["value"][id]["type"]
	var enemy_to_duplicate : Sprite2D
	if enemy_type == 1:
		enemy_to_duplicate = original_enemy_1
	elif enemy_type == 2:
		enemy_to_duplicate = original_enemy_2
	else:
		print("未知的敌人类型：", enemy_type)
		return  # 跳过未知类型
	var copied_sprite = enemy_to_duplicate.duplicate(DUPLICATE_SCRIPTS) as Sprite2D
	copied_sprite.name = "Enemy_%d" % id  # 更改复制节点的名称
	copied_sprite.add_to_group("enemies")  # 将敌人节点加入“enemies”组
	copied_sprite.position = Vector2(data["coords"]["origin"][0], data["coords"]["origin"][1])  # 设置初始位置
	copied_sprite.visible = true
	add_child(copied_sprite)
	print("Added enemy: ", copied_sprite.name, " at position: ", copied_sprite.position)
	copied_sprite.connect("attack", Callable(self, "_on_attack"))  # 连接敌人的 attack 信号
	copied_sprite.emit_signal("start_1")  # 发射信号

#收到广播：attack
func _on_attack() -> void:
	print("Received attack signal")
	HP -= 1
	emit_signal("refresh", HP)
	if HP == 0:
		get_parent().get_node("Lose").visible = true

func _process(delta: float) -> void:
	pass
