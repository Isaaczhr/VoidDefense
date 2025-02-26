extends AudioStreamPlayer

signal MainBGM
signal GameBGM

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Listen for global signals
	connect("MainBGM", Callable(self, "_on_MainBGM"))
	connect("GameBGM", Callable(self, "_on_GameBGM"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_MainBGM() -> void:
	print("MainBGM received")
	stop()
	stream = load("res://Music/MainBGM.mp3")
	play()

func _on_GameBGM() -> void:
	print("GameBGM received")
	stop()
	stream = load("res://Music/GameBGM.mp3")
	play()
