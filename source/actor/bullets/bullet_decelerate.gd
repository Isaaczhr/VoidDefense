extends Bullet

@export var enemy_speed_times: float = 0.5
@export var damage: float = 5
@export var decelerate_range: float = 96
@export var decelerate_times: float = 5

func _ready() -> void:
    area_2d.area_entered.connect(
        func(area: Area2D) -> void:
            if not area.owner is Enemy: return
            attack(area.owner)
    )

## 造成伤害
func attack(enemy: Enemy) -> void:
    for e in enemy.get_parent().get_children():
        if not e is Enemy: continue
        if e.global_position.distance_to(enemy.global_position) <= decelerate_range:
            e.decelerate(enemy_speed_times, decelerate_times)
    # 给予击中的敌人伤害
    enemy.hit(damage)
    ShakeManager.start_shake()
    queue_free()
