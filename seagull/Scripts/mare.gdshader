// Specifica che questo è uno shader 2D per un CanvasItem
shader_type canvas_item;

// Le "uniform" sono variabili che puoi modificare dall'editor di Godot!
uniform vec4 water_color : source_color = vec4(0.1, 0.3, 0.8, 1.0); // Colore base dell'acqua
uniform float wave_speed = 0.5; // Velocità delle onde
uniform float wave_frequency = 10.0; // Quanto "fitte" sono le onde
uniform float wave_amplitude = 0.02; // Altezza delle onde

// La funzione fragment() viene eseguita per ogni singolo pixel del ColorRect
void fragment() {
    // UV è la coordinata del pixel (da 0 a 1)
    // Creiamo due onde che si muovono in direzioni diverse per un effetto più naturale
    float wave1 = sin(UV.x * wave_frequency + TIME * wave_speed) * wave_amplitude;
    float wave2 = cos(UV.y * wave_frequency * 0.5 + TIME * wave_speed * 0.7) * wave_amplitude;
    
    // Sommiamo le onde per creare un disturbo sulla coordinata Y
    float total_wave = wave1 + wave2;

    // Applichiamo il disturbo al colore finale
    // Aggiungiamo il valore dell'onda a tutti i canali (R, G, B) del colore
    vec3 final_color = water_color.rgb + total_wave;
    
    // COLOR è il colore finale che il pixel avrà sullo schermo
    COLOR = vec4(final_color, water_color.a);
}