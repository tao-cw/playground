#include <xcb/xcb.h>
#include <stdio.h>

int
main(void)
{
	xcb_connection_t* c;
	int n = 99;

	xcb_connect(NULL, &n);
	printf("screen %d\n", n);

	return 0;
}
