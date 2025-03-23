extends Node2D
class_name Tower

@onready var animated_sprite_tower: AnimatedSprite2D = $AnimatedSpriteTower
@onready var area_2d: Area2D = $Area2D
@onready var audio_shoot: AudioStreamPlayer = $AudioShoot
@onready var audio_build: AudioStreamPlayer = $AudioBuild
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

@export var P_BULLET: PackedScene
@export var attack_range: float = 48
@export var bullet_speed: float = 100
@export var bullet_count: int = 1
@onready var _current_bullet_count: int = bullet_count
@export var cooldown: float = 0.5
var _current_cooldown: float = 0

var _enemies: Array = []
@export var cost: int = 20

var _show_range: bool = false

func _ready() -> void:
    pass

func initialize() -> void:
    animated_sprite_tower.play("standby")
    area_2d.area_entered.connect(
        func(area: Area2D) -> void:
            _enemies.append(area.owner)
    )
    area_2d.area_exited.connect(
        func(area: Area2D) -> void:
            _enemies.erase(area.owner)
    )
    for area in area_2d.get_overlapping_areas():
        _enemies.append(area.owner)

func _process(delta: float) -> void:
    if _enemies.is_empty(): return
    
    # 寻找敌人并面向敌人
    var closest_to_end = _find_closest_enemy_to_end()
    
    if closest_to_end != null:
        var target_position = closest_to_end.global_position
        var target_angle = global_position.angle_to_point(target_position) + deg_to_rad(90)
        animated_sprite_tower.rotation = lerp_angle(animated_sprite_tower.rotation, target_angle, 0.05)

    # 判断冷却时间, 攻击敌人
    if _current_cooldown > 0:
        _current_cooldown -= delta
    else:
        _attack_enemy()

    if _show_range:
        queue_redraw()

## 找到距离终点最近的敌人
func _find_closest_enemy_to_end():
    var max_progress_ratio = -1.0
    var closest_to_end = null
    
    # 遍历所有敌人，找出离终点最近的敌人
    for e in _enemies:
        if is_instance_valid(e):
            var progress_ratio = e.progress_ratio
            if progress_ratio > max_progress_ratio:
                max_progress_ratio = progress_ratio
                closest_to_end = e
        else:
            _enemies.erase(e)
            
    return closest_to_end
        
## 攻击敌人
func _attack_enemy() -> void:
    if _enemies.is_empty(): return
    if _current_bullet_count <= 0: 
        _current_cooldown = cooldown
        _current_bullet_count = bullet_count
        return
    else:
        ## 找到距离终点最近的敌人
        var closest_to_end = _find_closest_enemy_to_end()
        if closest_to_end != null:
            _spawn_bullet(closest_to_end)
    

## 射击
func _spawn_bullet(enemy) -> void:
    var bullet = P_BULLET.instantiate()
    add_child(bullet)
    bullet.initialize(enemy)
    _current_bullet_count -= 1
    _current_cooldown = cooldown
    audio_shoot.play()

## 绘制射程
func _draw():
    if _show_range and collision_shape_2d and collision_shape_2d.shape:
        var shape = collision_shape_2d.shape
        var fill_color = Color(0, 1, 1, 0.3)
        var border_color = Color(0, 1, 1, 0.5)
        var border_width = 1
        draw_circle(Vector2.ZERO, shape.radius, fill_color)
        draw_arc(Vector2.ZERO, shape.radius, deg_to_rad(0), deg_to_rad(360), 64, border_color, border_width)

## 显示射程
func show_range(value: bool) -> void:
    _show_range = value
    queue_redraw()

## 能否放置塔
func can_place_tower(coin: int) -> bool:
    return coin - cost >= 0
