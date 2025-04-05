extends Control

const ORIGINAL_TOWER = preload("res://source/interface/original_tower.tscn")
# @onready var original_tower: OriginalTower = $VBoxContainer/MarginContainer2/HBoxContainer/OriginalTower
@onready var exit_button: TextureButton = $VBoxContainer/MarginContainer/HBoxContainer/ExitButton
@onready var coin_label: RichTextLabel = $VBoxContainer/MarginContainer/HBoxContainer/CoinLabel
@onready var health_point: ProgressBar = $VBoxContainer/MarginContainer/HBoxContainer/HealthPoint
@onready var health_label: RichTextLabel = $VBoxContainer/MarginContainer/HBoxContainer/HealthPoint/MarginContainer/HealthLabel
@onready var h_box_container: HBoxContainer = $VBoxContainer/MarginContainer2/HBoxContainer


signal original_tower_released

func _ready() -> void:
    exit_button.connect("pressed", _on_ExitButton_pressed)

func initialize(towers: Array[PackedScene]) -> void:
    for P_TOWER: PackedScene in towers:
        var original_tower: OriginalTower = ORIGINAL_TOWER.instantiate()
        original_tower.P_TOWER = P_TOWER
        h_box_container.add_child(original_tower)
        original_tower.released.connect(
            func() -> void:
                original_tower_released.emit(original_tower)
        )

func update_coins_display(coins: int) -> void:
    coin_label.text = '[wave]' + str(coins) + '[/wave]' if coins > 0 else '[shake]' + str(coins) + '[/shake]'
    for original_tower in h_box_container.get_children():
        original_tower.update_cost_display(coins)

func update_hp_display(hp: int, max_hp: int) -> void:
    health_point.value = hp
    health_point.max_value = max_hp
    health_label.text = "%3d / %-3d" % [hp, max_hp]
    if hp <= max_hp / 5.0:
        health_label.text = "[shake]%3d[/shake] / %-3d" % [hp, max_hp]

## 点击退出按钮
func _on_ExitButton_pressed() -> void:
    get_tree().quit()
