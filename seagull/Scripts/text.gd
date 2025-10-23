# HUD.gd
extends CanvasLayer
@onready var score: Label = $Score
@onready var potential: Label = $Potential
func _ready():
	# Si collega al segnale del nostro gestore globale
	ScoreManager.score_updated.connect(update_score_text)
	
	# Imposta il valore iniziale
	update_score_text(0)

func update_score_text(new_score: int):
	score.text = "SCORE: %d" %new_score
