class_name SoundResourceManager extends Node

@export var sound_lists: Dictionary[String, SoundResourceList]
#@export var sound_1: AudioStream

#@export var wood: SoundResourceList

func get_sound(sound_name: String) -> AudioStream:
	var sound_to_return: AudioStream = AudioStream.new()
	assert(sound_lists.has(sound_name), "Sound file not found: " + sound_name)
	if sound_lists.has(sound_name):
		sound_to_return = sound_lists[sound_name].sounds.pick_random()
	return sound_to_return
