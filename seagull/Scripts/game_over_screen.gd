# GameOverScreen.gd
extends CanvasLayer

@onready var replay_button: Button = $Button # Assicurati che il nome del nodo sia Button

func _ready():
	# Nascondiamo la schermata all'inizio
	hide()
	# Colleghiamo il segnale del pulsante alla nostra funzione
	replay_button.pressed.connect(on_replay_button_pressed)

func on_replay_button_pressed():
	# Quando il pulsante viene premuto, diciamo al regista di riavviare il gioco
	GameManager.restart_game()
