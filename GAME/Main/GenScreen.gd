extends PopupPanel

onready var bar = get_node("box/bar")



func _on_tick():
	bar.set_value( min( bar.get_value()+1, bar.get_max() ) )


func _on_GenScreen_about_to_show():
	get_node("../../../").connect("drew", self, "_on_tick")
	bar.set_max( get_node("../../../").bounds.z )
	bar.set_value(0)
