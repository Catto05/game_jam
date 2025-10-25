# FishSpawner.gd
extends Node

## --- Liste dei Pesci per Profondità ---
@export_group("Liste Pesci")
@export var shallow_fish_scenes: Array[PackedScene]
@export var mid_depth_fish_scenes: Array[PackedScene]
@export var deep_fish_scenes: Array[PackedScene]

## --- Soglie di Profondità (in pixel sull'asse Y) ---
@export_group("Soglie Profondità")
@export var shallow_depth_threshold: float = 500.0
@export var mid_depth_threshold: float = 1200.0
# La zona "deep" andrà da mid_depth_threshold in giù

## --- PROBABILITÀ DI SPAWN PER ZONA ---
@export_group("Probabilità Zona (0-100)")
# La somma non deve per forza fare 100, sono pesi relativi.
@export var shallow_zone_chance: float = 60.0
@export var mid_zone_chance: float = 30.0
@export var deep_zone_chance: float = 10.0

@export var small_fish: float = 60.0
@export var medium_fish: float = 30.0
@export var big_fish: float = 10.0

# Collegato al segnale timeout() del tuo Timer
func _on_timer_timeout():
	# --- 1. LOTTERIA PER SCEGLIERE LA ZONA ---
	
	var total_chance_size = small_fish + medium_fish + big_fish
	if total_chance_size <= 0: return
	var random_choice_size : float = randf_range(0, total_chance_size)
	var size_vector
	var multiplier
	
	if random_choice_size < small_fish:
		size_vector = Vector2(0.2,0.2)
		multiplier = 1
	elif random_choice_size < small_fish + medium_fish:
		size_vector = Vector2(0.28,0.28)
		multiplier = 1.5
	else:
		size_vector = Vector2(0.35,0.35)
		multiplier = 2
	
	
	
	var total_chance_species = shallow_zone_chance + mid_zone_chance + deep_zone_chance
	if total_chance_species <= 0: return # Evita errori se tutte le probabilità sono a zero
	var random_choice_species = randf_range(0, total_chance_species)
	
	var chosen_zone_fish_list: Array[PackedScene]
	var min_y: float
	var max_y: float
	
	if random_choice_species < shallow_zone_chance:
		# Scelta la zona SHALLOW
		chosen_zone_fish_list = shallow_fish_scenes
		min_y = 200
		max_y = shallow_depth_threshold
	elif random_choice_species < shallow_zone_chance + mid_zone_chance:
		# Scelta la zona MID
		chosen_zone_fish_list = mid_depth_fish_scenes
		min_y = shallow_depth_threshold
		max_y = mid_depth_threshold
	else:
		# Scelta la zona DEEP
		chosen_zone_fish_list = deep_fish_scenes
		min_y = mid_depth_threshold
		max_y = 7990
		
	# --- 2. SCEGLI UNA POSIZIONE NELLA ZONA SELEZIONATA ---
	var spawn_x = randf_range(-9000, 2000)
	var spawn_y = randf_range(min_y, max_y)
	var spawn_position = Vector2(spawn_x, spawn_y)

	# --- 3. CREA IL PESCE ---
	# Siccome hai un solo pesce per zona, prendiamo semplicemente il primo della lista.
	if not chosen_zone_fish_list.is_empty():
		var fish_scene = chosen_zone_fish_list[0] # Prende il primo (e unico) pesce
		var new_fish = fish_scene.instantiate()
		new_fish.scale = size_vector
		new_fish.score = new_fish.score * multiplier
		add_child(new_fish)
		new_fish.global_position = spawn_position
