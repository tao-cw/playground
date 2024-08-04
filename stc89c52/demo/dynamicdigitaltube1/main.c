#include <mcs51/8051.h>

typedef unsigned char u8;
typedef unsigned int u16;

u8 smgduan[17]={0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,
  0x7f,0x6f,0x77,0x7c,0x39,0x5e,0x79,0x71};

//when i=1, delay 10us
void delay(u16 i){
  while(i--){
  }
}

void DigDisplay(void){
  volatile u8 i;
  for(i = 0;i < 8;i++){
    switch(i){
      case 0:
        P2_2 = 1;
        P2_3 = 1;
        P2_4 = 1;
        break;
      case 1:
        P2_2 = 0;
        P2_3 = 1;
        P2_4 = 1;
        break;
      case 2:
        P2_2 = 1;
        P2_3 = 0;
        P2_4 = 1;
        break;
      case 3:
        P2_2 = 0;
        P2_3 = 0;
        P2_4 = 1;
        break;
      case 4:
        P2_2 = 1;
        P2_3 = 1;
        P2_4 = 0;
        break;
      case 5:
        P2_2 = 0;
        P2_3 = 1;
        P2_4 = 0;
        break;
      case 6:
        P2_2 = 1;
        P2_3 = 0;
        P2_4 = 0;
        break;
      case 7:
        P2_2 = 0;
        P2_3 = 0;
        P2_4 = 0;
        break;
    }
    P0 = smgduan[i];
    delay(100);
    P0 = 0x00;
  }
}

void main(void){
  while(1){
    DigDisplay();
  }
}
