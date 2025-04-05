extends Tower
@export var damage: float = 0
@export var dizzy_time_min: float = 1.5
@export var dizzy_time_max: float = 2.5

func _ready() -> void:
    super._ready()
    P_BULLET = preload("res://source/actor/bullets/bullet_dizzy.tscn")

func _spawn_bullet(enemy) -> void:
    var bullet = P_BULLET.instantiate()
    bullet.damage = damage
    bullet.dizzy_time_min = dizzy_time_min
    bullet.dizzy_time_max = dizzy_time_max
    add_child(bullet)
    bullet.initialize(enemy)
    _current_bullet_count -= 1
    _current_cooldown = cooldown
    audio_shoot.play()
