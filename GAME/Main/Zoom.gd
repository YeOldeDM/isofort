extends PanelContainer

signal set_zoom( to )

func _ready():
	var menu = get_node("box/OptionButton").get_popup()
	menu.connect("item_pressed", self, "_on_OptionButton_item_pressed")

func _on_OptionButton_item_pressed( ID ):
	emit_signal("set_zoom", ID)


