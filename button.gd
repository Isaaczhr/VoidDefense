extends Button

# 按钮点击时的回调函数
func _on_pressed() -> void:
	# 切换到名为 "Menu" 的场景
	var menu_scene = load("res://Menu/Menu.tscn")  # 确保路径正确
	if menu_scene:
		get_tree().change_scene_to_packed(menu_scene)
	else:
		print("Failed to load Menu.tscn")

# 将按钮的按下信号绑定到回调函数
@onready var _signal_connected := connect("pressed", self._on_pressed)
