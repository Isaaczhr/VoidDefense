extends Bullet

@export var damage: float = 0
@export var dizzy_time_min: float = 1.5
@export var dizzy_time_max: float = 2.5

func _ready() -> void:
    area_2d.area_entered.connect(
        func(area: Area2D) -> void:
            if not area.owner is Enemy: return
            attack(area.owner)
    )

## 造成伤害
func attack(enemy: Enemy) -> void:
    enemy.hit(damage)
    var dizzy_time = randf_range(dizzy_time_min, dizzy_time_max)
    enemy.dizzy(dizzy_time)
    ShakeManager.start_shake()
    queue_free()