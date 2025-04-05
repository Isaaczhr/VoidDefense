extends Node2D

const TILE_SOURCE_ID_PLACEABLE: int = 0
const TILE_CELL_PLACEABLE: Vector2i = Vector2i(4, 34)

@onready var music_bg: AudioStreamPlayer = $MusicBG
@onready var map: TileMapLayer = $Map
@onready var timer_spawn_enemy: Timer = $TimerSpawnEnemy
@onready var timer_begin: Timer = $TimerBegin
@onready var path_2d: Path2D = $Map/Path2D
@onready var game_form: Control = $CanvasLayer/GameForm
@export var enemies: Array[PackedScene]
@export var enemy_count: int = 10
@onready var rich_text_label: RichTextLabel = $RichTextLabel

@export var original_coins: int = 100
@onready var coins: int = original_coins:
    set(value):
        coins = value
        game_form.update_coins_display(value)

@export var max_hp: int = 100
@onready var current_hp: int = max_hp:
    set(value):
        current_hp = clamp(value, 0, max_hp)
        game_form.update_hp_display(current_hp, max_hp)
        if current_hp <= 0:
            _game_over()

@export var _towers: Array[PackedScene]

var _preview_tower: Tower:
    set(value):
        if _preview_tower and value:
            _preview_tower.queue_free()
            map.remove_child(_preview_tower)
        _preview_tower = value

var _countdown_count: int = 0

signal game_start

func _ready() -> void:
    randomize()
    game_form.original_tower_released.connect(
        func(original_tower: OriginalTower) -> void:
            if not original_tower.can_place_tower(coins): return
            _preview_tower = original_tower.P_TOWER.instantiate()
            map.add_child(_preview_tower)
            _preview_tower.modulate = Color(1, 1, 1, 0.5)
            _preview_tower.collision_shape_2d.shape.radius = _preview_tower.attack_range
    )
    connect("game_start", Callable(self, "start"))
    start_countdown()
    game_form.update_coins_display(coins)
    game_form.update_hp_display(current_hp, max_hp)
    game_form.initialize(_towers)

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
        func() -> void:
            _spawn_enemy()
    )
    music_bg.connect("finished", Callable(self, "_play_bgm"))
    _play_bgm()
    _loop()

func _process(delta: float) -> void:
    preview_tower()

func _unhandled_input(event: InputEvent) -> void:
    if not _preview_tower: return
    if event is InputEventMouseButton and event.pressed:
        if event.button_index == MOUSE_BUTTON_LEFT:
            place_tower()
        if event.button_index == MOUSE_BUTTON_RIGHT:
            cancel_preview()

## 预览塔
func preview_tower() -> void:
    if not _preview_tower: return
    var mouse_pos = get_global_mouse_position()
    var cell = map.local_to_map(map.to_local(mouse_pos))
    _preview_tower.global_position = map.to_global(map.map_to_local(cell))
    _preview_tower.collision_shape_2d.shape.radius = _preview_tower.attack_range
    if can_place_tower(cell):
        _preview_tower.modulate = Color(1, 1, 1, 0.7)
        _preview_tower.show_range(true)
    else:
        _preview_tower.modulate = Color(1, 0, 0, 0.3)
        _preview_tower.show_range(false)

## 取消预览
func cancel_preview() -> void:
    if not _preview_tower: return
    _preview_tower.queue_free()
    map.remove_child(_preview_tower)
    _preview_tower = null

## 在地图上放置塔
func place_tower() -> void:
    if not _preview_tower: return
    var cell: Vector2i = map.local_to_map(map.to_local(_preview_tower.global_position))
    if can_place_tower(cell):
        _preview_tower.audio_build.play()
        coins -= _preview_tower.cost
        _preview_tower.initialize()
        _preview_tower.modulate = Color(1, 1, 1, 1)
        _preview_tower.show_range(false)
        _preview_tower = null
        map.set_cell(cell, 1)
        # map.set_cell(cell, 1, Vector2i.ZERO, 1)
    else:
        cancel_preview()
        

## 能否放置塔
func can_place_tower(cell: Vector2i) -> bool:
    var tile_source_id: int = map.get_cell_source_id(cell)
    var tile_cell: Vector2i = map.get_cell_atlas_coords(cell)
    return tile_source_id == TILE_SOURCE_ID_PLACEABLE and tile_cell == TILE_CELL_PLACEABLE

## 生成敌人
func _spawn_enemy() -> void:
    if path_2d.get_child_count() >= enemy_count:
        return
    var enemy_index: int = randi_range(0, enemies.size() - 1)
    var enemy = enemies[enemy_index].instantiate()
    enemy.died.connect(_on_enemy_died.bind(enemy))
    enemy.damaged.connect(_on_enemy_damaged.bind())
    path_2d.add_child(enemy)
    _loop()

func _loop() -> void:
    timer_spawn_enemy.wait_time = randf_range(3, 5)
    timer_spawn_enemy.start()

## 游戏结束
func _game_over() -> void:
    # print("Game Over")
    get_tree().paused = true

## 循环播放背景音乐
func _play_bgm() -> void:
    self.music_bg.play()

func _on_enemy_died(enemy: Enemy) -> void:
    coins += enemy.loot_coins

func _on_enemy_damaged(damage: int) -> void:
    current_hp -= damage
