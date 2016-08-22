import processing.serial.*;

Serial mindWavePort;

class DataFields {
  int huomio;
  int meditointi;
  int delta;
  int theta;
  int matalaAlfa;
  int korkeaAlfa;
  int matalaBeta;
  int korkeaBeta;
  int matalaGamma;
  int keskiGamma;
  int quality;
}

volatile int huomio;
volatile int meditointi;
volatile int delta;
volatile int theta;
volatile int matalaAlfa;
volatile int korkeaAlfa;
volatile int matalaBeta;
volatile int korkeaBeta;
volatile int matalaGamma;
volatile int keskiGamma;
volatile int quality;

DataFields backupDataFields = new DataFields();

int payloadLength;
int payloadChecksum;
int i;

void saveData() {
  backupDataFields.huomio = huomio;
  backupDataFields.meditointi = meditointi;
  backupDataFields.delta = delta;
  backupDataFields.theta = theta;
  backupDataFields.matalaAlfa = matalaAlfa;
  backupDataFields.korkeaAlfa = korkeaAlfa;
  backupDataFields.matalaBeta = matalaBeta;
  backupDataFields.korkeaBeta = korkeaBeta;
  backupDataFields.matalaGamma = matalaGamma;
  backupDataFields.keskiGamma = keskiGamma;
  backupDataFields.quality = quality;
}

void restoreData() {
  huomio = backupDataFields.huomio;
  meditointi = backupDataFields.meditointi;
  delta = backupDataFields.delta;
  theta = backupDataFields.theta;
  matalaAlfa = backupDataFields.matalaAlfa;
  korkeaAlfa = backupDataFields.korkeaAlfa;
  matalaBeta = backupDataFields.matalaBeta;
  korkeaBeta = backupDataFields.korkeaBeta;
  matalaGamma = backupDataFields.matalaGamma;
  keskiGamma = backupDataFields.keskiGamma;
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
  matalaAlfa = (3*matalaAlfa + readThreeBytes()) / 4;
  korkeaAlfa = (3*korkeaAlfa + readThreeBytes()) / 4;
  matalaBeta = (3*matalaBeta + readThreeBytes()) / 4;
  korkeaBeta = (3*korkeaBeta + readThreeBytes()) / 4;
  matalaGamma = (3*matalaGamma + readThreeBytes()) / 4;
  keskiGamma = (3*keskiGamma + readThreeBytes()) / 4;
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
      huomio = readByte();
      println("attention changing");
      break;
    case 0x05:
      meditointi = readByte();
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