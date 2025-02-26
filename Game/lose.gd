extends Node2D
signal lose

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_parent().connect("lose", Callable(self, "_on_lose"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_lose():
	visible = true
