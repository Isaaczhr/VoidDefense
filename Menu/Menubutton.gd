extends Button

# 按钮点击时的回调函数
func _on_pressed() -> void:
	# 获取自身的名称
	var game_num = int(get_name().get_slice("Button", 1))
	var menu_scene = load("res://Game/Game.tscn")  # 确保路径正确
	Globals.current_scene_number = game_num
	if menu_scene:
		get_tree().change_scene_to_packed(menu_scene)
	else:
		print("Failed to load Game.tscn")

# 将按钮的按下信号绑定到回调函数
@onready var _signal_connected := connect("pressed", self._on_pressed)
