import processing.serial.*;

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

Serial port;

class DataFields {
  int attention;
  int meditation;
  int delta;
  int theta;
  int lowAlpha;
  int highAlpha;
  int lowBeta;
  int highBeta;
  int lowGamma;
  int midGamma;
  int quality;
}

volatile int attention;
volatile int meditation;
volatile int delta;
volatile int theta;
volatile int lowAlpha;
volatile int highAlpha;
volatile int lowBeta;
volatile int highBeta;
volatile int lowGamma;
volatile int midGamma;
volatile int quality;

DataFields backupDataFields = new DataFields();

int payloadLength;
int payloadChecksum;
int i;

void saveData() {
  backupDataFields.attention = attention;
  backupDataFields.meditation = meditation;
  backupDataFields.delta = delta;
  backupDataFields.theta = theta;
  backupDataFields.lowAlpha = lowAlpha;
  backupDataFields.highAlpha = highAlpha;
  backupDataFields.lowBeta = lowBeta;
  backupDataFields.highBeta = highBeta;
  backupDataFields.lowGamma = lowGamma;
  backupDataFields.midGamma = midGamma;
  backupDataFields.quality = quality;
}

void restoreData() {
  attention = backupDataFields.attention;
  meditation = backupDataFields.meditation;
  delta = backupDataFields.delta;
  theta = backupDataFields.theta;
  lowAlpha = backupDataFields.lowAlpha;
  highAlpha = backupDataFields.highAlpha;
  lowBeta = backupDataFields.lowBeta;
  highBeta = backupDataFields.highBeta;
  lowGamma = backupDataFields.lowGamma;
  midGamma = backupDataFields.midGamma;
  quality = backupDataFields.quality;
}

int readByte2() {
  while (port.available() == 0) { /* wait */ }
  return port.read();
}

int readByte() {
  while (port.available() == 0) { /* wait */ }
  int data = port.read();
  i++;
  payloadChecksum += data;
  return data;
}

int readThreeBytes() {
  int result = 0;
  result = readByte();
  readByte();
  readByte();
  return result;
}

void readWaves() {
  println("wave values changing");
  delta = (3*delta + readThreeBytes()) / 4;
  theta = (3*theta + readThreeBytes()) / 4;
  lowAlpha = (3*lowAlpha + readThreeBytes()) / 4;
  highAlpha = (3*highAlpha + readThreeBytes()) / 4;
  lowBeta = (3*lowBeta + readThreeBytes()) / 4;
  highBeta = (3*highBeta + readThreeBytes()) / 4;
  lowGamma = (3*lowGamma + readThreeBytes()) / 4;
  midGamma = (3*midGamma + readThreeBytes()) / 4;
}

void readSerial() {
  try {
    Thread.sleep(2);
  } catch (InterruptedException ex) {
  }
  
  saveData();
  
  int data;
  while ((data = readByte2()) != 0xAA) {
  }
  if ((data = readByte2()) != 0xAA) {
    return;
  }
  
  payloadLength = readByte2();
  if (payloadLength < 0 || payloadLength > 169) {
    return;
  }
  
  payloadChecksum = 0;
  i = 0;
  while (i < payloadLength) {
    data = readByte();
    
    switch (data) {
    case 0x02:
      quality = readByte();
      
      break;
    case 0x04:
      attention = readByte();
      println("attention changing");
      break;
    case 0x05:
      meditation = readByte();
      println("meditation changing");
      break;
    case 0x80:
      while (i < payloadLength) {
        readByte();
      }
      break;
    case 0x83:
      readWaves();
      break;
    default:
      break;
    }
  }
  
  if (quality > 50) {
    restoreData();
  }
  
  int checksumExpected = readByte2();
  payloadChecksum = 255 - (0xFF & payloadChecksum);
  if (payloadChecksum != checksumExpected) {
    println("CHECKSUM FAIL");
    println("Expected checksum: " + checksumExpected);
    println("Actual checksum: " + payloadChecksum);
    restoreData();
  }
}

void readSerialForever() {
  for (;;) {
    readSerial();
  }
}

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
  
  try {
    port = new Serial(this, "/dev/rfcomm2", 57600);
    thread("readSerialForever");
  } catch (Exception ex) {
    print("Serial port disabled: " + ex.getMessage());
  }

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
}
