class_name World extends Node2D

func _ready() -> void:
	SoundManager.set_default_music_bus("Music")
	SoundManager.set_default_sound_bus("SoundEffects")
	SoundManager.play_music((SRM as SoundResourceManager).get_sound("lab"))
