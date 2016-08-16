String mindwave_sarjaportti = "/dev/rfcomm0";
String fearcatcher_osoite = "http://127.0.0.1:3000/";
boolean generointi_paalla = false;
boolean kuvakollaasi_paalla = true;

void generointi_arvot() {
}

void kollaasi_arvot() {
  metsa_kirkkaus = 50 + 50*sin(aika);
  metsa_savy = 110;
  meri_kirkkaus = 50 + 50*cos(aika);
  meri_savy = 225;
  kaupunki_kirkkaus = 50 - 50*sin(aika);
  kaupunki_savy = 315;
  vuori_kirkkaus = 50 - 50*cos(aika);
  vuori_savy = 30;
}