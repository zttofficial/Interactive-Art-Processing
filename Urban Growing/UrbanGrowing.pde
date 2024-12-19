ArrayList<Building> buildings; // 建築列表
ArrayList<Traveler> travelers; // 人與交通工具列表
int maxBuildings = 150; // 最大建築數量
int buildingLifetime = 800; // 建築壽命（幀數）

void setup() {
  size(800, 800);
  buildings = new ArrayList<Building>();
  travelers = new ArrayList<Traveler>();

  // 初始化生成建築
  for (int i = 0; i < 30; i++) {
    float x = random(width);
    float y = random(height * 0.5, height * 0.9); // 偏低的初始位置
    float baseSize = random(20, 50);
    buildings.add(new Building(x, y, baseSize));
  }

  // 初始化生成人與交通工具
  for (int i = 0; i < 10; i++) {
    travelers.add(new Traveler());
  }
}

void draw() {
  background(40);

  // 更新並繪製所有建築
  for (int i = buildings.size() - 1; i >= 0; i--) {
    Building b = buildings.get(i);
    b.update();
    b.display();

    // 移除過時建築
    if (b.age > buildingLifetime) {
      buildings.remove(i);
    }
  }

  // 更新並繪製人與交通工具
  for (Traveler t : travelers) {
    t.update();
    t.display();
  }

  // 添加說明文字
  fill(255, 150);
  textAlign(CENTER);
  textSize(14);
  text("Move your mouse to grow new buildings or make existing ones taller", width / 2, height - 20);
}

void mouseMoved() {
  // 鼠標移動時生成新建築
  if (buildings.size() < maxBuildings) {
    float x = mouseX + random(-30, 30);
    float y = mouseY + random(-30, 30);
    float baseSize = random(20, 50);

    // 確保新建築不與其他建築重疊
    if (!tooCloseToOthers(x, y, 60)) {
      buildings.add(new Building(x, y, baseSize));
    }
  }
}

boolean tooCloseToOthers(float x, float y, float minDist) {
  for (Building b : buildings) {
    if (dist(x, y, b.x, b.y) < minDist) return true;
  }
  return false;
}

class Building {
  float x, y, baseSize;
  float height;
  float growthSpeed;
  boolean growing;
  color buildingColor;
  int age; // 記錄建築存在的幀數
  int design; // 固定形狀設計

  Building(float x, float y, float baseSize) {
    this.x = x;
    this.y = y;
    this.baseSize = baseSize;
    this.height = baseSize;
    this.growthSpeed = random(0.5, 1.5); // 提高生長速度
    this.growing = false;
    this.age = 0;

    // 隨機分配建築形狀，調低摩天輪比例
    float r = random(100);
    if (r < 5) {
      this.design = 4; // 摩天輪
    } else if (r < 25) {
      this.design = 3; // CN Tower
    } else if (r < 50) {
      this.design = 2; // 雙子塔
    } else if (r < 80) {
      this.design = 1; // 哈里發塔
    } else {
      this.design = 0; // 簡單方形
    }

    // 建築顏色
    buildingColor = color(random(80, 150), random(80, 150), random(100, 200), 220);
  }

  void update() {
    age++; // 增加建築年齡

    // 鼠標靠近時讓建築長高
    float distance = dist(mouseX, mouseY, x, y);
    growing = distance < 100;

    if (growing) {
      height += growthSpeed;
      height = constrain(height, baseSize, 200);
      age = 0; // 重置壽命計數
    } else {
      height -= growthSpeed * 0.1;
      height = constrain(height, baseSize, 200);
    }
  }

  void display() {
    pushMatrix();
    translate(x, y);
    fill(buildingColor);
    noStroke();

    switch (design) {
      case 0:
        rect(-baseSize / 2, -height, baseSize, height);
        break;
      case 1: // 哈里發塔形狀
        triangle(-baseSize / 2, 0, 0, -height, baseSize / 2, 0);
        break;
      case 2: // 雙子塔形狀
        rect(-baseSize, -height, baseSize / 2, height);
        rect(baseSize / 2, -height, baseSize / 2, height);
        break;
      case 3: // CN Tower
        rect(-baseSize / 4, -height, baseSize / 2, height);
        ellipse(0, -height, baseSize, baseSize * 0.5);
        break;
      case 4: // 摩天輪
        for (int i = 0; i < 8; i++) {
          float angle = TWO_PI / 8 * i;
          float px = cos(angle) * baseSize / 2;
          float py = sin(angle) * baseSize / 2;
          ellipse(px, py - height / 2, baseSize * 0.1, baseSize * 0.1);
        }
        break;
    }
    popMatrix();
  }
}

class Traveler {
  float x, y, speedX, speedY;
  color c;

  Traveler() {
    x = random(width);
    y = random(height * 0.4, height * 0.9);
    speedX = random(-2, 2);
    speedY = random(-0.5, 0.5);
    c = color(random(200, 255), random(100, 150), random(100, 150), 200);
  }

  void update() {
    x += speedX;
    y += speedY;

    if (x < 0 || x > width) speedX *= -1;
    if (y < height * 0.4 || y > height * 0.9) speedY *= -1;
  }

  void display() {
    fill(c);
    noStroke();
    ellipse(x, y, 10, 10);
  }
}
