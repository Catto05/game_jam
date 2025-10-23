extends Node
signal score_updated(new_score:int)
var total_score:int:
	set(new_score):
		total_score = new_score
		score_updated.emit(total_score)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
