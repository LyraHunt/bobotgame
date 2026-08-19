class_name Camera extends Camera2D

var focus: bool
var default_zoom: Vector2 = Vector2(1.2, 1.2)

var zoom_tween: Tween

func _ready() -> void:
	GameLogic.state_changed.connect(game_state_changed)
	start_focus()

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
