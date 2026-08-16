class_name AnimatedShader2DComponent extends AnimatedSprite2D

var last_texture: Texture2D

func _ready() -> void:
	self.frame_changed.connect(_update_shader_texture)
	self.animation_changed.connect(_update_shader_texture)

func _update_shader_texture() -> void:
	if material and material is ShaderMaterial:
		var current_texture: Texture2D = self.get_sprite_frames().get_frame_texture(self.animation, self.frame)
		if current_texture != last_texture:
			#print(self.get_sprite_frames().get_frame_texture(self.animation, self.frame))
			(material as ShaderMaterial).set_shader_parameter("sprite_texture", current_texture)
			last_texture = current_texture
