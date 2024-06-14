#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"
#include <Adafruit_NeoPixel.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <WebServer.h>

const int ledCount = 12;
const int ledPin = 16;
const int vibrationPin = 17;

Adafruit_NeoPixel strip = Adafruit_NeoPixel(ledCount, ledPin, NEO_GRB + NEO_KHZ800);

#define SERVICE_UUID "6e400001-b5a3-f393-e0a9-e50e24dcca9e"
#define SSID_CHAR_UUID "6e400002-b5a3-f393-e0a9-e50e24dcca9e"
#define PASSWORD_CHAR_UUID "6e400003-b5a3-f393-e0a9-e50e24dcca9e"
#define USER_CHAR_UUID "6e400004-b5a3-f393-e0a9-e50e24dcca9e"
#define DEVICE_CHAR_UUID "6e400005-b5a3-f393-e0a9-e50e24dcca9e"

const char* api_key = "AIzaSyA20ym16w61KuSxf2j_i4c7figf6FbcnPo"; 
const char* db_url = "https://finalworkemolink-468ad-default-rtdb.europe-west1.firebasedatabase.app";

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

WebServer server(80);

bool signupOK = false;
unsigned long sendDataPrevMillis = 0;
bool firstRead = true;
char ssid[32] = {0};
char password[32] = {0};
char userId[64] = {0};
char deviceId[64] = {0};
bool newCredentialsReceived = false;
unsigned long colorChangeTime = 0; // Track the time of the last color change
bool colorsChanged = false; // Track if the colors have been changed
String previousColors[12]; // Store previous colors
String vibratorPattern;

void connectToWiFi() {
  Serial.println("Connecting to WiFi...");
  
  // Disconnect from any previous WiFi connections
  WiFi.disconnect();
  delay(100);

  WiFi.begin(ssid, password);

  int retries = 0;
  while (WiFi.status() != WL_CONNECTED && retries < 40) { // Increased retries
    delay(500);
    Serial.print(".");
    retries++;
  }
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\nConnected to WiFi");
    Serial.print("IP Address: ");
    Serial.println(WiFi.localIP());

    config.api_key = api_key;
    config.database_url = db_url;

    if (Firebase.signUp(&config, &auth, "", "")) {
      Serial.println("Sign-up successful");
      signupOK = true;
    } else {
      Serial.print("Sign-up error: ");
      Serial.println(config.signer.signupError.message.c_str());
    }

    config.token_status_callback = tokenStatusCallback;
    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);

    fetchVibratorPattern();
  } else {
    Serial.println("\nFailed to connect to WiFi");
    Serial.print("SSID: ");
    Serial.println(ssid);
    Serial.print("Password: ");
    Serial.println(password);
  }
}

void fetchVibratorPattern() {
  String userVibratorPath = String("/users/") + userId + "/vibrator";
  if (Firebase.RTDB.getString(&fbdo, userVibratorPath.c_str())) {
    String vibratorName = fbdo.stringData();
    String vibratorPatternPath = String("/vibrators/") + vibratorName + "/pattern";
    if (Firebase.RTDB.getString(&fbdo, vibratorPatternPath.c_str())) {
      vibratorPattern = fbdo.stringData();
      Serial.print("Vibrator pattern: ");
      Serial.println(vibratorPattern);
    } else {
      Serial.print("Error fetching vibrator pattern: ");
      Serial.println(fbdo.errorReason());
    }
  } else {
    Serial.print("Error fetching vibrator name: ");
    Serial.println(fbdo.errorReason());
  }
}

void handleRoot() {
  String response = "ESP32 Serial Monitor\n";
  response += "User ID: " + String(userId) + "\n";
  response += "Device ID: " + String(deviceId) + "\n";
  response += "Vibrator Pattern: " + vibratorPattern + "\n";
  response += "Previous Colors: ";
  for (int i = 0; i < 12; i++) {
    response += previousColors[i] + " ";
  }
  response += "\n";
  server.send(200, "text/plain", response);
}

class WiFiCredentialCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue().c_str();
    Serial.print("Characteristic UUID: ");
    Serial.println(pCharacteristic->getUUID().toString().c_str());
    Serial.print("Value: ");
    Serial.println(value);
    
    if (pCharacteristic->getUUID().toString() == SSID_CHAR_UUID) {
      strncpy(ssid, value.c_str(), sizeof(ssid) - 1);
      ssid[sizeof(ssid) - 1] = '\0'; // Ensure null-termination
      Serial.print("SSID: ");
      Serial.println(ssid);
    } else if (pCharacteristic->getUUID().toString() == PASSWORD_CHAR_UUID) {
      strncpy(password, value.c_str(), sizeof(password) - 1);
      password[sizeof(password) - 1] = '\0'; // Ensure null-termination
      Serial.print("Password: ");
      Serial.println(password);
    } else if (pCharacteristic->getUUID().toString() == USER_CHAR_UUID) {
      strncpy(userId, value.c_str(), sizeof(userId) - 1);
      userId[sizeof(userId) - 1] = '\0'; // Ensure null-termination
      Serial.print("User ID: ");
      Serial.println(userId);
    } else if (pCharacteristic->getUUID().toString() == DEVICE_CHAR_UUID) {
      strncpy(deviceId, value.c_str(), sizeof(deviceId) - 1);
      deviceId[sizeof(deviceId) - 1] = '\0'; // Ensure null-termination
      Serial.print("Device ID: ");
      Serial.println(deviceId);
    }
    newCredentialsReceived = true;
  }
};

void setup() {
  Serial.begin(115200);

  BLEDevice::init("Emolink2");
  BLEServer *pServer = BLEDevice::createServer();
  BLEService *pService = pServer->createService(SERVICE_UUID);

  BLECharacteristic *ssidChar = pService->createCharacteristic(
    SSID_CHAR_UUID,
    BLECharacteristic::PROPERTY_WRITE
  );

  BLECharacteristic *passwordChar = pService->createCharacteristic(
    PASSWORD_CHAR_UUID,
    BLECharacteristic::PROPERTY_WRITE
  );

  BLECharacteristic *userChar = pService->createCharacteristic(
    USER_CHAR_UUID,
    BLECharacteristic::PROPERTY_WRITE
  );

  BLECharacteristic *deviceChar = pService->createCharacteristic(
    DEVICE_CHAR_UUID,
    BLECharacteristic::PROPERTY_WRITE
  );

  ssidChar->setCallbacks(new WiFiCredentialCallbacks());
  passwordChar->setCallbacks(new WiFiCredentialCallbacks());
  userChar->setCallbacks(new WiFiCredentialCallbacks());
  deviceChar->setCallbacks(new WiFiCredentialCallbacks());

  pService->start();
  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->start();

  strip.begin();
  strip.show();

  pinMode(vibrationPin, OUTPUT);
  digitalWrite(vibrationPin, LOW);
}

void resetLEDs() {
  for (int i = 0; i < ledCount; i++) {
    strip.setPixelColor(i, 0); // Turn off all LEDs
  }
  strip.show();
}

void loop() {
  server.handleClient();  // Handle incoming client requests

  if (newCredentialsReceived) {
    connectToWiFi();
    newCredentialsReceived = false;
  }

  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 2000 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();

    // Adjust the path to the correct location in your database
    String path = String("/users/") + userId + "/devices/" + deviceId + "/colors";
    if (Firebase.RTDB.getArray(&fbdo, path.c_str())) {
      if (fbdo.dataType() == "array") {
        FirebaseJsonArray colorsArray = fbdo.jsonArray();
        FirebaseJsonData colorData;
        Serial.println("Colors read from Firebase:");

        int numColors = colorsArray.size();
        int ledsPerColor = ledCount / numColors;
        bool colorChanged = false;

        for (int i = 0; i < numColors; i++) {
          colorsArray.get(colorData, i);
          if (colorData.type == "string") {
            String colorHexString = colorData.stringValue;

            // Check if the color has changed
            if (previousColors[i] != colorHexString) {
              previousColors[i] = colorHexString;
              colorChanged = true;
              colorsChanged = true; // Mark that colors have been changed
            }

            uint32_t colorValue = (uint32_t)strtol(colorHexString.c_str(), NULL, 16);
            int red = (colorValue >> 16) & 0xFF;
            int green = (colorValue >> 8) & 0xFF;
            int blue = (colorValue & 0xFF);

            Serial.print("Color ");
            Serial.print(i);
            Serial.print(": ");
            Serial.println(colorHexString);

            for (int j = 0; j < ledsPerColor; j++) {
              int ledIndex = i * ledsPerColor + j;
              if (ledIndex < ledCount) {
                strip.setPixelColor(ledIndex, strip.Color(red, green, blue));
              }
            }
          }
        }
        strip.show();

        if (colorChanged && !firstRead) {
          triggerVibration(vibratorPattern);
          colorChangeTime = millis(); // Record the time of the color change
        }

        firstRead = false;
      }
    } else {
      Serial.print("Error reading colors from Firebase: ");
      Serial.println(fbdo.errorReason());
    }
  }

  // Check if 3 seconds have passed since the last color change
  if (colorsChanged && millis() - colorChangeTime >= 3000) {
    resetLEDs(); // Reset LEDs after 3 seconds
    colorsChanged = false; // Reset the flag
  }
}

void triggerVibration(String pattern) {
  // Split the pattern string by commas
  int durations[10];
  int index = 0;
  char* token = strtok((char*)pattern.c_str(), ",");
  while (token != NULL) {
    durations[index++] = atoi(token);
    token = strtok(NULL, ",");
  }

  for (int i = 0; i < index; i++) {
    digitalWrite(vibrationPin, HIGH);
    delay(durations[i]);
    digitalWrite(vibrationPin, LOW);

    // Add a small delay between cycles if not the last duration
    if (i < index - 1) {
      delay(durations[++i]);
    }
  }
}
