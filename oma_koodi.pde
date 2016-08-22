String mindwave_sarjaportti = "/dev/rfcomm0";
String fearcatcher_osoite = "http://127.0.0.1:3000/";
boolean generointi_paalla = true;
boolean kuvakollaasi_paalla = true;

float meditointi_seuranta;
float theta_seuranta;

void generointi_arvot() {
  kyllaisyys = 0;
  kirkkaus = random(100) * (pelko / 255.0);
}

void kollaasi_arvot() {
  vihaisuus = 85;
  meditointi = 100;
  theta = 60;
  pelko = 90;
  
  meditointi_seuranta += (meditointi - meditointi_seuranta) / 60;
  theta_seuranta += (theta - theta_seuranta) / 120;
  float varahtely = sin(aika) * 10;
  
  metsa_kirkkaus = meditointi_seuranta;
  metsa_savy = 90 + theta_seuranta/2;
  meri_kirkkaus = meditointi_seuranta;
  meri_savy = 190 + theta_seuranta/10 + varahtely;
  kaupunki_kirkkaus = 100 - meditointi_seuranta;
  kaupunki_savy = 315 - theta_seuranta/4 + varahtely;
  vuori_kirkkaus = 100 - meditointi_seuranta;
  vuori_savy = 30 - theta_seuranta/5;
  
  if (vihaisuus > 50) {
      metsa_savy -= (vihaisuus - 50) * 2.6;
      meri_savy += (vihaisuus - 50) * 3.5;
      kaupunki_savy += vihaisuus - 50;
      vuori_savy -= vihaisuus - 50;
  }
  
  if (pelko > 70) {
      metsa_kirkkaus /= max(1, 0.3*(pelko - 70));
      meri_kirkkaus /= max(1, 0.3*(pelko - 70));
      kaupunki_kirkkaus /= max(1, 0.3*(pelko - 70));
      vuori_kirkkaus /= max(1, 0.3*(pelko - 70));
  }
}