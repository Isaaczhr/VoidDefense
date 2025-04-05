extends Camera2D

@export var shake_intensity: float = 3.0  # 抖动强度
@export var shake_duration: float = 0.2   # 抖动持续时间
var shake_timer: float = 0.0

func _ready():
    ShakeManager.shake_triggered.connect(start_shake)  # 监听全局抖动信号

func _process(delta):
    if shake_timer > 0:
        shake_timer -= delta
        
        # Calculate decay factor (starts at 1, ends at 0)
        var decay_factor = shake_timer / shake_duration
        
        # Apply decay to intensity for more natural shake
        var current_intensity = shake_intensity * decay_factor
        
        # Use smoother random values
        offset = Vector2(
            randf_range(-current_intensity, current_intensity),
            randf_range(-current_intensity, current_intensity)
        )
        
        # Add slight rotation for more dynamic feel
        rotation_degrees = randf_range(-current_intensity, current_intensity) * 0.3
    else:
        # Reset everything when shake is done
        offset = Vector2.ZERO
        rotation_degrees = 0

func start_shake():
    shake_timer = shake_duration  # 启动抖动
