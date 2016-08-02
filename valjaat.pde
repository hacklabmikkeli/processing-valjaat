float x;
float y;
float r;
float kulma;
float aika;
float hiirix;
float hiiriy;

float kirkkaus;
float kyllaisyys;
float savy;

float[] rtaulu;
float[] kulmataulu;

int mod(int v, int d) {
  if (v < 0) {
    return d - ((-v) % d);
  } else {
    return v % d;
  }
}

int mod(float v, int d) {
  return mod((int)v, d);
}

int viimeiset(float n, float arvo) {
  return mod(arvo, (int)pow(10, n));
}

void setup() {
  size(800, 600, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  
  rtaulu = new float[width * height];
  kulmataulu = new float[width * height];
  
  for (int j=0; j<height; j++) {
    for (int i=0; i<width; i++) {
      rtaulu[j * width + i] = sqrt(sq(i - width/2) + sq(j - height/2));
      kulmataulu[j * width + i] = degrees(atan2(j - height/2, i - width/2)) + 180;
    }
  }
}

void draw() {
  loadPixels();
  aika = millis() / 1000.0;
  hiirix = mouseX;
  hiiriy = mouseY;
  
  for (int j=0; j<height; j++) {
    for (int i=0; i<width; i++) {
      y = j;
      x = i;
      savy = 0;
      kirkkaus = 99;
      kyllaisyys = 99;
      
      r = rtaulu[j * width + i];
      kulma = kulmataulu[j * width + i];
      
      arvot();
      pixels[j * width + i] = color(
        mod(savy, 360),
        mod(kyllaisyys, 100),
        mod(kirkkaus, 100));
    }
  }   
  updatePixels();
}