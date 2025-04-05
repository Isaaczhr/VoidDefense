extends Bullet

var damage: float = 0

func _ready() -> void:
    area_2d.area_entered.connect(
        func(area: Area2D) -> void:
            if not area.owner is Enemy: return
            attack(area.owner)
    )

## 造成伤害
func attack(enemy: Enemy) -> void:
    enemy.hit(damage)
    ShakeManager.start_shake()
    queue_free()