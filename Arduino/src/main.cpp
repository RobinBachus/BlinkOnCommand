// This script uses an LED attached to pin 6.

#include <Arduino.h>

const int PinLedRed = 6;
const int PinMoter = 11; 
int UserInput = -1; 


void setup() {
  Serial.begin(9600);
  pinMode(6, OUTPUT);
}

void loop() {
  if (Serial.available() ){
    //read and print the monitor input
    UserInput = Serial.readString().toInt();
    if (UserInput != 264){
      Serial.println("UserInput: " + String(UserInput));
    }
  }
 
  if (UserInput == 264 ){
    analogWrite(PinLedRed, 255);
    Serial.println("On");
    delay(150);
    analogWrite(PinLedRed, 0);
    UserInput = -1;
  }
  else{
    UserInput = -1;
  }
  delay(15);
}
