extends Node2D
class_name Bullet

@onready var area_2d: Area2D = $Area2D

## 子弹速度
@export var speed: float = 400
var damage: float = 0
## 敌人节点引用
var _target: Enemy = null

func _ready() -> void:
    area_2d.area_entered.connect(
        func(area: Area2D) -> void:
            if not area.owner is Enemy: return
            attack(area.owner)
    )

func _process(delta: float) -> void:
    if not _target: 
        queue_free()
        return
    if _target and not _target.is_queued_for_deletion():
        var direction = (_target.global_position - global_position).normalized()
        rotation = direction.angle() + deg_to_rad(90)
        global_position += direction * speed * delta
    else:
        queue_free()

## 初始化, 传入敌人
func initialize(enemy: Enemy) -> void:
    _target = enemy

## 造成伤害
func attack(enemy: Enemy) -> void:
    enemy.hit(damage)
    queue_free()