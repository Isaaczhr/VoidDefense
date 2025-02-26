extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the button's pressed signal to the _on_Button_pressed function
	connect("pressed", Callable(self, "_on_Button_pressed"))

# Called when the button is pressed
func _on_Button_pressed() -> void:
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
