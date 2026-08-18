class_name CasettePopup extends Control

@export var casette_sprites: Dictionary[GameData.Memory, Texture] = {}

@onready var casette_texture: TextureRect = get_node("CasetteTexture")
var animation_tween: Tween

func set_casette_and_animate(memory_id: GameData.Memory) -> void:
	casette_texture.texture = casette_sprites[memory_id]
	
	if animation_tween:
		animation_tween.kill()
	animation_tween = get_tree().create_tween().set_parallel(true)
	self.modulate = Color(1,1,1,0)
	var starting_pos: Vector2 = casette_texture.position
	casette_texture.position.y = casette_texture.position.y + 300
	animation_tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	animation_tween.tween_property(casette_texture, "position", starting_pos, 0.5)
