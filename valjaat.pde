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

int readByte() {
  int data = port.read();
  i++;
  payloadChecksum += data;
  return data;
}

int readThreeBytes() {
  int result = 0;
  result += readByte();
  result <<= 8;
  result += readByte();
  result <<= 8;
  result += readByte();
  return result;
}

void readWaves() {
  delta = readThreeBytes() / 70000;
  theta = readThreeBytes() / 70000;
  lowAlpha = readThreeBytes() / 70000;
  highAlpha = readThreeBytes() / 70000;
  lowBeta = readThreeBytes() / 70000;
  highBeta = readThreeBytes() / 70000;
  lowGamma = readThreeBytes() / 70000;
  midGamma = readThreeBytes() / 70000;
}

void readSerial() {
  saveData();
  
  int data;
  while ((data = port.read()) != 0xAA) {
  }
  if ((data = port.read()) != 0xAA) {
    return;
  }
  
  payloadLength = port.read();
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
      break;
    case 0x05:
      meditation = readByte();
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
  
  int checksumExpected = port.read();
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
    port = new Serial(this, "/dev/rfcomm0", 57600);
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
}