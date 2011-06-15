int analog_current[6];
int analog_previous[6];

int i;
int c;
char buffer[256];

void setup () {
  Serial.begin (9600);
}

void loop () {
  for (i=0; i < 6; i+=1) {
    analog_current[i] = analogRead (i) / 10;
    c = sprintf (buffer, "%d\t", analog_current[i]);
    Serial.print (buffer);
  }

  Serial.println ("");
}
