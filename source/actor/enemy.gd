extends PathFollow2D
class_name Enemy

@onready var animated_sprite_enemy: AnimatedSprite2D = $AnimatedSpriteEnemy
@onready var area_2d: Area2D = $Area2D
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var audio_die: AudioStreamPlayer = $AudioDie

@export var max_hp: float = 100
@export var speed: float = 30

@onready var current_hp: float = max_hp:
	set(value):
		current_hp = clamp(value, 0, max_hp)
		progress_bar.value = current_hp / max_hp
		if current_hp < max_hp:
			progress_bar.show()
		else:
			progress_bar.hide()
		if current_hp <= 0:
			_die() 
@export var attack: float = 10
@export var loot_coins: int = 10

signal damaged
signal died

func _ready() -> void:
	progress_bar.max_value = max_hp
	progress_bar.value = max_hp
	progress_bar.hide()
	animated_sprite_enemy.play("walk")

func _process(delta: float) -> void:
	progress += speed * delta * randf_range(0.1, 1.0)
	if progress_ratio >= 0.99:
		damage()
		queue_free()
		get_parent().remove_child(self)

## 受到伤害
func hit(damage: float) -> void:
	current_hp -= damage
	progress_bar.value = current_hp
	progress_bar.show()

## 造成伤害
func damage() -> void:
	damaged.emit(attack)

## 死亡
func _die() -> void:
	died.emit()
	audio_die.play()
	queue_free()
