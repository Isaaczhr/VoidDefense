extends Tower

@export var damage: float = 10
func _ready() -> void:
    P_BULLET = preload("res://source/actor/bullets/bullet_attack.tscn")

func _spawn_bullet(enemy) -> void:
    var bullet = P_BULLET.instantiate()
    bullet.damage = damage
    add_child(bullet)
    bullet.initialize(enemy)
    _current_bullet_count -= 1
    _current_cooldown = cooldown
    audio_shoot.play()

