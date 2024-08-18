import oscP5.*;
import netP5.*;

int totalSteps = 300;
float angle = 0;
float spiralRadius = 5;
Polygon[] polygons;
int numPolygons = 10;

color backgroundColor = color(70, 130, 180);

float pulseAmplitude = 0.1;
float pulseFrequency = 0.05;
float pulseOffset = 0;

OscP5 oscP5;
float filterValue = 0; // Este valor se actualizará con el OSC

void setup() {
  size(800, 800, P3D);
  background(backgroundColor);
  frameRate(30);
  polygons = new Polygon[numPolygons];
  
  // Inicializar los polígonos
  for (int i = 0; i < numPolygons; i++) {
    float randomX = random(-width/2, width/2);
    float randomY = random(-height/2, height/2);
    polygons[i] = new Polygon(randomX, randomY);
  }

  // Configurar el receptor OSC en el puerto 12000
  oscP5 = new OscP5(this, 2346);
}

void draw() {
  // Aplicar transparencia al fondo según el valor del filtro
  fill(backgroundColor, map(filterValue, 0, 1, 255, 0)); 
  rect(0, 0, width, height);

  // Configurar luces
  ambientLight(50, 50, 50);
  directionalLight(255, 255, 255, -1, 0, 1);

  translate(width/2, height/2);

  float pulseFactor = 1 + pulseAmplitude * sin(pulseOffset);
  pulseOffset += pulseFrequency;

  // Dibujar los polígonos
  for (int i = 0; i < numPolygons; i++) {
    float spiralX = cos(angle + i) * (spiralRadius + i * 10);
    float spiralY = sin(angle + i) * (spiralRadius + i * 10);
    polygons[i].updatePosition(spiralX, spiralY);
    polygons[i].rotate();
    polygons[i].display(pulseFactor);
  }
  
  angle += 0.05;
  spiralRadius += 0.5;
}

class Polygon {
  PVector[] vertices;
  color[] colors;
  color currentColor;
  int numVertices;
  float currentStep;
  PVector centerPosition;
  
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

  void initializeVertices() {
    numVertices = int(random(5, 10));
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

  void selectColor() {
    currentColor = colors[int(random(colors.length))];
  }

  void updatePosition(float x, float y) {
    centerPosition.x = x;
    centerPosition.y = y;
  }

  void rotate() {
    rotateY(map(currentStep, 0, totalSteps, 0, TWO_PI));
    rotateX(map(currentStep, 0, totalSteps, 0, TWO_PI));
    rotateZ(map(currentStep, 0, totalSteps, 0, TWO_PI));
  }

  void display(float pulseFactor) {
    specular(currentColor);
    shininess(10);
    noStroke();
    fill(currentColor);

    beginShape();
    for (int i = 0; i < numVertices; i++) {
      PVector v1 = vertices[i];
      float scaleFactor = currentStep / totalSteps * pulseFactor;
      float x1 = centerPosition.x + v1.x * scaleFactor;
      float y1 = centerPosition.y + v1.y * scaleFactor;
      float z1 = v1.z * scaleFactor;
      vertex(x1, y1, z1);
    }
    endShape(CLOSE);

    currentStep--;
    if (currentStep < 0) {
      currentStep = totalSteps;
      initializeVertices();
      selectColor();
    }
  }
}

// Método que se llama cuando se recibe un mensaje OSC
void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/Filtro")) { // Asegúrate de que este patrón coincida con el que envías desde Ableton
    filterValue = msg.get(0).floatValue(); // Recibe el valor y lo asigna a filterValue
  }
}
