#include "WProgram.h"

#include <avr/pgmspace.h>

#include "Defines.h"

#include "World72PixelBMPData.h"

//#include "Pumpkin.h"

//#include "World2BitmapReverse.h"

//#include "TestImage1.h"

#include "Globals.h"

void setup() 
{
 // Serial.begin(9600);
 
  pinMode(SpinInput, INPUT);
  
  lastSpinTime = micros();

  pinMode(col0, OUTPUT);
  pinMode(col1, OUTPUT);
  pinMode(col2, OUTPUT);
  pinMode(col3, OUTPUT);
  pinMode(col4, OUTPUT);
  pinMode(col5, OUTPUT);
  pinMode(col6, OUTPUT);
  pinMode(col7, OUTPUT);
  pinMode(col8, OUTPUT);

  pinMode(row0, OUTPUT);
  pinMode(row1, OUTPUT);
  pinMode(row2, OUTPUT);
  pinMode(row3, OUTPUT);
  pinMode(row4, OUTPUT);
  pinMode(row5, OUTPUT);
  pinMode(row6, OUTPUT);
  pinMode(row7, OUTPUT);

  Clear();
  
  //ALL ON
  for(int j = 0; j < ImageRows; j++)
  {
     for(int j = 0; j < ImageRows; j++)
    {
      digitalWrite(pins[j][0], LEDOrientation);
      digitalWrite(pins[j][1], !LEDOrientation);
    }
    digitalWrite(pins[j][0], !LEDOrientation);
    digitalWrite(pins[j][1], LEDOrientation);
    delay(30);
  }
  
  attachInterrupt(SpinInterrupt, spinInterrupt, FALLING);

}

bool inInterrupt = false;

void spinInterrupt()
{
  if(lastSpinTime == 0)
  {
    lastSpinTime = micros();
    return;
  }
  if(!inInterrupt && micros() - lastSpinTime > inturruptDebounce)
  {
    inInterrupt = true;
    //unsigned long spinTime = micros() - lastSpinTime;
    
   // microsPerPixelColumn = spinTime / ImageColumns;
   
   
    
    column = 0;
    LEDEight = 0;
    
    lastSpinTime = micros();
    inInterrupt = false;
  }
}

void loop()
{
  for(column = 0; column < ImageColumns; column++)
  {
    for(LEDEight = 0; LEDEight < LEDEights ; LEDEight++)
    {
      DrawLEDGroupsAtOnce(LEDEight, column);
    }
    //delayMicroseconds(microsPerPixelColumn);
  }

}

void Clear()
{
  for(int j = 0; j < ImageRows; j++)
  {
    digitalWrite(pins[j][0], LEDOrientation);
    digitalWrite(pins[j][1], !LEDOrientation);
  }
}

int lastEightOn = 0;


char GetImageLEDEights(int eight, int column)
{
  return pgm_read_byte(&(Image[column][eight])); 
}

void DrawLEDGroupsAtOnce(int eight, int column)
{
  digitalWrite(eightpins[lastEightOn][1], LEDOrientation);
  
  prog_uint8_t imageEights = GetImageLEDEights(eight, column);
  
  PORTB = (PORTB | B00110000) & ((imageEights << 4) | B11001111);
  PORTC = (PORTC | B00111111) & ((imageEights >> 2) | B11000000);
  
//  digitalWrite(eightpins[0][0], bitRead(imageEights, 0));
//  digitalWrite(eightpins[1][0], bitRead(imageEights, 1));
//  digitalWrite(eightpins[2][0], bitRead(imageEights, 2));
//  digitalWrite(eightpins[3][0], bitRead(imageEights, 3));
//  digitalWrite(eightpins[4][0], bitRead(imageEights, 4));
//  digitalWrite(eightpins[5][0], bitRead(imageEights, 5));
//  digitalWrite(eightpins[6][0], bitRead(imageEights, 6));
//  digitalWrite(eightpins[7][0], bitRead(imageEights, 7));
    
  digitalWrite(eightpins[eight][1], !LEDOrientation);
  
  lastEightOn = eight;
}

