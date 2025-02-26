extends Node2D

signal MainBGM
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Autobgm.emit_signal("MainBGM")
	print("MainBGM emitted")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
