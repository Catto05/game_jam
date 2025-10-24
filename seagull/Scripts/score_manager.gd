# ScoreManager.gd
extends Node

# Due segnali separati per la massima chiarezza
signal total_score_updated(new_total_score: int)
signal partial_score_updated(new_partial_score: int)

# --- PUNTEGGIO TOTALE (quello sicuro) ---
var total_score: int = 0:
	set(new_value):
		total_score = new_value
		total_score_updated.emit(total_score)

# --- PUNTEGGIO PARZIALE (quello a rischio) ---
var partial_score: int = 0:
	set(new_value):
		partial_score = new_value
		partial_score_updated.emit(partial_score)

# Questa funzione viene chiamata quando il gabbiano mangia un pesce
func add_partial_score(points: int):
	# Aggiunge i punti solo al punteggio parziale
	self.partial_score += points

# Questa funzione viene chiamata quando il gabbiano torna alla barca
func bank_partial_score():
	# Aggiunge il parziale al totale e poi azzera il parziale
	self.total_score += partial_score
	self.partial_score = 0

# (Opzionale) Funzione da chiamare se il giocatore muore,
# per fargli perdere il punteggio parziale accumulato
func reset_partial_score():
	self.partial_score = 0
