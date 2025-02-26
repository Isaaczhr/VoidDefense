extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().get_parent().connect("lose", Callable(self, "_on_lose"))
	pivot_offset = size/2
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_lose():
	rotation -= 10
	scale = Vector2(0,0)
	for i in range(100):
		scale += Vector2(0.01,0.01)
		rotation += 0.1
		await get_tree().create_timer(0.01).timeout
