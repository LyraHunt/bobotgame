class_name World extends Node2D

func _ready() -> void:
	SoundManager.play_music((SRM as SoundResourceManager).get_sound("lab")).volume_db = -8
