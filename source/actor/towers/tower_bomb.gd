extends Tower

@export var damage: float = 30

# 是否在冷却状态
var _is_cooling_down: bool = false

func _ready() -> void:
    super._ready()
    # 设置鼠标点击事件监听
    touch_area.input_event.connect(_on_input_event)
    # 初始状态设为standby
    animated_sprite_tower.play("standby")

func _process(delta: float) -> void:
    # 替换父类的处理方法，专注于处理冷却和动画
    if _current_cooldown > 0:
        _current_cooldown -= delta
        if !_is_cooling_down:
            _is_cooling_down = true
            animated_sprite_tower.play("loading")
    elif _is_cooling_down:
        # 冷却完毕，回到待命状态
        _is_cooling_down = false
        animated_sprite_tower.play("standby")
        
    if _show_range:
        queue_redraw()

# 处理点击事件
func _on_input_event(viewport, event, shape_idx) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
            if !_is_cooling_down:
                # print("爆炸")
                for enemy in _enemies:
                    if enemy:
                        enemy.hit(damage)
                ShakeManager.start_shake()
                _current_cooldown = cooldown
