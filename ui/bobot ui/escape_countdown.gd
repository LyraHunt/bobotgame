class_name EscapeCountdown extends Control

@onready var label: RichTextLabel = get_node("RichTextLabel")

var timer_ref: Timer

func _process(_delta: float) -> void:
	if timer_ref:
		label.text = "[font_size=120]0:%02d" % timer_ref.time_left
		if floori(timer_ref.time_left) % 2 == 0:
			label.modulate = Color.YELLOW
		else:
			label.modulate = Color.RED
