extends Node2D


const MATERIALS = {
	"AIR":-1, "SPACE":0,
	"DIRT":1, "SOIL":2, "GRASS":3,
	"ROCK":4, "STONE":5,
	"WOOD":6, "BRICK":7,
	"WATER":8, "LAVA":9,
	}

var ZERO_DEPTH = 0
var DIRT_DEPTH = 0

signal world_name_changed( to )
signal level_changed( to )
signal drew()
signal map_ready()


onready var floor_map = get_node("Floor")
onready var wall_map = get_node("Wall")

onready var floors = [floor_map]
onready var walls = [wall_map]

onready var cursor = get_node("Cursor")

onready var save_icon = get_node("HUD/SaveIcon")

onready var fx = get_node("WorldFX")

var bounds = Vector3(64,64,20)
var map = [[[]]]
var world_name = "" setget _set_world_name

var level = 0 setget _set_level
var L = 0	# accumulator for tile painter

func start_map( data=null ):
	get_node("HUD/WorldSpace/GenScreen").popup_centered()
	if data==null: make_map()
	else:
		if 'bounds' in data:
			self.bounds = Vector3( data.bounds.x, data.bounds.y, data.bounds.z )
		if 'zero' in data:
			self.ZERO_DEPTH = data.zero
		if 'map' in data:
			self.map = data.map
		if 'name' in data:
			self.world_name = data.name
		make_layers()
	set_process(true)
	self.level = ZERO_DEPTH
	

func new_map( data ):
	self.world_name = data.name
	self.bounds = data.bounds
	self.ZERO_DEPTH = data.zero
	self.DIRT_DEPTH = data.dirt
	start_map()

func save_map():
	print( "Getting map data for "+self.world_name )
	return {
		"name":		self.world_name,
		"bounds":	{"x":bounds.x,"y":bounds.y,"z":bounds.z},
		"zero":	ZERO_DEPTH,
		"map":	map,
		}

func get_cell( x,y,z ):
	return map[x][y][z]

func make_cell( wall_material=-1, floor_material=-1 ):
	return {"wall":wall_material, "floor":floor_material}


func fill_cell( x,y,z, idx ):
	wall_cell(x,y,z,idx)
	floor_cell(x,y,z,idx)

func wall_cell( x,y,z, idx ):
	var cell = get_cell(x,y,z)
	cell['wall'] = idx

func floor_cell( x,y,z, idx ):
	var cell = get_cell(x,y,z)
	cell['floor'] = idx

func is_cell_clear( x,y,z ):
	return !cell_has_wall(x,y,z) and !cell_has_floor(x,y,z)

func get_cell_wall( x,y,z ):
	return get_cell(x,y,z)['wall']

func get_cell_floor( x,y,z ):
	var cell = get_cell(x,y,z-1)
	if !cell_has_floor(x,y,z-1):
		return cell['wall']
	return cell['floor']

func cell_has_wall( x,y,z ):
	return get_cell(x,y,z)['wall'] != -1

func cell_has_floor( x,y,z ):
	return get_cell(x,y,z)['floor'] != -1

func get_init_material(z):
	var i = MATERIALS.AIR
	if z <= 0:
		i = MATERIALS.LAVA
	elif z < ZERO_DEPTH-DIRT_DEPTH:
		i = MATERIALS.ROCK
	elif z < ZERO_DEPTH-1:
		i = MATERIALS.DIRT
	elif z == ZERO_DEPTH-1:
		i = MATERIALS.GRASS
	return i

func make_map():
	map = []
	for x in range(bounds.x):
		var col = []
		for y in range(bounds.y):
			var stk = []
			for z in range(bounds.z):
				var m = get_init_material(z)
				stk.append(make_cell(m,m))
			col.append(stk)
		map.append(col)
	make_layers()

func make_layers():
	for z in range(1,bounds.z):
		var new_floor = floors[z-1].duplicate()
		add_child(new_floor)
		floors.append(new_floor)
		var new_wall = walls[z-1].duplicate()
		add_child(new_wall)
		walls.append(new_wall)

func is_dark( x,y,z ):
	for h in range( z, map[0][0].size() ):
		if !is_cell_clear(x,y,h):
			return true
	return false


# Draw a cell
func draw_cell( x,y,z ):
	# get wall/floor index
	var w = get_cell_wall(x,y,z)
	var f = get_cell_floor(x,y,z)
	# calc dark tiles
	if w >=0 && is_dark(x,y,z+1):
		w += MATERIALS.size() - 1

	if f >=0 && is_dark(x,y,z):
		f += MATERIALS.size() - 1

	# set cells
	walls[z].set_cell( x, y, w )
	floors[z].set_cell( x, y, f )


# Draw an entire z layer
func draw_map( z ):
	walls[z].clear()
	floors[z].clear()
	for x in range(bounds.x):
		for y in range(bounds.y):
			draw_cell(x,y,z)
	emit_signal("drew")


# Set a cell, either wall, floor or both
func set_cell_data(mode, cell, idx ):
	var x = 0 <= cell.x and cell.x <= bounds.y - 1
	var y = 0 <= cell.y and cell.y <= bounds.y - 1
	var z = 0 <= cell.z and cell.z <= bounds.z - 1
	if x and y and z:
		if mode == 0:
			fill_cell( cell.x, cell.y, cell.z, idx )
		elif mode == 1:
			wall_cell( cell.x, cell.y, cell.z, idx )
		elif mode == 2:
			floor_cell( cell.x, cell.y, cell.z-1, idx )
		for z in range( bounds.z ):
			draw_cell( cell.x, cell.y, z )

func show_map( z ):
	for i in range(walls.size()):
		walls[i].hide()
	for i in range(floors.size()):
		floors[i].hide()
	floors[z].show()
	walls[z].show()
	walls[z].raise()

func end():
	Data.close_world( self.world_name )
	return OK

# Find the 'surface' z level at a point
#(broken?)
#func get_surface_z( x, y ):
#	var z = map[x][y].size()
#	while z > 0:
#		if is_dark( x,y,z ):
#			print(z-1)
#			return z-1
#		z -= 1
#	return 0





func _ready():
	
	#start_map(Data.restore_world(world_name))
#	self.world_name = NameGen.GetName()
	cursor.map = wall_map
	cursor.raise()
	cursor.set_process_input(true)
	get_parent().connect("saving_world", self, "_on_saving_world")
	get_parent().connect("saved_world", self, "_on_saved_world")

func _process(delta):
	if L >= bounds.z-1:
		print("DONE!")
		get_node("HUD/WorldSpace/GenScreen").queue_free()
		set_process(false)
		emit_signal("map_ready")
	

	
	draw_map(L)
	yield(self, "drew")
	L += 1



func _set_level( what ):
	level = clamp( what, 0, bounds.z - 1 )
	show_map( level )
	emit_signal("level_changed", level)


func _on_LevelControl_level_changed( by ):
	self.level += by



func _set_in_worldspace( inside ):
	Globals.in_worldspace = inside


func _set_world_name( what ):
	world_name = what
	emit_signal("world_name_changed", world_name)


func _on_saving_world():
	pass
#	save_icon.show()
#	save_icon.raise()

func _on_saved_world():
	pass
#	save_icon.hide()






