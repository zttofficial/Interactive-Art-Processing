// Constants and variables for Bagua symbols
PFont font;
String[] bagua = {"\u2630", "\u2637", "\u2632", "\u2633", "\u2634", "\u2635", "\u2636", "\u2631"}; // Unicode symbols for trigrams (☰☷☲☳☴☵☶☷)
String[] baguaNames = {"Qian", "Kun", "Li", "Zhen", "Xun", "Kan", "Gen", "Dui"};
color[] baguaColors;
int currentBagua = 0;
float yinYangRatio = 0.5; // Starts balanced
float taijiAngle = 0; // Angle for Taiji rotation

void setup() {
  size(800, 800);
  font = createFont("Serif", 32);
  textFont(font);
  setupColors();
}

void draw() {
  background(0); // Ensure background is set to black

  // Get current time and calculate user's trigram based on time and location
  int currentHour = hour();
  int currentMinute = minute();
  int currentSecond = second();
  float latitude = random(-90, 90); // Simulate user latitude for demo purposes
  float longitude = random(-180, 180); // Simulate user longitude for demo purposes

  currentBagua = calculateTrigram(currentHour, currentMinute, latitude, longitude);

  // Draw the rotating Taiji symbol
  drawTaiji();

  // Draw the Bagua symbols dynamically
  drawBagua(currentSecond);

  // Display the trigram name and current time
  displayInfo(currentHour, currentMinute);

  // Update Taiji rotation angle
  taijiAngle += 0.01 + (currentHour / 24.0) * 0.1; // Faster at night
}

void keyPressed() {
  // Change Yin-Yang ratio using keyboard input
  if (key == 'w') {
    yinYangRatio = constrain(yinYangRatio + 0.05, 0.1, 0.9);
  } else if (key == 's') {
    yinYangRatio = constrain(yinYangRatio - 0.05, 0.1, 0.9);
  }

  // Switch Bagua trigrams manually
  if (key == 'a') {
    currentBagua = (currentBagua - 1 + 8) % 8;
  } else if (key == 'd') {
    currentBagua = (currentBagua + 1) % 8;
  }
}

int calculateTrigram(int hour, int minute, float latitude, float longitude) {
  float totalInfluence = hour + minute + abs(latitude) + abs(longitude);
  return int(totalInfluence) % 8; // Calculate trigram based on total influence
}

void drawBagua(int second) {
  pushMatrix();
  translate(width / 2, height / 2);

  // Rotate based on time and interactions
  rotate(frameCount * 0.01 + map(mouseY, 0, height, 0, TWO_PI));

  for (int i = 0; i < 8; i++) {
    float angle = TWO_PI / 8 * i;
    fill(baguaColors[i]);
    noStroke();
    pushMatrix();
    rotate(angle);
    translate(300 + sin(frameCount * 0.01 + i + second * 0.1) * 20, 0); // Add oscillation effect
    textAlign(CENTER, CENTER);
    if (i == currentBagua) {
      textSize(48); // Highlight current trigram
    } else {
      textSize(32);
    }
    text(bagua[i], 0, 0);
    popMatrix();
  }

  popMatrix();
}

void drawTaiji() {
  float diameter = 300;
  float yinAngle = TWO_PI * yinYangRatio;
  float yangAngle = TWO_PI - yinAngle;

  pushMatrix();
  translate(width / 2, height / 2);
  rotate(taijiAngle); // Rotate the entire Taiji symbol

  // Yin
  noStroke();
  fill(0); // Black for Yin
  arc(0, 0, diameter, diameter, PI - yinAngle / 2, PI + yinAngle / 2);

  // Yang
  fill(255); // White for Yang
  arc(0, 0, diameter, diameter, PI + yinAngle / 2, PI - yinAngle / 2);

  // Small Yin in Yang
  fill(0); // Black dot in Yang
  ellipse(0, -diameter / 4, diameter / 8, diameter / 8);

  // Small Yang in Yin
  fill(255); // White dot in Yin
  ellipse(0, diameter / 4, diameter / 8, diameter / 8);

  popMatrix();
}

void displayInfo(int currentHour, int currentMinute) {
  fill(255);
  textAlign(CENTER);
  text("Current Bagua: " + baguaNames[currentBagua], width / 2, height - 60);
  text("Time: " + nf(currentHour, 2) + ":" + nf(currentMinute, 2), width / 2, height - 30);
}

void setupColors() {
  baguaColors = new color[] {
    color(255, 0, 0), // Qian
    color(255, 255, 0), // Kun
    color(255, 128, 0), // Li
    color(0, 255, 0), // Zhen
    color(0, 255, 255), // Xun
    color(0, 128, 255), // Kan
    color(128, 0, 255), // Gen
    color(255, 0, 128) // Dui
  };
}
