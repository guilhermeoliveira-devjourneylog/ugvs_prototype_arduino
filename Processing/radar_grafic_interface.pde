// === Bibliotecas ===
import processing.serial.*;       // Comunicação serial com o Arduino
import java.awt.event.KeyEvent;   // Captura de eventos do teclado (não usado, mas pode ser útil futuramente)
import java.io.IOException;       // Tratamento de exceções (não usado explicitamente aqui)

// === Variáveis globais ===
Serial myPort;            // Objeto para comunicação serial
String angle = "";        // Ângulo recebido via serial
String distance = "";     // Distância recebida via serial
String data = "";         // String completa recebida via serial no formato "ângulo,distância."
float pixsDistance;       // Distância convertida para pixels
int iAngle, iDistance;    // Ângulo e distância convertidos para inteiros
int index1 = 0;           // Índice do separador (vírgula) na string de dados
PFont orcFont;            // Fonte para exibição do texto

// === Função de inicialização ===
void setup() {
  size(1280, 720); // Tamanho da janela (pode ser ajustado conforme necessário)
  smooth();        // Suaviza os gráficos
  
  // Mostra as portas seriais disponíveis no console
  println(Serial.list());
  
  // Inicializa a porta serial (ajuste "COM3" conforme sua porta local)
  myPort = new Serial(this, "COM7", 9600); 
  myPort.bufferUntil('.'); // Define "." como delimitador para leitura completa da mensagem

  // Cria a fonte usada na interface
  orcFont = createFont("Arial", 30); // Pode ser substituída por fonte customizada
}

// === Função chamada constantemente para desenhar a tela ===
void draw() {
  fill(98, 245, 31);        // Cor verde fosforescente
  textFont(orcFont);        // Define a fonte
  noStroke();               // Sem contorno para as formas
  
  // Fundo semi-transparente para efeito de escurecimento
  fill(0, 4);               
  rect(0, 0, width, height - height * 0.065);
  
  fill(98, 245, 31);        // Cor padrão para elementos do radar
  
  drawRadar();              // Desenha o radar (arcos e linhas)
  drawLine();               // Desenha a linha que representa o ângulo do servo
  drawObject();             // Desenha o objeto detectado se estiver próximo
  drawText();               // Exibe os dados (distância, ângulo etc.)
}

// === Função chamada automaticamente ao receber dados pela serial ===
void serialEvent(Serial myPort) {
  data = myPort.readStringUntil('.'); // Lê até encontrar o caractere '.'
  if (data != null && data.indexOf(",") > 0) {
    data = data.substring(0, data.length()-1); // Remove o ponto final
    index1 = data.indexOf(",");                // Encontra posição da vírgula
    angle = data.substring(0, index1);         // Pega o ângulo
    distance = data.substring(index1 + 1);     // Pega a distância
    
    // Converte para inteiros
    iAngle = int(angle);
    iDistance = int(distance);
  }
}

// === Desenha os arcos concêntricos e linhas radiais do radar ===
void drawRadar() {
  pushMatrix();
  translate(width / 2, height - height * 0.074); // Move origem para base do radar
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31); // Verde fosforescente

  // Arcos concêntricos representando distâncias
  arc(0, 0, width * 0.9, width * 0.9, PI, TWO_PI);
  arc(0, 0, width * 0.7, width * 0.7, PI, TWO_PI);
  arc(0, 0, width * 0.5, width * 0.5, PI, TWO_PI);
  arc(0, 0, width * 0.3, width * 0.3, PI, TWO_PI);

  // Linhas radiais de 30 em 30 graus
  for (int a = 0; a <= 180; a += 30) {
    line(0, 0, (width * 0.45) * cos(radians(a)), -(width * 0.45) * sin(radians(a)));
  }
  popMatrix();
}

// === Desenha a linha de varredura atual (posição do servo) ===
void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30, 250, 60); // Verde claro
  translate(width / 2, height - height * 0.074);
  line(0, 0, (height * 0.5) * cos(radians(iAngle)), -(height * 0.5) * sin(radians(iAngle)));
  popMatrix();
}

// === Desenha um ponto/vermelho se objeto for detectado a menos de 40cm ===
void drawObject() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  strokeWeight(9);
  stroke(255, 10, 10); // Vermelho para objeto detectado
  
  // Converte distância para pixels (ajuste da escala)
  pixsDistance = iDistance * (width * 0.01);
  
  // Apenas se estiver dentro de 40 cm (raio máximo visualizado)
  if (iDistance < 40) {
    line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)),
         (width * 0.45) * cos(radians(iAngle)), -(width * 0.45) * sin(radians(iAngle)));
  }
  popMatrix();
}

// === Exibe os valores de ângulo, distância e se o objeto está ao alcance ===
void drawText() {
  pushMatrix();
  fill(0); // Fundo preto
  noStroke();
  rect(0, height - height * 0.065, width, height);
  fill(98, 245, 31);

  // Escala em cm para a linha de fundo
  textSize(25);
  text("10cm", width * 0.6, height - height * 0.08);
  text("20cm", width * 0.7, height - height * 0.08);
  text("30cm", width * 0.8, height - height * 0.08);
  text("40cm", width * 0.9, height - height * 0.08);
  
  // Texto principal com informações de leitura
  textSize(40);
  text("Object: " + (iDistance < 40 ? "In Range" : "Out of Range"), width * 0.05, height - height * 0.02);
  text("Angle: " + iAngle + "°", width * 0.4, height - height * 0.02);
  text("Distance: " + iDistance + " cm", width * 0.65, height - height * 0.02);
  popMatrix();
}
