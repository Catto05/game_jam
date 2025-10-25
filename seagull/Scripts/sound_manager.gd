# SoundManager.gd
extends Node
@onready var music_player: AudioStreamPlayer2D = $music_player

# Dizionario per precaricare i suoni e accedervi con un nome semplice
var sfx_library = {
	"oxygen_empty": preload("res://Assets/Sounds/ossigeno_in_esaurimento.wav"),
	"oxygen_full": preload("res://Assets/Sounds/ossigeno_ripristinato.mp3"),
	"jump_in": preload("res://Assets/Sounds/salto_in_acqua.wav"),
	"jump_out": preload("res://Assets/Sounds/salto_fuori_acqua.wav"),
	"eat": preload("res://Assets/Sounds/splash-small-rock-thrown-in-water-mechanical-wave-13-00-01.mp3")
}

# Funzione per riprodurre un effetto sonoro
func play_sfx(sound_name: String):
	if not sfx_library.has(sound_name):
		print("ERRORE: Suono non trovato: ", sound_name)
		return

	# 1. Crea un nuovo lettore audio dal nulla.
	var player = AudioStreamPlayer.new()
	
	# 2. Aggiungilo come figlio del SoundManager, altrimenti non può funzionare.
	add_child(player)
	
	# 3. Assegnagli il suono da riprodurre dalla nostra libreria.
	player.stream = sfx_library[sound_name]
	player.volume_db = 5
	# 4. Fallo partire.
	player.play()
	
	# 5. FONDAMENTALE: Collegati al suo segnale "finished".
	# Quando il suono finisce, il player si distruggerà da solo.
	# Questo previene l'accumulo di migliaia di nodi inutili.
	player.finished.connect(player.queue_free)

# Funzione per riprodurre la musica
func play_music(music_path: String):
	var music_stream = load(music_path)
	music_player.stream = music_stream
	music_player.volume_db = 18
	music_player.max_distance = 20000
	music_player.play()

# Funzione per fermare la musica
func stop_music():
	music_player.stop()
