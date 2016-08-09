void arvot() {
  kirkkaus = 99 * sin(0.01*r + aika) * sin(0.01*kulma);
  savy = 360 * cos(0.003*r*(highAlpha/20)) + kulma + lowBeta * 30 + highBeta * 15;
  kyllaisyys = lowAlpha * 30;
}

void piirra() {
}