const int led_pin = 13;
const long sleep_wait = 3000;
const long sleep_blink = 500;
const long sleep_flash = 250;

char buffer[256];

int led_state = 0,
    blink_count = 2;

bool force_blink = 0;

long sleep = sleep_blink;

unsigned long prev = 0,
              timer = 0;

void setup () {
  pinMode (led_pin, OUTPUT);
  Serial.begin (9600);
}

void blink () {
  if (force_blink > 0 || timer - prev > sleep) {
    prev = timer;
    if (force_blink > 0) force_blink = 0;

    if (led_state == 0) {
      if (blink_count > 0) {
        sleep = sleep_flash;
      }
      else {
        sleep = sleep_blink;
      }
      led_state = 1;
    }
    else {
      if (blink_count > 0) {
        blink_count -= 1;
        sleep = sleep_flash;
      } else {
        sleep = sleep_wait;
      }

      led_state = 0;
    }

    digitalWrite (led_pin, led_state);
  }
}

void read_buffer (char key) {
  int len = strlen (buffer);
  buffer[len] = key;
  buffer[len+1] = '\0';
}

void flush_buffer () {
  Serial.print (buffer);
}

/*
 * An ineffecient string-splitting function
 * kept for historical purposes
void walk_buffer () {
  int i  = 0,
      j  = 0,
      wc = 0,
      limit = strlen (buffer);

  char shift,
       delim = ' ',
       word[256],
      *wordlist[25];

  while (i <= limit) {
    shift = buffer[i];

    if (shift != delim && shift != '\0' && shift != '\n') {
      word[j] = shift;
      j += 1;
    }
    else if (j > 0) {
      word[j] = '\0';
      wordlist[wc] = strdup (word);

      word[0] = '\0';
      j = 0;
      wc += 1;
    }
 
    i+=1;
  }

  if (wc > 0) {
    if (!strcmp (wordlist[0], "blink")) {
      blink_count = 2;
      force_blink = 1;
    }
  }
}
*/

void token_buffer () {
  char *argb,
        delim[] = " ",
       *savedptr,
       *token = strtok_r (buffer, delim, &savedptr);

  if (token != NULL) {
    if (!strcmp (token, "blink")) {
      argb = strtok_r (NULL, delim, &savedptr);

      if (argb != NULL) {
        int count = atoi (argb);

        //XXX: Find out why the blink function needs to be offset like this
        if (count > 0) blink_count = count-1;
        else           blink_count = 2; 
      } 
      else blink_count = 2;

      force_blink = 1;
    }
  }
}

void read_input (char key) {
  if (key == '\n') {
    //walk_buffer();
    token_buffer();
    buffer[0] = '\0';
  }
  else {
    read_buffer (key);
  }
}

void echo_input (char key) {
  Serial.print (key);
}

void loop () {
  timer = millis();
  if (Serial.available() > 0) {
    read_input(Serial.read());
  }
  blink();
}
