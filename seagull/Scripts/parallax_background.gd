# Script per il ParallaxBackground
extends ParallaxBackground

func _process(delta):
	# Aggiorniamo la posizione dello sfondo in base alla posizione della camera
	scroll_offset = get_viewport().get_camera_2d().global_position
