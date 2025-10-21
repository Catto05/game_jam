# IndicatoreBarca.gd
extends Node2D
@export var target: Node2D
@export var margin: float = 64.0
@onready var arrow_sprite: Sprite2D = $Freccia

var camera: Camera2D

func _ready():
	# Nascondiamo la freccia all'inizio
	arrow_sprite.visible = false
	# Prendiamo un riferimento alla camera attiva
	camera = get_viewport().get_camera_2d()

func _process(delta: float):
	if not is_instance_valid(target) or not camera:
		arrow_sprite.visible = false
		return
		
	# --- 1. CALCOLA IL RETTANGOLO DELLA CAMERA NEL MONDO ---
	# Otteniamo la dimensione dello schermo
	var viewport_size = camera.get_viewport_rect().size
	# Calcoliamo la posizione dell'angolo in alto a sinistra della camera nel mondo
	var camera_top_left_in_world = camera.global_position - viewport_size / 2.0
	# Creiamo un rettangolo che rappresenta la vista della camera nel mondo
	var camera_world_rect = Rect2(camera_top_left_in_world, viewport_size)
	
	var target_pos = target.global_position
	
	# --- 2. CONTROLLA SE LA BARCA È VISIBILE (ORA IL CONFRONTO È CORRETTO) ---
	if camera_world_rect.has_point(target_pos):
		# La barca è inquadrata, nascondi la freccia
		arrow_sprite.visible = false
		return
	else:
		# La barca è fuori, mostra la freccia
		arrow_sprite.visible = true

	# --- 3. CALCOLA LA POSIZIONE DELLA FRECCIA USANDO LE COORDINATE DEL MONDO ---
	# I confini ora sono quelli del rettangolo della camera nel mondo
	var min_x = camera_world_rect.position.x + margin
	var max_x = camera_world_rect.end.x - margin
	var top_y = camera_world_rect.position.y + margin
	
	var indicator_x = clamp(target_pos.x, min_x, max_x)
	var indicator_y = top_y
	
	global_position = Vector2(indicator_x, indicator_y)
	
	# --- 4. LA ROTAZIONE RIMANE IDENTICA ---
	rotation = (target_pos - global_position).angle()
