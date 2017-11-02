int cols, rows;
int scl = 1;
int w = 2500;
int h = 2000;
float noisescl = 0.005;
int altitude = 200;
float offset = 0;

// Hyper Params
int octaves = 3;
float lacunarity = 2;
float persistance = 0.6;

float[] freq = new float[octaves];
float[] amp = new float[octaves];
float[][] terrain;

void setup() {
  size(1200, 600, P3D);
  cols = w/scl;
  rows = h/scl;
  for (int i = 0; i < octaves; i++) {
    freq[i] = pow(lacunarity, i);
    amp[i] = pow(persistance, i);
  }
  terrain = new float[cols][rows];

  noStroke();

  generateTerrain();
  drawTerrain();
}

void mouseClicked() {
  offset+= 100;
  generateTerrain();
  drawTerrain();
}

void draw() {
}

void generateTerrain() {
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = generateVertex(x, y);
    }
  }
}

float generateVertex(int x, int y) {
  float result = 0f;
  
   float frequency = noisescl*freq[0];
   float amplitude = amp[0];
   float oct0 = easeAmplitude(noise(x*frequency, (y*frequency) + offset), amplitude);
   
   float detailLevel = 1 - (altitude - oct0)/altitude;
  
  result += oct0;
  
  for (int i = 1; i < octaves; i++) {
    frequency = noisescl*freq[i];
    amplitude = amp[i];
    result += map(noise(x*frequency, y*frequency), 0, 1, -altitude*amplitude*detailLevel, altitude*amplitude*detailLevel);
  }
  return result;
}

float easeAmplitude(float input, float amplitude) {
  return map(pow(input, 3), 0, 1, -15, altitude*amplitude);
}

void drawTerrain() {
  lights();
  background(173, 223, 255);
  translate(width/2, height/2);
  rotateX(PI/3);
  translate(-w/2, -h/2);

  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      selectColor(terrain[x][y]);
      vertex(x*scl, y*scl, max(0, terrain[x][y]));
      selectColor(terrain[x][y+1]);
      vertex(x*scl, (y+1)*scl, max(0, terrain[x][y+1]));
    }
    endShape();
  }
}

void selectColor(float alt) {
  if (alt <= -5) {
    fill(7, 43, 102); // Dark Water
  } else if (alt <= 0) {
    fill(43, 87, 150); // Water
  } else if (alt <= 3) {
    fill(247, 226, 143); // Sand
  } else if (alt <= 15) {
    fill(51, 158, 47); // Forest
  } else if (alt <= 100) {
    fill(52, 52, 52); //rock
  } else {
    fill(255, 255, 255);
  }
}