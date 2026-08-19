class_name Camera extends Camera2D

var charging: bool

func _ready() -> void:
	GameLogic.state_changed.connect(game_state_changed)
	start_charge()

func game_state_changed() -> void:
	match GameLogic.state:
		GameLogic.State.CHARGING, GameLogic.State.REMBERING:
			start_charge()
		_:
			stop_charge()

func start_charge() -> void:
	charging = true
	zoom = Vector2.ONE * 2

func stop_charge() -> void:
	charging = false
	zoom = Vector2.ONE
