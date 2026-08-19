class_name CasetteOption extends MarginContainer

signal selected(current_memory_id: GameData.Memory)

@onready var casette_sprite: TextureRect = get_node("Panel/TextureRect")
@onready var casette_label: RichTextLabel = get_node("Control/RichTextLabel")

var current_memory_id: GameData.Memory

func update_display(memory_id: GameData.Memory) -> void:
	current_memory_id = memory_id
	casette_sprite.texture = GameData.memory_casette_sprites[memory_id]
	casette_label.text = "[font_size=32w]" + GameData.robot_ids[memory_id] + "'s[br]MEMORY BANK"

func select() ->  void:
	selected.emit(current_memory_id)

func _on_gui_input(event: InputEvent) -> void:
	print(event)
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).pressed:
			select()


func _on_button_pressed() -> void:
	pass
	#select()
