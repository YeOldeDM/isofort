extends Node

const USER_CFG_PATH = "user://user.cfg"

onready var usr_cfg = ConfigFile.new()

func set_last_world_opened( name ):
	usr_cfg.set_value( "last_session", "world_opened", name )
	usr_cfg.save( USER_CFG_PATH )

func get_last_world_opened():
	if usr_cfg.has_section_key("last_session", "world_opened"):
		return usr_cfg.get_value("last_session", "world_opened")

func _ready():
	print( "BOOT" )
	Globals.in_worldspace = false
	

	var D = Directory.new()
	D.open( "user://" )
	# Create worlds/ folder if non-existent..
	if not D.file_exists( "worlds" ):
		D.make_dir( "worlds" )

	# Open or Create global user config
	var opened = usr_cfg.load( USER_CFG_PATH )
	if opened == OK:
		print( "LOADED USER CFG" )
	else:
		var F = File.new()
		if !F.file_exists( USER_CFG_PATH ):
			# Make a new user.cfg
			usr_cfg.set_value( "meta", "epoch", OS.get_unix_time() )
			usr_cfg.save( USER_CFG_PATH )
			print( "NEW USER CFG CREATED" )
	
