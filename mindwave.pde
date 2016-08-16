import processing.serial.*;

Serial mindWavePort;

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
  while (mindWavePort.available() == 0) { /* wait */ }
  return mindWavePort.read();
}

int readByte() {
  while (mindWavePort.available() == 0) { /* wait */ }
  int data = mindWavePort.read();
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

void initMindWave() {
  try {
    mindWavePort = new Serial(this, mindwave_sarjaportti, 57600);
    thread("readSerialForever");
  } catch (Exception ex) {
    print("MindWave disabled: " + ex.getMessage());
  }
}