extends Node2D
signal lose

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("lose", Callable(self, "_on_lose"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_lose():
	get_node("Lose").visible = true
