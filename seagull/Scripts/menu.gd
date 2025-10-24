# MenuScreen.gd
extends CanvasLayer
@onready var start_button: Button = $Resume
@onready var quit_button: Button = $Quit


func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	# FONDAMENTALE: Il menu deve funzionare anche quando il gioco è in pausa
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_start_button_pressed():
	# Il pulsante non fa altro che chiamare la funzione per togliere la pausa.
	# Il GameManager si occuperà di distruggere il menu e cambiare lo stato.
	GameManager.toggle_pause_menu()

func _on_quit_button_pressed():
	get_tree().quit()
