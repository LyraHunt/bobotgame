class_name PowerBoxPassword extends Control

signal closed
signal completed

var children_inputs: Array[PowerBoxTextInput]
@onready var container: VBoxContainer = get_node("VBoxContainer")

func _ready() -> void:
	var children: Array[Node] = container.get_children()
	var children_of_type: Array[PowerBoxTextInput]
	for child: Node in children:
		if child is PowerBoxTextInput:
			children_of_type.append(child as PowerBoxTextInput)
	
	children_inputs = children_of_type
	for input: PowerBoxTextInput in children_inputs:
		input.text_entered.connect(check_valid)

func update_display() -> void:
	if children_inputs.size() > 0:
		children_inputs[0].input_line_edit.grab_focus()

func check_valid() -> void:
	var all_valid: bool = true
	for input: PowerBoxTextInput in children_inputs:
		all_valid = all_valid and input.correct
	if all_valid:
		all_correct()

func all_correct() -> void:
	completed.emit()

func _on_close_button_button_down() -> void:
	closed.emit()

func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed("escape_key"):
			if (event as InputEventKey).keycode != Key.KEY_BACKSPACE:
				closed.emit()
		elif event is InputEventKey and event.is_pressed() and (event as InputEventKey).key_label == KEY_BACKSLASH:
			all_correct()
