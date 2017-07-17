extends PanelContainer

onready var value_label = get_node("box/label/value")

signal level_changed( by )




func _on_button_pressed( value ):
	emit_signal( "level_changed", value )



func _on_World_level_changed( to ):
	value_label.set_text( "Lv %s" % str(to - 10) )
