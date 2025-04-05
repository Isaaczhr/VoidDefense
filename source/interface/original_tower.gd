extends MarginContainer
class_name OriginalTower

var P_TOWER: PackedScene = preload("res://source/actor/tower.tscn")
@onready var cost_label: RichTextLabel = $MarginContainer2/CostLabel
@onready var node_2d: Node2D = $MarginContainer/SubViewport/SubViewport/Node2D
@onready var p_tower: Tower = $MarginContainer/SubViewport/SubViewport/Node2D/Tower

var tower_cost: int = 0

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
    cost_label.text = '[wave]' + str(tower.cost) + '[/wave]'
    tower_cost = tower.cost

## 更新花费的显示
func update_cost_display(cost: int) -> void:
    if not can_place_tower(cost):
        cost_label.text = '[shake]' + str(tower_cost) + '[/shake]'
        node_2d.get_child(0).modulate = Color(1, 1, 1, 0.3)
    else:
        cost_label.text = '[wave]' + str(tower_cost) + '[/wave]'
        node_2d.get_child(0).modulate = Color(1, 1, 1, 1)

## 能否在游戏中放置塔
func can_place_tower(coins: int) -> bool:
    var tower: Tower = node_2d.get_child(0)
    return tower.can_place_tower(coins)
