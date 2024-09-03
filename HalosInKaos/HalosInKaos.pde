/*---------------------------------

 Name: I AM JAS
 Date: Sept 2024
 Tittle:  Halos In Kaos
 Description:

HalosInKaos is a generative art project created using Processing. 
The project generates a series of dynamic polygonal shapes that rotate and pulsate 
around a constantly moving center. In turn, these polygons are surrounded by arcs 
(using code by artist Alba G. Corral) of various styles, which rotate and shift, 
creating a chaotic but harmonious visual effect.

 -----------------------------------*/

int totalSteps = 1000;
float angle = 0;
float spiralRadius = 5;
Polygon[] polygons;
int numPolygons = 13;

color backgroundColor = color(30, 30, 60); // Color de fondo oscuro que encaja con los colores de las formas

float pulseAmplitude = 0.1;
float pulseFrequency = 0.05;
float pulseOffset = 0;

final int ARC_COUNT = 150; // Número de arcos a dibujar
float[] arcPt; // Almacena parámetros de los arcos
int[] arcStyle; // Almacena estilos de los arcos

int regenerationInterval = 800; // Intervalo en milisegundos para regenerar la escena
int lastRegenerationTime = 0;

PVector originPoint; // Punto de origen para todas las formas

void setup() {
  size(900, 900, P3D);
  background(backgroundColor);
  frameRate(30);
  polygons = new Polygon[numPolygons];

  // Inicializar el punto de origen en el centro del canvas
  originPoint = new PVector(width / 2, height / 2);

  // Inicializar los polígonos
  for (int i = 0; i < numPolygons; i++) {
    polygons[i] = new Polygon(originPoint.x, originPoint.y);
  }

  // Inicializar arcos
  arcPt = new float[6 * ARC_COUNT];
  arcStyle = new int[2 * ARC_COUNT];

  int index = 0;
  for (int i = 0; i < ARC_COUNT; i++) {
    arcPt[index++] = random(TAU); // Ángulo de rotación en X
    arcPt[index++] = random(TAU); // Ángulo de rotación en Y
    arcPt[index++] = random(60, 80); // Radio del arco
    arcPt[index++] = int(random(2, 50) * 5); // Longitud del arco
    arcPt[index++] = random(4, 32); // Ancho del arco
    arcPt[index++] = radians(random(5, 30)) / 5; // Velocidad de rotación

    arcStyle[i*2+1] = floor(random(100)) % 3; // Estilo aleatorio del arco
  }
}

void draw() {
  // Verificar si ha pasado el intervalo de regeneración
  if (millis() - lastRegenerationTime > regenerationInterval) {
    background(backgroundColor);  // Borra el canvas
    lastRegenerationTime = millis();  // Actualizar el tiempo del último borrado

    // Cambiar el punto de origen a una nueva ubicación en el canvas
    originPoint = new PVector(random(width), random(height));

    // Actualizar todos los polígonos para que comiencen desde el nuevo punto de origen
    for (int i = 0; i < numPolygons; i++) {
      polygons[i].updateOrigin(originPoint.x, originPoint.y);
    }
  }

  // Configurar luces
  ambientLight(50, 50, 50);
  directionalLight(255, 255, 255, -1, 0, 1);

  translate(width / 2, height / 2);

  float pulseFactor = 1 + pulseAmplitude * sin(pulseOffset);
  pulseOffset += pulseFrequency;

  // Dibujar los polígonos
  for (int i = 0; i < numPolygons; i++) {
    polygons[i].rotate();
    polygons[i].display(pulseFactor);
  }
  
  angle += 0.05;
  spiralRadius += 0.5;
}

// Clase Polygon que representa los polígonos y sus comportamientos
class Polygon {
  PVector[] vertices; // Almacena los vértices del polígono
  color[] colors; // Colores posibles para el polígono
  color currentColor; // Color actual del polígono
  int numVertices; // Número de vértices del polígono
  float currentStep; // Paso actual de animación
  PVector centerPosition; // Centro del polígono

  Polygon(float x, float y) {
    colors = new color[] {
      color(255, 0, 0, 100),
      color(0, 255, 0, 100),
      color(0, 0, 255, 100),
      color(255, 255, 0, 100),
      color(255, 0, 255, 100),
      color(0, 255, 255, 100)
    };
    currentStep = totalSteps;
    centerPosition = new PVector(x, y, 0);
    initializeVertices();
    selectColor();
  }

  // Inicializar los vértices del polígono
  void initializeVertices() {
    numVertices = int(random(5, 10)); // Número de vértices entre 5 y 10
    vertices = new PVector[numVertices];
    for (int i = 0; i < numVertices; i++) {
      float angle = random(TWO_PI);
      float radius = random(50, 150);
      float x = cos(angle) * radius;
      float y = sin(angle) * radius;
      float z = random(-50, 50);
      vertices[i] = new PVector(x, y, z);
    }
  }

  // Seleccionar un color aleatorio para el polígono
  void selectColor() {
    currentColor = colors[int(random(colors.length))];
  }

  // Actualizar el punto de origen del polígono
  void updateOrigin(float x, float y) {
    centerPosition.x = x;
    centerPosition.y = y;
  }

  // Rotar el polígono
  void rotate() {
    rotateY(map(currentStep, 0, totalSteps, 0, TWO_PI));
    rotateX(map(currentStep, 0, totalSteps, 0, TWO_PI));
    rotateZ(map(currentStep, 0, totalSteps, 0, TWO_PI));
  }

  // Dibujar el polígono con efecto de pulso
  void display(float pulseFactor) {
    specular(currentColor);
    shininess(10);
    noStroke();
    fill(currentColor);

    float scaleFactor = currentStep / totalSteps * pulseFactor;

    beginShape();
    for (int i = 0; i < numVertices; i++) {
      PVector v1 = vertices[i];
      float x1 = centerPosition.x + v1.x * scaleFactor;
      float y1 = centerPosition.y + v1.y * scaleFactor;
      float z1 = v1.z * scaleFactor;
      vertex(x1, y1, z1);
    }
    endShape(CLOSE);

    // Dibuja arcos alrededor del polígono usando el color del polígono
    drawArcs(centerPosition.x, centerPosition.y, scaleFactor);

    currentStep--;
    if (currentStep < 0) {
      currentStep = totalSteps;
      initializeVertices();
      selectColor();
    }
  }

  // Función para dibujar arcos alrededor del polígono
  void drawArcs(float x, float y, float scaleFactor) {
    int index = 0;
    for (int i = 0; i < ARC_COUNT; i++) {
      pushMatrix();
      translate(x, y);
      rotateX(arcPt[index++]);
      rotateY(arcPt[index++]);

      stroke(currentColor); // Usar el color del polígono
      fill(currentColor);   // Usar el color del polígono

      if (arcStyle[i*2+1] == 0) {
        noFill();
        strokeWeight(1);
        arcLine(0, 0, arcPt[index++], arcPt[index++], arcPt[index++]);

      } else if (arcStyle[i*2+1] == 1) {
        noStroke();
        arcLineBars(0, 0, arcPt[index++], arcPt[index++], arcPt[index++]);

      } else {
        noStroke();
        arc(0, 0, arcPt[index++], arcPt[index++], arcPt[index++]);
      }

      // Incrementa la rotación
      arcPt[index-5] += arcPt[index] / 10;
      arcPt[index-4] += arcPt[index++] / 20;

      popMatrix();
    }
  }
}

// Funciones para dibujar los arcos
void arcLine(float x, float y, float degrees, float radius, float w) {
  int lineCount = floor(w / 2);
  for (int j = 0; j < lineCount; j++) {
    beginShape();
    for (int i = 0; i < degrees; i++) {
      float angle = radians(i);
      vertex(x + cos(angle) * radius, y + sin(angle) * radius);
    }
    endShape();
    radius += 2;
  }
}

void arcLineBars(float x, float y, float degrees, float radius, float w) {
  beginShape(QUADS);
  for (int i = 0; i < degrees / 4; i += 4) {
    float angle = radians(i);
    vertex(x + cos(angle) * radius, y + sin(angle) * radius);
    vertex(x + cos(angle) * (radius + w), y + sin(angle) * (radius + w));
    angle = radians(i + 2);
    vertex(x + cos(angle) * (radius + w), y + sin(angle) * (radius + w));
    vertex(x + cos(angle) * radius, y + sin(angle) * radius);
  }
  endShape();
}

void arc(float x, float y, float degrees, float radius, float w) {
  beginShape(QUAD_STRIP);
  for (int i = 0; i < degrees; i++) {
    float angle = radians(i);
    vertex(x + cos(angle) * radius, y + sin(angle) * radius);
    vertex(x + cos(angle) * (radius + w), y + sin(angle) * (radius + w));
  }
  endShape();
}
