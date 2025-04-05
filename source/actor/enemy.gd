extends PathFollow2D
class_name Enemy

@onready var animated_sprite_enemy: AnimatedSprite2D = $AnimatedSpriteEnemy
@onready var area_2d: Area2D = $Area2D
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var audio_die: AudioStreamPlayer = $AudioDie

@export var max_hp: float = 100
@export var speed: float = 30
var speed_times: float = 1
var decelerate_timer: Timer
var dizzy_timer: Timer

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
@export var attack: int = 10
@export var loot_coins: int = 10

signal damaged
signal died

func _ready() -> void:
    progress_bar.max_value = max_hp
    progress_bar.value = max_hp
    progress_bar.hide()
    animated_sprite_enemy.play("walk")

func _process(delta: float) -> void:
    progress += speed * delta * randf_range(0.1, 1.0) * speed_times
    if progress_ratio >= 0.99:
        damage()
        queue_free()
        get_parent().remove_child(self)

## 受到伤害
func hit(atk: float) -> void:
    current_hp -= atk
    progress_bar.value = current_hp
    progress_bar.show()

func decelerate(times: float, decelerate_times) -> void:
    if decelerate_timer:
        decelerate_timer.stop()
    speed_times = times
    decelerate_timer = Timer.new()
    add_child(decelerate_timer)
    decelerate_timer.wait_time = decelerate_times
    decelerate_timer.one_shot = true
    decelerate_timer.timeout.connect(_on_decelerate_timeout)
    decelerate_timer.start()

func _on_decelerate_timeout() -> void:
    speed_times = 1
    if decelerate_timer:
        decelerate_timer.queue_free()
        decelerate_timer = null

## 造成伤害
func damage() -> void:
    damaged.emit(attack)

## 死亡
func _die() -> void:
    died.emit()
    var parent = get_parent()
    remove_child(audio_die)
    parent.add_child(audio_die)
    audio_die.finished.connect(audio_die.queue_free)
    audio_die.play()
    queue_free()

## 眩晕：暂停移动dizzy_times秒
func dizzy(dizzy_times: float) -> void:
    if dizzy_timer:
        dizzy_timer.stop()
    speed_times = 0
    dizzy_timer = Timer.new()
    add_child(dizzy_timer)
    dizzy_timer.wait_time = dizzy_times
    dizzy_timer.one_shot = true
    dizzy_timer.timeout.connect(_on_dizzy_timeout)
    dizzy_timer.start()

func _on_dizzy_timeout() -> void:
    speed_times = 1
    if dizzy_timer:
        dizzy_timer.queue_free()
        dizzy_timer = null