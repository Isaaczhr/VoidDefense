extends Sprite2D

# 定义自定义信号
signal start_1
signal attack

# 收到广播 start_1 时，开始移动
var data : Dictionary
var target_position : Vector2
var moving : bool = false
var speed : float = 100.0  # 每秒移动的像素数

var current_checkpoint : int = 0  # 当前检查点索引
var map_points : Array = []  # 存储地图检查点

func _ready():
	# 检查节点名称是否符合克隆体的特征
	if not name.begins_with("Enemy_"):
		print("Not a clone, script will not execute.")
		return
	var root = get_tree().root.get_child(0)
	data = root.data
	connect("start_1", Callable(self, "_on_start_1"))
	print("Enemy ready: ", self.name)

func _on_start_1():
	print("Signal received: start_1 for ", self.name)
	# 获取地图信息
	var map = data["map"]
	# 存储所有检查点的位置
	for i in range(map["num"]):
		var x = map["value"][i][0]
		var y = map["value"][i][1]
		var pos = Vector2(200 + 180 * x, 300 + 180 * y)
		map_points.append(pos)
	# 设置第一个目标位置
	if map_points.size() > 0:
		target_position = map_points[current_checkpoint]
		moving = true

func move_to(target: Vector2):
	target_position = target
	moving = true
	print(self.name, " moving to: ", target_position)

func _process(delta: float) -> void:
	if moving:
		var direction = (target_position - position).normalized()
		position += direction * speed * delta
		if position.distance_to(target_position) < 1:
			position = target_position
			moving = false
			print(self.name, " reached target: ", target_position)
			# 前往下一个检查点
			current_checkpoint += 1
			if current_checkpoint < map_points.size():
				target_position = map_points[current_checkpoint]
				moving = true
				print(self.name, " moving to next checkpoint: ", target_position)
			else:
				print(self.name, " has reached all checkpoints.")
				# 设置自身为不可见并发射 attack 信号
				visible = false
				emit_signal("attack")
