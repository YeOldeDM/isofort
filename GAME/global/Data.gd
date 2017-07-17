extends Node

signal world_saved()


const PATH = "user://"
const WORLDPATH = "user://worlds/"
const WORLD_FILE = "/world.cube"


#var DIR = Directory.new()


var world_dir = Directory.new()


func get_open_world_path():
	return world_dir.get_current_dir()

func open_world( name ):
	var opened = world_dir.open( WORLDPATH + name )
	return opened

func close_world( name ):
	BOOT.set_last_world_opened( name )


func make_world( name ):
	var D = Directory.new()
	var opened = D.open( WORLDPATH )
	var exists = D.file_exists( name )
	if not exists:
		D.make_dir( name )
		return open_world( name )
	else:
		print( "Folder already exists at " + WORLDPATH + name )
		return ERR_FILE_BAD_PATH
	return opened
	
func save_world( data ):
	var file = File.new()
	var name = data.name
	var world_path = get_open_world_path()
	print("Saving to "+world_path)

	var opened = file.open(world_path + WORLD_FILE, File.WRITE)
	if opened == OK:
		file.store_line( data.to_json() )
		print("Saved World Cube!")
		file.close()
	
	print("\nSAVE GAME OK!\n" if opened==OK else "\n!!!GAME NOT SAVED!!!\n")
	emit_signal("world_saved")
	return opened


func restore_world( name ):
	var opened = open_world( name )
	if opened == OK:
		var file = File.new()
		var path = get_open_world_path() + WORLD_FILE
		var opened = file.open( path, File.READ)
		if opened == OK:
			var data = {}
			while not file.eof_reached():
				data.parse_json( file.get_line() )
			file.close()
			print( "  Found World File for " + data.name )
			return data
		print( "!!! NO WORLD FILE FOUND FOR " + name + " !!!" )
		return opened
	print( "!!! NO FOLDER FOUND FOR WORLD " + name + " !!!" )
	return opened


func get_worlds():
	var D = Directory.new()
	var opened = D.open( "user://worlds" )
	assert opened == OK
	# Get a list of world folders in user://worlds/
	var names = []
	D.list_dir_begin()
	var filename = D.get_next()
	while filename != "":
		if D.current_is_dir() and !filename.begins_with("."):
			names.append( filename )
		filename = D.get_next()
	return names


func _ready():
	print("DATA")

	
	
	
	
	
	
	
	
	
