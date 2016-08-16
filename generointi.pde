float x;
float y;
float r;
float kulma;

float kirkkaus;
float kyllaisyys;
float savy;

float[] rtaulu;
float[] kulmataulu;

void alusta_generointi() {
  rtaulu = new float[width * height];
  kulmataulu = new float[width * height];
  
  for (int j=0; j<height; j++) {
    for (int i=0; i<width; i++) {
      rtaulu[j * width + i] = sqrt(sq(i - width/2) + sq(j - height/2));
      kulmataulu[j * width + i] = degrees(atan2(j - height/2, i - width/2)) + 180;
    }
  }
}

void generoi_kuva() {
  if (!generointi_paalla) {
    background(0);
    return;
  }
  
  loadPixels();
  for (int j=0; j<height; j++) {
    for (int i=0; i<width; i++) {
      y = j;
      x = i;
      savy = 0;
      kirkkaus = 99;
      kyllaisyys = 99;
      
      r = rtaulu[j * width + i];
      kulma = kulmataulu[j * width + i];
      
      generointi_arvot();
      pixels[j * width + i] = color(
        mod(savy, 360),
        mod(kyllaisyys, 100),
        mod(kirkkaus, 100));
    }
  }   
  updatePixels();
}