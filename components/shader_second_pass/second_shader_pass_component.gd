class_name SecondShaderPassComponent extends Sprite2D

@export var target_sprite: Sprite2D
@export var mirror_on_load: bool = false

var sub_viewport: SubViewport
var target_sprite_dupe: Sprite2D
var result_sprite: Sprite2D

var is_mirroring: bool = false
var target_sprite_was_visible: bool = false

func _ready() -> void:
	if mirror_on_load:
		call_deferred("start_mirroring")

func start_mirroring() -> void:
	is_mirroring = true
	
	if target_sprite:
		sub_viewport = SubViewport.new()
		sub_viewport.transparent_bg = true
		sub_viewport.size = target_sprite.texture.get_size() * target_sprite.scale
		add_sibling(sub_viewport)
		#target_sprite.reparent(sub_viewport)
		
		target_sprite_dupe = target_sprite.duplicate()
		target_sprite_dupe.offset = Vector2.ZERO
		sub_viewport.add_child(target_sprite_dupe)
		target_sprite_dupe.texture = target_sprite.texture
		target_sprite_dupe.centered = false
		
		texture = sub_viewport.get_texture()
		visible = true
		offset = target_sprite.offset * target_sprite.scale
		
		target_sprite_was_visible = target_sprite.visible
		target_sprite.visible = false
	

func stop_mirroring() -> void:
	is_mirroring = false
	
	if target_sprite:
		if sub_viewport:
			sub_viewport.queue_free()
			sub_viewport = null
			#target_sprite.reparent(sub_viewport)
		
		if target_sprite_dupe:
			target_sprite_dupe.queue_free()
			target_sprite_dupe = null
		
		texture = null
		visible = false
		
		target_sprite.visible = target_sprite_was_visible
		print("stop mirror - " + str(target_sprite_was_visible))

# for testing
"""func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape_key"):
		if is_mirroring:
			stop_mirroring()
		else:
			start_mirroring()"""
