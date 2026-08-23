class_name DocumentOption extends MarginContainer

signal selected(current_document_id: GameData.Document)

@onready var casette_sprite: TextureRect = get_node("ControlCasette/CasetteSprite")
@onready var casette_label: RichTextLabel = get_node("ControlLabel/CasetteLabel")
@onready var button: Button = get_node("Control/Button")

var current_document_id: GameData.Document

func update_display(document_id: GameData.Document) -> void:
	casette_sprite.visible = true
	casette_label.visible = true
	button.focus_mode = Control.FOCUS_ALL
	
	current_document_id = document_id
	casette_label.text = "[font_size=32w]" + GameData.document_titles[document_id]

func show_blank() -> void:
	casette_sprite.visible = false
	casette_label.visible = false
	button.focus_mode = Control.FOCUS_NONE

func select() ->  void:
	if casette_sprite.visible:
		selected.emit(current_document_id)

func _on_button_button_down() -> void:
	select()
