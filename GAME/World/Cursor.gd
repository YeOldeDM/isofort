extends Sprite

signal cell_hovered( cell )

onready var map

func get_cursor_pos():
	return map.world_to_map(get_pos())

func _input(event):
	var opos = get_cursor_pos()
	if event.type == InputEvent.MOUSE_MOTION:
		var mpos = map.get_local_mouse_pos()
	
		set_pos( map.map_to_world( map.world_to_map(mpos) ) )
		if 'in_worldspace' in Globals:
			set_hidden( !Globals.in_worldspace )
			if Globals.in_worldspace:
				if get_cursor_pos() != opos:
					emit_signal("cell_hovered", get_cursor_pos())

