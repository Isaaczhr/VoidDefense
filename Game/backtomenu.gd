extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the button's pressed signal to the _on_Button_pressed function
	connect("pressed", Callable(self, "_on_Button_pressed"))

# Called when the button is pressed
func _on_Button_pressed() -> void:
	var scene_path = "res://Menu/Menu.tscn"
	print("Changing scene to: ", scene_path)
	var error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		print("Failed to change scene: ", error)
	else:
		print("Scene changed successfully")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
