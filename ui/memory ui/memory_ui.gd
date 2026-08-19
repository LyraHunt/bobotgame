class_name MemoryUI extends Control

@onready var lore_container: VBoxContainer = get_node("HBoxContainer/LoreContainer")
@onready var casette_container: VBoxContainer = get_node("HBoxContainer/CasetteContainer")

func update_display() -> void:
	var casette_container_children: Array[Node] = casette_container.get_children()
	var casette_options: Array[CasetteOption]
	for casette_container_child: Node in casette_container_children:
		if casette_container_child is CasetteOption:
			casette_options.append(casette_container_child as CasetteOption)
	
	var casette_option_index: int = 0
	for casette_option: CasetteOption in casette_options:
		if GameData.acquired_memories.size() > casette_option_index:
			casette_option.update_display(GameData.acquired_memories[casette_option_index])
			casette_option.visible = true
		else:
			casette_option.visible = false
		casette_option_index += 1
