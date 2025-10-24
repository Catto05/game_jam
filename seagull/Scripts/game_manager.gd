# GameManager.gd
extends Node

# --- STATI DEL GIOCO ---
enum State { MENU, PLAYING, GAME_OVER }
var current_state: State

# --- RIFERIMENTI ALLE SCENE ---
var menu_scene = preload("res://Scenes/menu.tscn")
var game_over_scene = preload("res://Scenes/game_over_screen.tscn")

# *** LA VARIABILE CHIAVE ***
# Qui ci ricorderemo del menu quando lo creiamo.
var menu_instance = null
var game_over_instance = null

# --- FUNZIONI PRINCIPALI ---

func _ready():
    current_state = State.MENU
    # Mettiamo in pausa e mostriamo il menu iniziale
    get_tree().paused = true
    show_menu()

func _unhandled_input(event):
    if Input.is_action_just_pressed("toggle_pause"):
        if current_state == State.PLAYING or get_tree().paused:
            toggle_pause_menu()

# --- FUNZIONI DI GESTIONE DEL MENU ---

func show_menu():
    # Controlliamo che non esista già un menu prima di crearne uno nuovo
    if not is_instance_valid(menu_instance):
        menu_instance = menu_scene.instantiate()
        add_child(menu_instance)

# In GameManager.gd

func hide_menu():
    if is_instance_valid(menu_instance):
        remove_child(menu_instance)
        menu_instance.queue_free()
        menu_instance = null

# Questa funzione ora è molto più pulita
func toggle_pause_menu():
    get_tree().paused = not get_tree().paused
    
    if get_tree().paused:
        # Se mettiamo in pausa, mostriamo il menu
        show_menu()
    else:
        # Se togliamo la pausa, nascondiamo il menu
        hide_menu()
        current_state = State.PLAYING

# --- FUNZIONI DI GIOCO ---

func end_game():
    if current_state == State.PLAYING:
        current_state = State.GAME_OVER
        get_tree().paused = true
        # Qui puoi aggiungere la logica per la schermata di game over
        if not is_instance_valid(game_over_instance):
            game_over_instance = game_over_scene.instantiate()
            add_child(game_over_instance)
            game_over_instance.show()


func restart_game():
    if is_instance_valid(game_over_instance):
        remove_child(game_over_instance)
        game_over_instance.queue_free()
        game_over_instance = null
    get_tree().paused = false
    current_state = State.PLAYING
    if ScoreManager:
        ScoreManager.total_score = 0
        ScoreManager.partial_score = 0
        
    get_tree().change_scene_to_file("res://Scenes/game.tscn")
