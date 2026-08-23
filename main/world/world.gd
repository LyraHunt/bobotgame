class_name World extends Node2D

@onready var canvas_modulate: CanvasModulate = get_node("CanvasModulate")
@onready var flicker_timer: Timer = get_node("LightsFlickerTimer")

@export var flicker_amount: int = 12

var flicker_count: int = 0

func _ready() -> void:
	GameLogic.power_on.connect(powered_on)
	GameLogic.failed_countdown.connect(power_lights_off)

func powered_on() -> void:
	#canvas_modulate.color = Color.WHITE
	flicker_timer.start()
	SoundManager.stop_music(0.4)
	get_tree().create_timer(3).timeout.connect(GameLogic.pan_to_door)
	
	var escape: AudioStreamPlayer = SoundManager.play_music((SRM as SoundResourceManager).get_sound("escape"))
	await get_tree().process_frame
	await get_tree().process_frame
	escape.volume_db = -8


func _on_lights_flicker_timer_timeout() -> void:
	if flicker_count < flicker_amount:
		if randf_range(flicker_count / (flicker_amount * 1.75), 1.0) > 0.5:
			canvas_modulate.color = Color.WHITE
		else:
			canvas_modulate.color = Color("9b97a8")
		flicker_count += 1
	else:
		flicker_timer.stop()
		canvas_modulate.color = Color.WHITE

func power_lights_off() -> void:
	canvas_modulate.color = Color("9b97a8")
