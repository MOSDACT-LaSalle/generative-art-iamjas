int numOfNautilus = 3;
int numOfSpirals = 190;
float[] angles;
float[] speeds;
PVector[] positions;
PVector[] velocities;
color[] colors;
color[] bgColors;
int bpm = 123; // Beats por minuto
int interval; // Intervalo en milisegundos entre cada cambio de fondo
int lastChangeTime; // Tiempo del último cambio de fondo
int bgColorIndex = 0; // Índice del color de fondo actual

void setup() {
  size(1000, 800);
  noFill();
  strokeWeight(1);
  
  // Calcular el intervalo de tiempo entre beats en milisegundos
  interval = int(60000 / bpm);
  lastChangeTime = millis(); // Registrar el tiempo inicial
  
  // Inicializar arrays
  angles = new float[numOfNautilus];
  speeds = new float[numOfNautilus];
  positions = new PVector[numOfNautilus];
  velocities = new PVector[numOfNautilus];
  
  // Definir los colores de los Nautilus (Negros)
  colors = new color[] {
    color(0), // Negro
    color(0),
    color(0),
    color(0)
  };
  
  // Definir los colores del fondo
  bgColors = new color[] {
    color(255, 0, 0, 100),   // Rojo brillante, transparente
    color(0, 255, 0, 100),   // Verde brillante, transparente
    color(0, 0, 255, 100),   // Azul brillante, transparente
    color(255, 255, 0, 100), // Amarillo brillante, transparente
    color(255, 0, 255, 100), // Magenta brillante, transparente
    color(0, 255, 255, 100)  // Cian brillante, transparente
  };
  
  // Configurar los Nautilus
  for (int i = 0; i < numOfNautilus; i++) {
    angles[i] = random(TWO_PI);
    speeds[i] = random(0.05, 0.02);
    positions[i] = new PVector(random(width), random(height));
    velocities[i] = new PVector(random(-5, 5), random(-5, 5));
  }
  
  // Usar el modo de color HSB para gestionar los colores
  colorMode(HSB, 360, 100, 100);
}

void draw() {
  // Comprobar si ha pasado suficiente tiempo para cambiar el fondo
  if (millis() - lastChangeTime >= interval) {
    bgColorIndex = (bgColorIndex + 1) % bgColors.length; // Cambiar al siguiente color en el arreglo
    lastChangeTime = millis(); // Actualizar el tiempo del último cambio
  }
  
  background(bgColors[bgColorIndex]); // Establecer el fondo con el color actual
  
  for (int i = 0; i < numOfNautilus; i++) {
    // Mover las posiciones agresivamente
    positions[i].add(velocities[i]);
    
    // Rebotar en los bordes
    if (positions[i].x < 0 || positions[i].x > width) {
      velocities[i].x *= -1;
    }
    if (positions[i].y < 0 || positions[i].y > height) {
      velocities[i].y *= -1;
    }
    
    pushMatrix();
    translate(positions[i].x, positions[i].y);
    drawNautilus(angles[i]);
    popMatrix();
    
    // Actualizar ángulo para la animación
    angles[i] += speeds[i];
  }
}

void drawNautilus(float angle) {
  float angleOffset = angle;
  
  for (int i = 0; i < numOfSpirals; i++) {
    float radius = i * 2;
    float x = radius * cos(angleOffset);
    float y = radius * sin(angleOffset);
    
    // Ondulaciones estilo Gaudí
    float waveX = sin(i * 0.15 + angle) * 20; // Incrementar las ondulaciones
    float waveY = cos(i * 0.15 + angle) * 20; // Incrementar las ondulaciones
    
    // Deformaciones asimétricas
    float gaudiDeformX = sin(i * 0.1 + angle) * 10 + cos(i * 0.05) * 15;
    float gaudiDeformY = cos(i * 0.1 + angle) * 10 + sin(i * 0.05) * 15;
    
    // Color negro para los Nautilus
    stroke(colors[i % colors.length]);
    
    // Dibujar las formas deformadas
    ellipse(x + waveX + gaudiDeformX, y + waveY + gaudiDeformY, radius * 1.5, radius * 1.5);
    
    angleOffset += 0.05;
  }
}
