// === Pinos do L298N ===
const int IN1 = 5;
const int IN2 = 4;
const int ENA = 9;

const int IN3 = 7;
const int IN4 = 6;
const int ENB = 10;

void setup() {
  // Configura os pinos como saída
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(ENA, OUTPUT);

  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);
  pinMode(ENB, OUTPUT);

  // Define a velocidade inicial (0 a 255)
  analogWrite(ENA, 245);  // Motor A
  analogWrite(ENB, 245);  // Motor B
}

void loop() {
  // Movimento para frente
  digitalWrite(IN1, HIGH);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, HIGH);
  digitalWrite(IN4, LOW);
  delay(10000);

  // Movimento para trás
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, HIGH);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, HIGH);
  delay(10000);
}
