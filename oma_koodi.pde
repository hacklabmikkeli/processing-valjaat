String mindwave_sarjaportti = "/dev/rfcomm0";
String fearcatcher_osoite = "http://127.0.0.1:3000/";

void arvot() {
  kirkkaus = 99 * sin(0.01*r + aika) * sin(0.01*kulma);
  savy = 360 * cos(0.003*r*(highAlpha/20)) + kulma + lowBeta * 30 + highBeta * 15;
  kyllaisyys = lowAlpha * 30;
}

void piirra() {
}