extends Bullet

var enemy_speed_times: float = 0.5
var damage: float = 5
var dizzy_range: float = 96

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
        if e.global_position.distance_to(enemy.global_position) <= dizzy_range:
            e.dizzy(enemy_speed_times)
    # 给予击中的敌人伤害
    enemy.hit(damage)
    queue_free()