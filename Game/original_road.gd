extends Sprite2D

var i = 1
var timer

func _ready():
	timer = Timer.new()
	timer.wait_time = 0.2
	timer.one_shot = false  # 如果希望计时器重复运行
	add_child(timer)  # 将计时器添加到场景树中
	self.scale = Vector2(7, 7)
	if name.begins_with("road_"):
		#print("OK " + name)
		timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
		# 如果您想在开始时就启动计时器，可以在这里启动
		# timer.start()
		texture = load("res://Pic/road/road%d.png" % i)

func begin():
	#print("Begin broadcast received")
	timer.start()  # 启动计时器

func _on_Timer_timeout():
	texture = load("res://Pic/road/road%d.png" % i)
	#print("Changed texture to: res://Pic/road/road%d.png" % i)
	i += 1
	if i > 8:
		i = 1
