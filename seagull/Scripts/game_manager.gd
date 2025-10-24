# GameManager.gd
extends Node

# Definiamo i possibili stati del nostro gioco
enum State { PLAYING, GAME_OVER }

# La variabile che tiene traccia dello stato attuale
var current_state: State = State.PLAYING

# Una reference alla nostra schermata di Game Over (la collegheremo nell'editor)
@export var game_over_screen: CanvasLayer

# Funzione chiamata quando il giocatore muore
func end_game():
	if current_state == State.PLAYING:
		print("GAME OVER!")
		current_state = State.GAME_OVER
		# Mostra la schermata di game over
		if game_over_screen:
			game_over_screen.show()
		# Mette in pausa il gioco (tutto si ferma)
		get_tree().paused = true

# Funzione chiamata dal pulsante "Replay"
func restart_game():
	print("miao")
	# Togliamo la pausa prima di ricaricare
	get_tree().paused = false
	# Il modo più semplice per resettare TUTTO è ricaricare la scena attuale
	get_tree().reload_current_scene()
