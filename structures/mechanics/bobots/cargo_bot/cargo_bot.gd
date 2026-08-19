class_name CargoBot extends Node2D

@onready var second_shader_pass_component: SecondShaderPassComponent = get_node("SecondShaderPassComponent")
@onready var memory_bank: MemoryBank = get_node("MemoryBank")


func _on_proximity_interaction_component_selection_update(selected: bool) -> void:
	if selected and not memory_bank.been_collected:
		second_shader_pass_component.start_mirroring()
	else:
		second_shader_pass_component.stop_mirroring()


func _on_memory_bank_collected() -> void:
	if second_shader_pass_component and second_shader_pass_component.is_mirroring:
		second_shader_pass_component.stop_mirroring()
