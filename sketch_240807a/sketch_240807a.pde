int totalSteps = 700; // Número total de pasos para completar la animación
float angle = 0; // Ángulo para el movimiento en espiral
Polygon[] polygons; // Array de polígonos
int numPolygons = 10; // Número de polígonos


color backgroundColor = color(30, 30, 60); // Color de fondo oscuro que encaja con los colores de las formas

void setup() {
  size(800, 800, P3D); // Tamaño de la ventana con renderizado en 3D
  background(backgroundColor); // Fondo oscuro inicial
  frameRate(100); // Ajustar la velocidad de la animación
  polygons = new Polygon[numPolygons]; // Crear un array de polígonos
  
  // Inicializar todos los polígonos en el array
  for (int i = 0; i < numPolygons; i++) {
    polygons[i] = new Polygon();
  }
}

void draw() {
  // No repintamos el fondo para dejar un rastro

  // Configurar luces manualmente
  ambientLight(50, 50, 50); // Luz ambiental tenue
  directionalLight(255, 255, 255, -1, 0, 1); // Luz direccional brillante desde la izquierda

  translate(width/2, height/2); // Mover el origen al centro de la pantalla

  // Actualizar y dibujar todos los polígonos
  for (int i = 0; i < numPolygons; i++) {
    polygons[i].updatePosition(); // Actualizar la posición del polígono basado en movimiento aleatorio
    polygons[i].rotate(); // Rotar el polígono
    polygons[i].display(); // Dibujar el polígono
  }
  
  angle += 0.05; // Incremento del ángulo para el movimiento en espiral
}

class Polygon {
  PVector[] vertices; // Coordenadas de los vértices de la forma
  color[] colors; // Array de colores para las formas
  color currentColor; // Color actual de la forma
  int numVertices; // Número de vértices de la forma poligonal
  float currentStep; // Paso actual de la animación
  PVector centerPosition; // Posición central de la forma
  float scalar; // Escala del polígono
  float angleOffset; // Ángulo adicional para el movimiento
  
  Polygon() {
    colors = new color[] {
      color(255, 0, 0, 100),   // Rojo brillante, transparente
      color(0, 255, 0, 100),   // Verde brillante, transparente
      color(0, 0, 255, 100),   // Azul brillante, transparente
      color(255, 255, 0, 100), // Amarillo brillante, transparente
      color(255, 0, 255, 100), // Magenta brillante, transparente
      color(0, 255, 255, 100)  // Cian brillante, transparente
    };
    currentStep = totalSteps; // Inicializar el paso actual de la animación
    centerPosition = new PVector(0, 0, 0); // Posición inicial en el centro
    scalar = 220; // Inicializar la escala
    angleOffset = random(360); // Ángulo aleatorio para el movimiento
    initializeVertices(); // Inicializar los vértices
    selectColor(); // Seleccionar un color para la forma
  }

  void initializeVertices() {
    numVertices = int(random(3, 6)); // Número aleatorio de vértices entre 5 y 9
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

  void updatePosition() {
    // Movimiento aleatorio en la posición y escalado
    centerPosition.x += random(-1, 0);
    centerPosition.y += random(-2, 0);
    scalar += random(-2, 0);
    angleOffset += 1;
  }

  void rotate() {
    rotateY(map(currentStep, 0, totalSteps, 0, TWO_PI)); // Rotación en Y
    rotateX(map(currentStep, 0, totalSteps, 0, TWO_PI)); // Rotación en X
    rotateZ(map(currentStep, 0, totalSteps, 0, TWO_PI)); // Rotación en Z
  }

  void display() {
    specular(currentColor); // Especularidad basada en el color actual
    shininess(10); // Brillo para el efecto de vitral

    noStroke(); // Eliminar el borde

    fill(currentColor); // Rellenar la forma con el color actual

    beginShape();
    for (int i = 0; i < numVertices; i++) {
      PVector v1 = vertices[i];
      float scaleFactor = currentStep / totalSteps;
      float x1 = centerPosition.x + v1.x * scaleFactor * scalar / 220;
      float y1 = centerPosition.y + v1.y * scaleFactor * scalar / 220;
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
