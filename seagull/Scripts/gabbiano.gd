extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var zona_acqua: Area2D = $"../Zona_acqua"
@onready var gabbiano: CharacterBody2D = $"."
@onready var camera_2d: Camera2D = $Camera2D
@export var barca : Node2D = null
@onready var progress_bar: TextureProgressBar = $CanvasLayer/TextureProgressBar



const SPEED = 1000.0
const JUMP_VELOCITY = -4000.0

var is_player_controlled
var last_direction_y
var last_directions = Vector2()
var is_in_water = false	
var oxygen_seconds_left:float = 25:
	set(new_oxygen):
		if new_oxygen < 0:
			oxygen_seconds_left = 0
		elif new_oxygen > 25:
			oxygen_seconds_left = 25
		else:
			oxygen_seconds_left = new_oxygen
var is_dead:bool
var has_played_full_oxygen_sound = false
var has_played_empty_oxygen_sound = false
func _physics_process(delta: float) -> void:
	if GameManager.current_state != GameManager.State.PLAYING:
		return
	movements(delta)
	progress_bar_func(delta)
	jump_boost()
	collisions()
	if check_oxygen():
		GameManager.end_game()
	move_and_slide()

func check_oxygen():
	if oxygen_seconds_left == 0.0:
		is_dead = true
	else:
		is_dead = false
	return is_dead
func movements(delta):
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
func progress_bar_func(delta):
	if is_in_water:
		oxygen_seconds_left -= delta
	else:
		oxygen_seconds_left += delta * 3
	progress_bar.value = (oxygen_seconds_left* 100) / 25
	
	if oxygen_seconds_left == 25 and not has_played_full_oxygen_sound:
		SoundManager.play_sfx("oxygen_full")
		has_played_full_oxygen_sound = true
	elif oxygen_seconds_left < 25:
		has_played_full_oxygen_sound = false
		
	if oxygen_seconds_left < 5 and not has_played_empty_oxygen_sound:
		SoundManager.play_sfx("oxygen_empty")
		has_played_empty_oxygen_sound = true
	elif oxygen_seconds_left > 5:
		has_played_empty_oxygen_sound = false
func collisions():
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var corpo_toccato = collision.get_collider()
			# Controlliamo che il corpo esista e sia un pesce
			if corpo_toccato and corpo_toccato.get_collision_layer_value(3): # Layer 3 è "pesci":
				# ==> LA CONDIZIONE CHIAVE: il pesce non è già stato mangiato?
				if not corpo_toccato.is_eaten:
					# Alziamo la "bandierina" per non colpirlo più
					corpo_toccato.is_eaten = true 
					print("Ho mangiato il pesce: ", corpo_toccato.name)
					ScoreManager.add_partial_score(corpo_toccato.score)
					SoundManager.play_sfx("eat")
					print(ScoreManager.partial_score)
					corpo_toccato.queue_free()
func _on_zona_acqua_body_entered(body: Node2D) -> void:
	if body.is_in_group("Gabbiano"):
		is_in_water = true
		SoundManager.play_sfx("jump_in")
		print("in water")
func jump_boost():
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
		if last_directions.x == 1 and last_directions.y == -1 :
			animated_sprite_2d.play("up-right")
		elif last_directions.x == -1 and last_directions.y == -1:
			animated_sprite_2d.play("up-left")
func _on_zona_acqua_body_exited(body: Node2D) -> void:
	if body.is_in_group("Gabbiano"):
		is_in_water = false
		SoundManager.play_sfx("jump_out")
		print("not in water")
func _on_checkpoint_body_entered(body: Node2D) -> void:
	if body.is_in_group("Gabbiano"):
		ScoreManager.bank_partial_score()
		print("checkpoint")
func _on_checkpoint_body_exited(body: Node2D) -> void:
	if body.is_in_group("Gabbiano"):
		print("not checkpoint")
