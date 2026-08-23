class_name Camera extends Camera2D

@onready var background_sprite: Sprite2D = get_node("Sprite2D")

var focus: bool
var default_zoom: Vector2 = Vector2(1.2, 1.2)

var zoom_tween: Tween

func _ready() -> void:
	GameLogic.state_changed.connect(game_state_changed)
	GameLogic.start_pan_to_door.connect(pan_to_door)
	start_focus()

func _process(_delta: float) -> void:
	if background_sprite:
		background_sprite.scale = Vector2.ONE / zoom

func game_state_changed() -> void:
	match GameLogic.state:
		GameLogic.State.DEATH_CUTSCENE:
			start_focus()
		GameLogic.State.CHARGING, GameLogic.State.START_REMBERING, GameLogic.State.REMBERING:
			start_focus_immediately()
		_:
			stop_focus()

func start_focus() -> void:
	focus = true
	#zoom = default_zoom * 2
	if zoom_tween:
		zoom_tween.kill()
	zoom_tween = get_tree().create_tween()
	zoom_tween.tween_property(self, "zoom", default_zoom * 2, 0.4)
	zoom_tween.play()

func start_focus_immediately() -> void:
	focus = true
	if zoom_tween:
		zoom_tween.kill()
	zoom = default_zoom * 2

func stop_focus() -> void:
	focus = false
	#zoom = default_zoom
	if zoom_tween:
		zoom_tween.kill()
	zoom_tween = get_tree().create_tween()
	zoom_tween.tween_property(self, "zoom", default_zoom, 0.4)
	zoom_tween.play()

func pan_to_door() -> void:
	var tween_to: Tween = get_tree().create_tween()
	var greenhouse_door: GreenhouseDoor = get_tree().get_first_node_in_group("greenhouse_door")
	tween_to.tween_property(self, "global_position", greenhouse_door.global_position, 1.0).set_ease(Tween.EASE_IN_OUT)
	
	await get_tree().create_timer(2).timeout
	
	greenhouse_door.open()
	
	await get_tree().create_timer(2).timeout
	
	var tween_from: Tween = get_tree().create_tween()
	tween_from.tween_property(self, "position", Vector2(0, -54), 1.0).set_ease(Tween.EASE_IN_OUT)
	
	await get_tree().create_timer(1.25).timeout
	
	if tween_to:
		tween_to.kill()
	if tween_from:
		tween_from.kill()
	GameLogic.change_state(GameLogic.State.EXPLORING)
	GameLogic.start_countdown.emit()
