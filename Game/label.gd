extends Label

func _ready():
	get_parent().get_parent().connect("refresh", Callable(self, "_on_refresh"))

func _on_refresh(hp):
	print("HP refreshed: ", hp)
	text = "HP:" + str(hp)
