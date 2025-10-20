extends RigidBody2D

# Regola questi valori dall'Inspector per cambiare il comportamento
@export var forza_galleggiamento: float = 250.0
@export var livello_acqua_y: float = 57 # La posizione Y della superficie dell'acqua

# Le proprietà di smorzamento (damping) simulano la resistenza dell'acqua
# Puoi anche impostarle direttamente nell'Inspector del RigidBody2D
@export var smorzamento_acqua: float = 1.0

func _integrate_forces(state):
	# Controlliamo se la barca si trova sotto la superficie dell'acqua
	if global_position.y > livello_acqua_y:
		# 1. Calcola la profondità di immersione
		# Più è profonda, maggiore sarà la forza
		var profondita_immersione = global_position.y - livello_acqua_y

		# 2. Calcola la forza di galleggiamento
		# È una forza verso l'alto (Vector2.UP) proporzionale alla profondità
		var spinta = Vector2.UP * profondita_immersione * forza_galleggiamento * state.get_step()

		# 3. Applica la forza al centro della barca
		state.apply_central_force(spinta)
		
		# 4. Applica lo smorzamento per simulare la resistenza dell'acqua
		# Questo frena la barca ed evita che oscilli all'infinito
		state.linear_velocity *= (1.0 - smorzamento_acqua * state.get_step())
		state.angular_velocity *= (1.0 - smorzamento_acqua * state.get_step())
