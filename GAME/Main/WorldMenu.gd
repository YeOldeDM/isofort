extends PopupPanel

signal menu_selected( what )

onready var main = get_node("/root/Main")

func toggle_menu():
	if is_hidden():
		popup_centered()
	else: hide()

func _ready():
	set_process_input(true)
	connect("menu_selected", main, "_on_menu_selected")

# Catch ESC presses and toggle world menu
func _input(event):
	if event.type == InputEvent.KEY:
		if event.scancode and event.pressed and !event.is_echo():
			toggle_menu()



# Menu button callbacks
func _on_Resume_pressed():
	hide()


func _on_Save_pressed():
	emit_signal( "menu_selected", main.MAIN_ACTION.SAVE_WORLD )


func _on_Options_pressed():
	get_node("../Prefs").popup_centered()


func _on_Exit_pressed():
	emit_signal( "menu_selected", main.MAIN_ACTION.EXIT )


func _on_Quit_pressed():
	emit_signal( "menu_selected", main.MAIN_ACTION.QUIT )





