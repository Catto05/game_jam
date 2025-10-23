# Script per il nodo Label del punteggio
extends Label

# Un margine per non avere il testo appiccicato al bordo
@export var margin: Vector2 = Vector2(20, 20)
@onready var camera: Camera2D = $".."


func _process(_delta):
	# Questa funzione viene eseguita a ogni frame per mantenere il testo al posto giusto

	# 1. Otteniamo il rettangolo di ciò che la camera sta inquadrando
	var view_rect = camera.get_viewport_rect()

	# 2. Calcoliamo la posizione in alto a destra di questo rettangolo
	#    La posizione è relativa al centro della camera (il punto 0,0)
	var top_right_position = Vector2(0, view_rect.size.y / 2)

	# 3. Applichiamo la posizione al nostro Label, sottraendo il margine
	#    per spostarlo un po' verso l'interno dello schermo
	position = top_right_position - Vector2(margin.x, -margin.y)
