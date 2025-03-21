extends MarginContainer
class_name OriginalTower

@export var P_TOWER: PackedScene = preload("res://source/actor/tower.tscn")

signal released

func _ready() -> void:
    gui_input.connect(
        func(event: InputEvent) -> void:
            if event is InputEventMouseButton and event.is_released():
                if event.button_index == MOUSE_BUTTON_LEFT:
                    released.emit()
    )
