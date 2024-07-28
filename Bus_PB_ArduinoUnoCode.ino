// include libraries
#include <Wire.h>

// Define Ultrasonic sensor pins
const int outsideTrigPin = 13;
const int outsideEchoPin = 12;
const int insideTrigPin = 5;
const int insideEchoPin = 4;

// Maximum distance for the sensors (in cm)
const int maxDistance = 80;
const int maxPeopleLimit = 5;

// Timeout duration (in milliseconds)
const int timeoutDuration = 2000;

// Count of people in the room
int peopleCount = 0;
float oxyData = 0;
int in = 0;
int out = 0;

// Variables to store time
unsigned long outsideTime = 0;
unsigned long insideTime = 0;

void setup() {
  
  Serial.begin(9600);

  // Initialize sensors
  pinMode(outsideTrigPin, OUTPUT);
  pinMode(outsideEchoPin, INPUT);
  pinMode(insideTrigPin, OUTPUT);
  pinMode(insideEchoPin, INPUT);

  // Begin Slave Wire
  Wire.begin(4); // Set slave address to 4
  Wire.onRequest(send_count); // Set up the function to handle requests

}

void loop() {
  
  // Check if the room is full
  if (peopleCount >= maxPeopleLimit) {
    Serial.print("Room is Full!");
    Serial.print("Please wait.");
  }

  // First Scenario: Outside sensor detects someone
  if (detectMotion(outsideTrigPin, outsideEchoPin)) {
    outsideTime = millis(); // Record time
    delay(100);

    // Wait for inside sensor to be crossed or timeout
    while (!detectMotion(insideTrigPin, insideEchoPin) && (millis() - outsideTime < timeoutDuration)) {
    }
    // Inside sensor is crossed
    if (detectMotion(insideTrigPin, insideEchoPin)) {
      insideTime = millis(); // Record time
      delay(100);
      if (outsideTime < insideTime) {

        // Someone entered the room
        peopleCount++;
        in++;
      }
    }
    // Reset the timeout
    outsideTime = 0;
    insideTime = 0;
  }

  // Second Scenario: Inside sensor detects someone
  if (detectMotion(insideTrigPin, insideEchoPin)) {
    insideTime = millis(); // Record time
    delay(100);

    // Wait for outside sensor to be crossed or timeout
    while (!detectMotion(outsideTrigPin, outsideEchoPin) && (millis() - insideTime < timeoutDuration)) {
    }

    // Outside sensor is crossed
    if (detectMotion(outsideTrigPin, outsideEchoPin)) {
      outsideTime = millis(); // Record time
      delay(100);
      if (insideTime < outsideTime) {
        // Someone exited the room
        if (peopleCount > 0) {
          peopleCount--;
          out++;          
        }
      }
    }
    Serial.println("Out: ");
    Serial.println(peopleCount);  
    Serial.print("In: ");
    Serial.println(peopleCount);
    Serial.println("Total Count: ");
    Serial.println(peopleCount);
    
    // Reset the timeout
    outsideTime = 0;
    insideTime = 0;
  }
  delay(100); // Add a small delay for stability
}

// Function to detect motion using ultrasonic sensor
bool detectMotion(int trigPin, int echoPin) {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  float duration = pulseIn(echoPin, HIGH);
  float distance = duration * 0.034 / 2;

  return (distance < maxDistance && distance > 0);
}

// Function for Wire
void send_count() {
  Wire.write(byte(peopleCount));
}