#include <string.h>

#include <X11/Xatom.h>
#include <xcb/xcb.h>

int
main ()
{
  xcb_connection_t *c;
  xcb_screen_t     *screen;
  xcb_window_t      win;
  char             *title = "Hello World !";
  char             *title_icon = "Hello World ! (iconified)";



  /* Open the connection to the X server */
  c = xcb_connect (NULL, NULL);

  /* Get the first screen */
  screen = xcb_setup_roots_iterator (xcb_get_setup (c)).data;

  /* Ask for our window's Id */
  win = xcb_generate_id (c);

  /* Create the window */
  xcb_create_window (c,                             /* Connection          */
                     0,                             /* depth               */
                     win,                           /* window Id           */
                     screen->root,                  /* parent window       */
                     0, 0,                          /* x, y                */
                     250, 150,                      /* width, height       */
                     10,                            /* border_width        */
                     XCB_WINDOW_CLASS_INPUT_OUTPUT, /* class               */
                     screen->root_visual,           /* visual              */
                     0, NULL);                      /* masks, not used     */

  /* Set the title of the window */
  xcb_change_property (c, XCB_PROP_MODE_REPLACE, win,
                       XA_WM_NAME, STRING, 8,
                       strlen (title), title);

  /* Set the title of the window icon */
  xcb_change_property (c, XCB_PROP_MODE_REPLACE, win,
                       XA_WM_ICON_NAME, XA_STRING, 8,
                       strlen(title_icon), title_icon);

  /* Map the window on the screen */
  xcb_map_window (c, win);

  xcb_flush (c);

  while (1) {}

  return 0;
}
