# HUD.gd
extends CanvasLayer
@onready var score: Label = $Score
@onready var partial_score: Label = $Partial_score

func _ready():
	# Si collega al segnale del nostro gestore globale
	ScoreManager.total_score_updated.connect(update_score_text)
	ScoreManager.partial_score_updated.connect(update_potential_score_text)
	
	# Imposta il valore iniziale
	update_score_text(0)
	update_potential_score_text(0)

func update_score_text(new_score: int):
	score.text = "SCORE: %d" %new_score
	
func update_potential_score_text(new_score:int):
	partial_score.text = "PARTIAL SCORE: %d" %new_score
