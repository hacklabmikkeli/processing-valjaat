float metsa_kirkkaus = 0;
float meri_kirkkaus = 0;
float kaupunki_kirkkaus = 0;
float vuori_kirkkaus = 0;

float metsa_savy = 0;
float meri_savy = 0;
float kaupunki_savy = 0;
float vuori_savy = 0;

PImage metsa;
PImage meri;
PImage kaupunki;
PImage vuori;

void lataa_kuvat() {
  metsa = loadImage("metsa.jpg");
  meri = loadImage("meri.jpg");
  kaupunki = loadImage("kaupunki.jpg");
  vuori = loadImage("vuori.jpg");
}

void piirra_kollaasi() {
  if (!kuvakollaasi_paalla) {
    return;
  }
  
  metsa_kirkkaus = 0;
  meri_kirkkaus = 0;
  kaupunki_kirkkaus = 0;
  vuori_kirkkaus = 0;
  
  kollaasi_arvot();
  
  imageMode(CENTER);
  tint(color(metsa_savy, 100, 100), 255*(metsa_kirkkaus/100));
  image(metsa, width/2, height/2);
  tint(color(meri_savy, 100, 100), 127*(meri_kirkkaus/100));
  image(meri, width/2, height/2);
  tint(color(kaupunki_savy, 100, 100), 63*(kaupunki_kirkkaus/100));
  image(kaupunki, width/2, height/2);
  tint(color(vuori_savy, 100, 100), 31*(vuori_kirkkaus/100));
  image(vuori, width/2, height/2);
}