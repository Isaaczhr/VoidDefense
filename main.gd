extends Node2D

@onready var timer_spawn_enemy: Timer = $TimerSpawnEnemy
@onready var timer_begin: Timer = $TimerBegin
@onready var path_2d: Path2D = $Map/Path2D
@export var enemies: Array[PackedScene]
@export var enemy_count: int = 10
@onready var rich_text_label: RichTextLabel = $RichTextLabel

var _countdown_count: int = 0

signal game_start

func _ready() -> void:
    randomize()
    connect("game_start", Callable(self,"start"))
    start_countdown()

func start_countdown():
    rich_text_label.visible = true
    _countdown_count = 3

    rich_text_label.text = str(_countdown_count)

    timer_begin.wait_time = 1
    timer_begin.one_shot = false

    if not timer_begin.timeout.is_connected(_on_timer_begin_timeout):
        timer_begin.timeout.connect(_on_timer_begin_timeout)

    timer_begin.start()

func _on_timer_begin_timeout():
    _countdown_count -= 1
    if _countdown_count > 0:
        rich_text_label.text = str(_countdown_count)
    else:
        rich_text_label.visible = false
        timer_begin.stop()
        timer_begin.timeout.disconnect(_on_timer_begin_timeout)
        emit_signal("game_start")

func start() -> void:
    timer_spawn_enemy.timeout.connect(
        func()-> void:
            _spawn_enemy()
    )
    _loop()

## 生成敌人
func _spawn_enemy() -> void:
    if path_2d.get_child_count() >= enemy_count:
        return
    var enemy_index: int = randi_range(0, enemies.size() - 1)
    var enemy = enemies[enemy_index].instantiate()
    path_2d.add_child(enemy)
    _loop()

func _loop() -> void:
    timer_spawn_enemy.wait_time = randf_range(3, 5)
    timer_spawn_enemy.start()