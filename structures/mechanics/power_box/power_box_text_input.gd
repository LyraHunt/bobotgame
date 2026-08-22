class_name PowerBoxTextInput
extends Control

signal text_entered()

## Node that will show when a text input field is reached.
## Should be connected to a (probably contained) label, a line edit and a button to work.

## The LineEdit to use.
@export var input_line_edit: LineEdit
## The Label to use.
@export var text_label: Label
## The Button to use.
@export var confirmation_button: Button

@export var prompt_message: String = "Description:"
@export var answers: Array[String] = ["answer"]

var correct: bool = false

func _ready() -> void:
	if input_line_edit:
		input_line_edit.text_changed.connect(_on_input_text_changed)
	#visible = false
	text_label.text = prompt_message


func set_text(text:String) -> void:
	if text_label is Label:
		text_label.text = text


func set_placeholder(placeholder:String) -> void:
	if input_line_edit is LineEdit:
		input_line_edit.placeholder_text = placeholder
		input_line_edit.grab_focus()


func set_default(default:String) -> void:
	if input_line_edit is LineEdit:
		input_line_edit.text = default
		_on_input_text_changed(default)


func _on_input_text_changed(text:String) -> void:
	correct = answers.has(text.to_lower())
	if correct:
		input_line_edit.self_modulate = Color.GREEN
	else:
		input_line_edit.self_modulate = Color.RED
	text_entered.emit()
