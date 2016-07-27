float x;
float y;
float r;
float kulma;
float aika;

float kirkkaus;
float kyllaisyys;
float savy;

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
  size(640, 480);
  colorMode(HSB, 360, 100, 100, 100);
}

void draw() {
  loadPixels();
  for (int j=0; j<height; j++) {
    for (int i=0; i<width; i++) {
      y = j;
      x = i;
      aika = millis() / 1000.0;
      savy = 0;
      kirkkaus = 99;
      kyllaisyys = 99;
      r = sqrt(sq(x - width/2) + sq(y - height/2));
      kulma = degrees(atan2(y - height/2, x - width/2)) + 180;
      arvot();
      pixels[j * width + i] = color(
        mod(savy, 360),
        mod(kyllaisyys, 100),
        mod(kirkkaus, 100));
    }
  }   
  updatePixels();
}