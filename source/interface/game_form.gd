extends Control

@onready var original_tower: OriginalTower = $VBoxContainer/MarginContainer2/HBoxContainer/OriginalTower
@onready var exit_button: Button = $VBoxContainer/MarginContainer/HBoxContainer/ExitButton

signal tower_released

func _ready() -> void:
    original_tower.released.connect(
        func() -> void:
            tower_released.emit(original_tower.P_TOWER)
    )

    exit_button.connect("pressed", Callable(get_tree(), "quit"))
