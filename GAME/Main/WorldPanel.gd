extends PanelContainer

onready var world_name_label = get_node("box/WorldName/Value")

func _on_world_name_changed( what ):
	world_name_label.set_text( what )

func _ready():
	get_owner().connect("world_name_changed", self, "_on_world_name_changed")
