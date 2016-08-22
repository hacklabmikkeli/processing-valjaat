float aika;
float hiirix;
float hiiriy;

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
  
  alusta_generointi();
  lataa_kuvat();
  initMindWave();
  initFearCatcher();
}

void draw() {
  aika = millis() / 1000.0;
  hiirix = mouseX;
  hiiriy = mouseY;
  
  generoi_kuva();
  piirra_kollaasi();
  
  text("huomio", 25, 30);
  rect(20, 30, huomio, 10);
  text("meditointi", 25, 60);
  rect(20, 60, meditointi, 10);
  text("delta", 25, 90);
  rect(20, 90, delta, 10);
  text("theta", 25, 120);
  rect(20, 120, theta, 10);
  text("matala alfa", 25, 150);
  rect(20, 150, matalaAlfa, 10);
  text("korkea alfa", 25, 180);
  rect(20, 180, korkeaAlfa, 10);
  text("matala beta", 25, 210);
  rect(20, 210, matalaBeta, 10);
  text("korkea beta", 25, 240);
  rect(20, 240, korkeaBeta, 10); 
  text("matala gamma", 25, 270);
  rect(20, 270, matalaGamma, 10);
  text("keskigamma", 25, 300);
  rect(20, 300, keskiGamma, 10);
  text("quality", 25, 330);
  rect(20, 330, 255 - quality, 10);
  text("vihaisuus", 25, 360);
  rect(20, 360, vihaisuus, 10);
  text("halveksunta", 25, 390);
  rect(20, 390, halveksunta, 10);
  text("pelko", 25, 420);
  rect(20, 420, pelko, 10);
  text("onni", 25, 450);
  rect(20, 450, onni, 10);
  text("neutraali", 25, 480);
  rect(20, 480, neutraali, 10);
  text("surullisuus", 25, 510);
  rect(20, 510, surullisuus, 10);
  text("yllattyneisyys", 25, 540);
  rect(20, 540, yllattyneisyys, 10);
  text("kuvotus", 25, 570);
  rect(20, 570, kuvotus, 10);
}