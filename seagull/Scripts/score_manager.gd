extends Node
signal score_updated(new_score:int)
var score:int:
	set(new_score):
		score = new_score
		score_updated.emit(score)
		
var total_score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
