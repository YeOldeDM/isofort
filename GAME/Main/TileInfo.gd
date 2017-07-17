extends PanelContainer

onready var cell_label = get_node("box/cell/value")
onready var data_label = get_node("box/data/value")



func _on_Cursor_cell_hovered( cell ):
	var z = get_node("../../../").level - 10
	cell_label.set_text( "x%s y%s z%s" % [ str(cell.x), str(cell.y), str(z) ] )
