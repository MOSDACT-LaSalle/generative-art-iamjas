// Definición de variables
float centerX, centerY; // Coordenadas del centro de la estrella
float innerRadius, outerRadius; // Radios interno y externo de la estrella
int points = 4; // Número de puntas de la estrella
int totalSteps = 100; // Número total de pasos para completar la animación
int currentStep = 0; // Paso actual de la animación
boolean reset = false; // Indicador para reiniciar la animación
color pastelGreenLight, pastelGreenDark; // Colores para las líneas y el fondo

void setup() {
  size(400, 400); // Tamaño de la ventana
  centerX = width / 2; // Coordenada X del centro de la ventana
  centerY = height / 2; // Coordenada Y del centro de la ventana
  initializeStar(); // Inicializar los radios de la estrella
  pastelGreenLight = color(144, 238, 144); // Color pastel verde claro
  pastelGreenDark = color(102, 205, 102); // Color pastel verde oscuro
  noFill(); // No rellenar las formas
}

void draw() {
  if (reset) {
    initializeStar(); // Reinicializa los radios de la estrella
    reset = false; // Resetea el indicador de reinicio
  }
  
  background(pastelGreenDark); // Establece el fondo verde pastel oscuro
  
  float progress = (currentStep % totalSteps) / (float)totalSteps; // Calcula el progreso de la animación
  
  stroke(pastelGreenLight); // Establece el color de las líneas a verde pastel claro
  
  // Dibujar la estrella con líneas desde el centro a los vértices
  for (int i = 0; i < points * 2; i++) {
    float angle1 = PI / points * i; // Ángulo del primer vértice
    float angle2 = PI / points * (i + 1); // Ángulo del siguiente vértice
    float radius1 = (i % 2 == 0) ? outerRadius : innerRadius; // Radio del primer vértice
    float radius2 = ((i + 1) % 2 == 0) ? outerRadius : innerRadius; // Radio del siguiente vértice
    
    float x1 = centerX + cos(angle1) * radius1 * progress; // Coordenada X del primer vértice
    float y1 = centerY + sin(angle1) * radius1 * progress; // Coordenada Y del primer vértice
    float x2 = centerX + cos(angle2) * radius2 * progress; // Coordenada X del siguiente vértice
    float y2 = centerY + sin(angle2) * radius2 * progress; // Coordenada Y del siguiente vértice
    
    line(centerX, centerY, x1, y1); // Línea del centro al primer vértice
    line(centerX, centerY, x2, y2); // Línea del centro al siguiente vértice
    line(x1, y1, x2, y2); // Línea externa de la estrella
    
    // Dibujar líneas internas para rellenar la estrella
    for (float j = 0; j <= 1; j += 0.05) { // Incrementar densidad de líneas
      float intermediateX1 = centerX + cos(angle1) * radius1 * j * progress; // Coordenada X intermedia
      float intermediateY1 = centerY + sin(angle1) * radius1 * j * progress; // Coordenada Y intermedia
      float intermediateX2 = centerX + cos(angle2) * radius2 * j * progress; // Coordenada X intermedia
      float intermediateY2 = centerY + sin(angle2) * radius2 * j * progress; // Coordenada Y intermedia
      line(intermediateX1, intermediateY1, intermediateX2, intermediateY2); // Línea interna
    }
  }
  
  currentStep++;
  if (currentStep > totalSteps) {
    currentStep = 0; // Resetea el contador de pasos para reiniciar la animación
    reset = true; // Establece el indicador de reinicio a true
  }
}

void initializeStar() {
  innerRadius = random(30, 60); // Radio interno aleatorio
  outerRadius = random(70, 120); // Radio externo aleatorio
  currentStep = 0; // Reinicia el paso actual
}
