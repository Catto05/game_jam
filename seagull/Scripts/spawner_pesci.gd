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


# Collegato al segnale timeout() del tuo Timer
func _on_timer_timeout():
	# --- 1. LOTTERIA PER SCEGLIERE LA ZONA ---
	var total_chance = shallow_zone_chance + mid_zone_chance + deep_zone_chance
	if total_chance <= 0: return # Evita errori se tutte le probabilità sono a zero

	var random_choice = randf_range(0, total_chance)
	
	var chosen_zone_fish_list: Array[PackedScene]
	var min_y: float
	var max_y: float
	
	if random_choice < shallow_zone_chance:
		# Scelta la zona SHALLOW
		chosen_zone_fish_list = shallow_fish_scenes
		min_y = 200
		max_y = shallow_depth_threshold
	elif random_choice < shallow_zone_chance + mid_zone_chance:
		# Scelta la zona MID
		chosen_zone_fish_list = mid_depth_fish_scenes
		min_y = shallow_depth_threshold
		max_y = mid_depth_threshold
	else:
		# Scelta la zona DEEP
		chosen_zone_fish_list = deep_fish_scenes
		min_y = mid_depth_threshold
		max_y = mid_depth_threshold + 500 # Esempio: definisci un limite per la profondità massima
		
	# --- 2. SCEGLI UNA POSIZIONE NELLA ZONA SELEZIONATA ---
	var spawn_x = randf_range(-9000, 9000)
	var spawn_y = randf_range(min_y, max_y)
	var spawn_position = Vector2(spawn_x, spawn_y)

	# --- 3. CREA IL PESCE ---
	# Siccome hai un solo pesce per zona, prendiamo semplicemente il primo della lista.
	if not chosen_zone_fish_list.is_empty():
		var fish_scene = chosen_zone_fish_list[0] # Prende il primo (e unico) pesce
		var new_fish = fish_scene.instantiate()
		add_child(new_fish)
		new_fish.global_position = spawn_position
