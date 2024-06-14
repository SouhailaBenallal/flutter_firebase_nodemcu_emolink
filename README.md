# flutter_firebase_nodemcu

**Version:** 1.0.0+1

## Table of Contents
1. [Project Overview](#project-overview)
2. [Setup and Installation](#setup-and-installation)
3. [Usage](#usage)
4. [Project Structure](#project-structure)
5. [Code Explanation](#code-explanation)
6. [Dependencies](#dependencies)
7. [Contributing](#contributing)
8. [License](#license)

---

## Project Overview

**EmoLink** is a prototype application designed to enhance emotional communication at a distance. By using a combination of Flutter for mobile app development, Firebase for backend services, and an ESP32 microcontroller for controlling LED and vibration feedback, EmoLink allows users to send color-coded messages to their associates. Each color represents a different emotion or message, providing a unique and personal way to stay connected.

---

## Setup and Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/SouhailaBenallal/flutter_firebase_nodemcu_emolink
   cd flutter_firebase_nodemcu

2. **Flutter Setup**

Ensure you have Flutter installed. Follow the official Flutter installation guide if needed.
Install Flutter dependencies:
  ```bash
  Flutter pub get


3. **Firebase Setupp**

Follow the official Firebase setup guide to add Firebase to your Flutter project.
Replace the google-services.json (for Android) and GoogleService-Info.plist (for iOS) in the respective directories with your Firebase configuration files.
ESP32 Setup

Ensure you have the Arduino IDE installed.
Install the required libraries via the Library Manager:
WiFi
Firebase ESP Client
Adafruit NeoPixel
BLEDevice
WebServer
Upload the provided ESP32.ino code to your ESP32 device.