class_name CasetteOption extends MarginContainer

@onready var casette_sprite: TextureRect = get_node("Panel/TextureRect")
@onready var casette_label: RichTextLabel = get_node("Control/RichTextLabel")

func update_display(memory_id: GameData.Memory) -> void:
	casette_sprite.texture = GameData.memory_casette_sprites[memory_id]
	casette_label.text = "[font_size=32w]" + GameData.robot_ids[memory_id] + "'s[br]MEMORY BANK"
