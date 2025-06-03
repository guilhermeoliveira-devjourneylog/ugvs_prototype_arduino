// Protopy UGVS 
// Robô autônomo com desvio de obstáculos baseado em sensor ultrassônico frontal

// === Pinos do L298N ===
const int IN1 = 5;
const int IN2 = 4;
const int ENA = 9;

const int IN3 = 7;
const int IN4 = 6;
const int ENB = 10;

// === Pinos do Sensor Ultrassônico ===
const int trigPin = 11;
const int echoPin = 12;

// === Threshold de distância frontal ===
const int OBSTACLE_DISTANCE_CM = 50;

long duration;
int distance;

void setup() {
  // === Setup dos motores ===
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(ENA, OUTPUT);

  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);
  pinMode(ENB, OUTPUT);

  analogWrite(ENA, 250);
  analogWrite(ENB, 250);

  // === Sensor ultrassônico ===
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  Serial.begin(9600);
}

void loop() {
  int dist = medirDistancia();

  // Envio opcional para monitoramento serial
  Serial.print("Distância frontal: ");
  Serial.print(dist);
  Serial.println(" cm");

  if (dist < OBSTACLE_DISTANCE_CM) {
    desviar();
  } else {
    seguirFrente();
  }

  delay(100);
}

// === Funções Auxiliares ===

int medirDistancia() {
  digitalWrite(trigPin, LOW); delayMicroseconds(2);
  digitalWrite(trigPin, HIGH); delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH, 20000UL); // timeout de 20ms
  distance = duration * 0.034 / 2;
  return distance;
}

void seguirFrente() {
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, HIGH);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, HIGH);
}

void parar() {
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, LOW);
}

void desviar() {
  parar();
  delay(150);

  // Ré
  digitalWrite(IN1, HIGH);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, HIGH);
  digitalWrite(IN4, LOW);
  delay(150);

  // Virar à esquerda
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, HIGH);
  digitalWrite(IN3, HIGH);
  digitalWrite(IN4, LOW);
  delay(250);

  parar();
  delay(150);
}
