extends MarginContainer
class_name OriginalTower

var P_TOWER: PackedScene = preload("res://source/actor/tower.tscn")
@onready var cost_label: Label = $MarginContainer2/CostLabel
@onready var node_2d: Node2D = $MarginContainer/SubViewport/SubViewport/Node2D

signal released

func _ready() -> void:
    gui_input.connect(
        func(event: InputEvent) -> void:
            if event is InputEventMouseButton and event.is_released():
                if event.button_index == MOUSE_BUTTON_LEFT:
                    released.emit()
    )
    node_2d.get_child(0).queue_free()
    node_2d.remove_child(node_2d.get_child(0))
    var tower: Tower = P_TOWER.instantiate()
    if tower.collision_shape_2d and tower.collision_shape_2d.shape:
        tower.collision_shape_2d.shape.radius = tower.attack_range
    node_2d.add_child(tower)
    cost_label.text = str(tower.cost)

## 更新花费的显示
func update_cost_display(cost: int) -> void:
    if not can_place_tower(cost):
        cost_label.add_theme_color_override("font_color", Color(1, 0, 0, 0.5))
    else:
        cost_label.add_theme_color_override("font_color", Color(0, 0, 0, 1))

## 能否在游戏中放置塔
func can_place_tower(coins: int) -> bool:
    var tower: Tower = node_2d.get_child(0)
    return tower.can_place_tower(coins)
