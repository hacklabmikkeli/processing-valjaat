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

  initMindWave();
  initFearCatcher();
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
  
  piirra();
  
  text("attention", 25, 30);
  rect(20, 30, attention, 10);
  text("meditation", 25, 60);
  rect(20, 60, meditation, 10);
  text("delta", 25, 90);
  rect(20, 90, delta, 10);
  text("theta", 25, 120);
  rect(20, 120, theta, 10);
  text("low alpha", 25, 150);
  rect(20, 150, lowAlpha, 10);
  text("high alpha", 25, 180);
  rect(20, 180, highAlpha, 10);
  text("low beta", 25, 210);
  rect(20, 210, lowBeta, 10);
  text("high beta", 25, 240);
  rect(20, 240, highBeta, 10); 
  text("low gamma", 25, 270);
  rect(20, 270, lowGamma, 10);
  text("high gamma", 25, 300);
  rect(20, 300, midGamma, 10);
  text("quality", 25, 330);
  rect(20, 330, 255 - quality, 10);
  text("anger", 25, 360);
  rect(20, 360, anger, 10);
  text("contempt", 25, 390);
  rect(20, 390, contempt, 10);
  text("fear", 25, 420);
  rect(20, 420, fear, 10);
  text("happiness", 25, 450);
  rect(20, 450, happiness, 10);
  text("neutral", 25, 480);
  rect(20, 480, neutral, 10);
  text("sadness", 25, 510);
  rect(20, 510, sadness, 10);
  text("surprise", 25, 540);
  rect(20, 540, surprise, 10);
  text("disgust", 25, 570);
  rect(20, 570, disgust, 10);
}
