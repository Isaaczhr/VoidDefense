extends Tower

@export var enemy_speed_times: float = 0.5
@export var damage: float = 5
@export var decelerate_range: float = 96

func _ready() -> void:
    super._ready()
    P_BULLET = preload("res://source/actor/bullets/bullet_decelerate.tscn")

func _spawn_bullet(enemy) -> void:
    var bullet = P_BULLET.instantiate()
    bullet.enemy_speed_times = enemy_speed_times
    bullet.damage = damage
    bullet.decelerate_range = decelerate_range
    add_child(bullet)
    bullet.initialize(enemy)
    _current_bullet_count -= 1
    _current_cooldown = cooldown
    audio_shoot.play()
