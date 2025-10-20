extends Node2D

@onready var fish_var = preload("res://Scenes/pesce.tscn")
@export var SpawnUnites:PackedScene
@export var SpawnUnitesAmount:int


func _on_timer_timeout() -> void:
	var fish = fish_var.instantiate()
	fish.position = position
	get_parent().get_node("spawner_pesci").add_child(fish)
	fish.add_to_group("pesci")

	
