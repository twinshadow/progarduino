const int pr_ain = A0;
const int pm_ain = A5;
const int led_pin = 9;
const int toggle_pin = 2;

int pr_min = 50;
int pr_cur = 0;

int pm_cur = 0;
int fade = 0;

int toggle_block = 0;
int toggle_state = 1;
int toggle_current = 0;

void pm_led (void) {
  analogWrite (led_pin, fade);
}

int toggle_check (void) {
  if (digitalRead(toggle_pin) == 1) {
    if (toggle_block == 0) {
      if (toggle_state == 1) toggle_state = 0;
      else                   toggle_state = 1;

      toggle_block = 1;
    }
  }
  else toggle_block = 0;

  return toggle_state;
}

void setup () {
  Serial.begin(9600);
  pinMode(led_pin, OUTPUT);
  pinMode(toggle_pin, INPUT);
}

void loop () {
  toggle_state = toggle_check();
  if (toggle_state == 1) {
    pr_cur = analogRead(pr_ain);
    if (pr_cur < pr_min) {
      pm_cur = analogRead(pm_ain);
      fade = map(pm_cur, 0, 1023, 0, 255);
      pm_led();
    }
    else digitalWrite (led_pin, 0);
  }
  else digitalWrite (led_pin, 0);
}
