int totalSteps = 100; // Número total de pasos para completar la animación
float angle = 0; // Ángulo para el movimiento en espiral
float spiralRadius = 5; // Radio de la espiral
Polygon[] polygons; // Array de polígonos
int numPolygons = 10; // Número de polígonos

int bpm = 120; // Beats por minuto
int interval = 60000 / bpm; // Intervalo en milisegundos entre cada cambio de fondo
int lastColorChange = 0; // Último tiempo en que se cambió el color de fondo
color[] backgroundColors = {
  color(204, 255, 204), // Verde pastel
  color(255, 204, 204), // Rosa pastel
  color(204, 204, 255), // Azul pastel
  color(255, 255, 204), // Amarillo pastel
  color(204, 255, 255)  // Cian pastel
};
int currentBackgroundIndex = 0;

void setup() {
  size(800, 800, P3D); // Tamaño de la ventana con renderizado en 3D
  background(backgroundColors[currentBackgroundIndex]); // Fondo inicial
  frameRate(30); // Ajustar la velocidad de la animación
  polygons = new Polygon[numPolygons]; // Crear un array de polígonos
  
  // Inicializar todos los polígonos en el array
  for (int i = 0; i < numPolygons; i++) {
    polygons[i] = new Polygon();
  }
}

void draw() {
  // Verificar si ha pasado el tiempo suficiente para cambiar el color de fondo
  if (millis() - lastColorChange > interval) {
    currentBackgroundIndex = (currentBackgroundIndex + 1) % backgroundColors.length;
    background(backgroundColors[currentBackgroundIndex]);
    lastColorChange = millis(); // Actualizar el tiempo del último cambio de color
  }
  
  translate(width/2, height/2); // Mover el origen al centro de la pantalla

  // Actualizar y dibujar todos los polígonos
  for (int i = 0; i < numPolygons; i++) {
    float spiralX = cos(angle + i) * (spiralRadius + i * 10);
    float spiralY = sin(angle + i) * (spiralRadius + i * 10);
    polygons[i].updatePosition(spiralX, spiralY); // Actualizar la posición del polígono
    polygons[i].rotate(); // Rotar el polígono
    polygons[i].display(); // Dibujar el polígono
  }
  
  angle += 0.05; // Incremento del ángulo para el movimiento en espiral
  spiralRadius += 0.5; // Incremento del radio de la espiral
}

class Polygon {
  PVector[] vertices; // Coordenadas de los vértices de la forma
  color[] colors; // Array de colores para las formas
  color currentColor; // Color actual de la forma
  int numVertices; // Número de vértices de la forma poligonal
  float currentStep; // Paso actual de la animación
  PVector centerPosition; // Posición central de la forma
  
  Polygon() {
    colors = new color[] {
      color(227, 11, 92, 150),   // Rojo frambuesa
      color(135, 206, 250, 150), // Azul cielo
      color(144, 238, 144, 150), // Verde pastel
      color(255, 255, 153, 150), // Amarillo pastel
      color(255, 179, 71, 150)   // Naranja pastel
    };
    currentStep = totalSteps; // Inicializar el paso actual de la animación
    centerPosition = new PVector(0, 0, 0); // Posición inicial en el centro
    initializeVertices(); // Inicializar los vértices
    selectColor(); // Seleccionar un color para la forma
  }

  void initializeVertices() {
    numVertices = int(random(5, 10)); // Número aleatorio de vértices entre 5 y 9
    vertices = new PVector[numVertices];
    for (int i = 0; i < numVertices; i++) {
      float angle = random(TWO_PI); // Ángulo aleatorio para cada vértice
      float radius = random(50, 150); // Radio aleatorio para irregularidad
      float x = cos(angle) * radius;
      float y = sin(angle) * radius;
      float z = random(-50, 50); // Profundidad aleatoria para efecto 3D
      vertices[i] = new PVector(x, y, z);
    }
  }

  void selectColor() {
    currentColor = colors[int(random(colors.length))];
  }

  void updatePosition(float x, float y) {
    centerPosition.x = x;
    centerPosition.y = y;
  }

  void rotate() {
    rotateY(map(currentStep, 0, totalSteps, 0, TWO_PI)); // Rotación en Y
    rotateX(map(currentStep, 0, totalSteps, 0, TWO_PI)); // Rotación en X
    rotateZ(map(currentStep, 0, totalSteps, 0, TWO_PI)); // Rotación en Z
  }

  void display() {
    stroke(255); // Borde de color blanco
    strokeWeight(2); // Grosor del borde
    fill(currentColor); // Rellenar la forma con el color actual

    beginShape();
    for (int i = 0; i < numVertices; i++) {
      PVector v1 = vertices[i];
      float scaleFactor = currentStep / totalSteps;
      float x1 = centerPosition.x + v1.x * scaleFactor;
      float y1 = centerPosition.y + v1.y * scaleFactor;
      float z1 = v1.z * scaleFactor;
      vertex(x1, y1, z1);
    }
    endShape(CLOSE);

    currentStep--;
    if (currentStep < 0) {
      currentStep = totalSteps; // Resetea el contador de pasos para reiniciar la animación
      initializeVertices(); // Reinicializa la forma con nuevas características
      selectColor(); // Seleccionar un nuevo color
    }
  }
}
