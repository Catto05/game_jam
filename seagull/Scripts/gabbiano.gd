extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var zona_acqua: Area2D = $"../Zona_acqua"
@onready var gabbiano: CharacterBody2D = $"."
@onready var freccia: Sprite2D = $Freccia
@onready var camera_2d: Camera2D = $Camera2D
@export var barca : Node2D = null



const SPEED = 1000.0
const JUMP_VELOCITY = -4000.0

var is_player_controlled
var last_direction_y
var last_directions = Vector2()
var is_in_water = false	
func _physics_process(delta: float) -> void:
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x:= Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	if(direction_x != 0):
		last_directions.x = direction_x
	if direction_y != 0:
		last_directions.y = direction_y
		
	if direction_x or direction_y:
		velocity.x = direction_x * SPEED
		velocity.y = direction_y * SPEED
		if direction_x > 0 and direction_y > 0:
			animated_sprite_2d.play("down-right")
		elif direction_x > 0 and direction_y == 0:	
			animated_sprite_2d.play("right")
		elif direction_x < 0 and direction_y == 0:
			animated_sprite_2d.play("left")
		elif direction_x > 0 and direction_y < 0:
			animated_sprite_2d.play("up-right")
		elif direction_x < 0 and direction_y > 0:
			animated_sprite_2d.play("down-left")
		elif direction_x < 0 and direction_y < 0:
			animated_sprite_2d.play("up-left")
		elif direction_x == 0 and last_directions.x < 0 and direction_y < 0:
			animated_sprite_2d.play("up-right")
			animated_sprite_2d.play("up (right side)")
		elif direction_x == 0 and last_directions.x > 0 and direction_y < 0:
			animated_sprite_2d.play("up-left")
			animated_sprite_2d.play("up (left side)")
		elif direction_x == 0 and last_directions.x < 0 and direction_y > 0:
			animated_sprite_2d.play("down-left")
			animated_sprite_2d.play("down (left side)")
		elif direction_x == 0 and last_directions.x > 0 and direction_y > 0:
			animated_sprite_2d.play("down-right")
			animated_sprite_2d.play("down (right side)")
			
	else:
		if is_in_water == false:
			velocity.x = move_toward(velocity.x, get_gravity().x, SPEED * delta)
			velocity.y = move_toward(velocity.y, get_gravity().y, SPEED * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta)
			velocity.y = move_toward(velocity.y, 0, SPEED * delta)
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
		if last_directions.x == 1 and last_directions.y == -1 :
			animated_sprite_2d.play("up-right")
		elif last_directions.x == -1 and last_directions.y == -1:
			animated_sprite_2d.play("up-left")
			
	
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var corpo_toccato = collision.get_collider()

		# Controlliamo che il corpo esista e sia un pesce
		if corpo_toccato and corpo_toccato.is_in_group("pesci"):
			
			# ==> LA CONDIZIONE CHIAVE: il pesce non è già stato mangiato?
			if not corpo_toccato.is_eaten:
				# Alziamo la "bandierina" per non colpirlo più
				corpo_toccato.is_eaten = true 
				
				print("Ho mangiato il pesce: ", corpo_toccato.name)
				corpo_toccato.queue_free()
				
	move_and_slide()
	
func _on_zona_acqua_body_entered(body: Node2D) -> void:
	if body.is_in_group("Gabbiano"):
		is_in_water = true
		print("in water")


func _on_zona_acqua_body_exited(body: Node2D) -> void:
	if body.is_in_group("Gabbiano"):
		is_in_water = false
		print("not in water")
