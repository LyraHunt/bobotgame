class_name CasetteOption extends MarginContainer

signal selected(current_memory_id: GameData.Memory)

@onready var casette_sprite: TextureRect = get_node("ControlCasette/CasetteSprite")
@onready var casette_label: RichTextLabel = get_node("ControlLabel/CasetteLabel")
@onready var button: Button = get_node("Button")

var current_memory_id: GameData.Memory

func update_display(memory_id: GameData.Memory) -> void:
	casette_sprite.visible = true
	casette_label.visible = true
	button.focus_mode = Control.FOCUS_ALL
	
	current_memory_id = memory_id
	casette_sprite.texture = GameData.memory_casette_sprites[memory_id]
	casette_label.text = "[font_size=32w]" + GameData.robot_ids[memory_id] + "'s[br]MEMORY BANK"

func show_blank() -> void:
	casette_sprite.visible = false
	casette_label.visible = false
	button.focus_mode = Control.FOCUS_NONE

func select() ->  void:
	if casette_sprite.visible:
		selected.emit(current_memory_id)

"""func _on_gui_input(event: InputEvent) -> void:
	print(event)
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).pressed:
			pass
			#select()"""


func _on_button_button_down() -> void:
	select()
