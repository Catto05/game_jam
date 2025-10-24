# GameOverScreen.gd
extends CanvasLayer

@onready var replay_button: Button = $Button # Assicurati che il nome del nodo sia Button

func _ready():
	# Nascondiamo la schermata all'inizio
	hide()
	# Colleghiamo il segnale del pulsante alla nostra funzione
	replay_button.pressed.connect(_on_replay_button_pressed)

func _on_replay_button_pressed() -> void:
	GameManager.restart_game()
