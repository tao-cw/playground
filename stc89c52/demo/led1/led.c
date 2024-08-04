#include <mcs51/8051.h>

static void delay(unsigned int t) {
  while (t--);
}

void main(void) {
  for (;;) {
    P2_5 = 0;
    delay(100000);
    P2_5 = 1;
    delay(100000);
  }
}
