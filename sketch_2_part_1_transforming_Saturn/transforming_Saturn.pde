int option;
int celeX;
int celeY;
int saturnW;
int saturnH;
int ringW;
int ringH;
int angle;

void setup(){
  size(600, 600);
}

void draw(){
  background(255);
  celeX = 100;
  celeY = 100;
  saturnW = 60;
  saturnH = 60;
  ringW = 100;
  ringH = 30;
  angle = 4;
  if (option == 0){
    drawSaturn(300, 300, saturnW, saturnH, ringW, ringH, angle);
  }
  if (option == 1){
    float ringChange = 8;
    for (celeY = 100; celeY < 600; celeY +=200){
      for (celeX = 100; celeX < 600; celeX +=200){
        drawSaturn(celeX, celeY, saturnW, saturnH, ringW, ringH, angle);
        ringH -= ringChange;
        
        if (ringH <= 0){
          ringChange = -ringChange;
          ringH = -ringH;
        }
      }      
    }  
  }
  if (option == 2){
    int rectX = 100;
    int rectY = 100;
    //drawSaturn(celeX*3, celeY*3, saturnW*7, saturnH*7, ringW*7, ringH*7);
    for (int m = 0; m < 5; m++){
      drawSaturn(celeX*3, celeY*3 + 40, saturnW*7, saturnH*7, ringW*7, ringH*7, angle);
      rectMode(CORNER);
      noStroke();
      fill(255,50);
      rect(rectX, 0, 600, 600);
      noStroke();
      fill(255,50);
      rect(0, rectY, 600, 600);
      rectX += 100;
      rectY += 100;
      celeY -= 6;
      
    }
  }
  if (option == 3){
    float celeIncrement = 1.6;
    celeX = 40;
    celeY = 40;
    angle = -4;
    int rectFill = 100;
    while (celeX < 1200){
      drawSaturn(celeX, celeY, saturnW, saturnH, ringW, ringH, angle);
      angle *= 1.5;
      celeX *= celeIncrement;
      celeY *= celeIncrement;
      saturnW *= 1.5;
      saturnH *= 1.5;
      ringW *= 1.5;
      ringH *= 1.5;
      rectMode(CORNER);
      noStroke();
      fill(255, rectFill);
      rect(0, 0, 600, 600);
      rectFill -= 15;
    }
  }
  if (option == 4){
    float increY = 40;
    for (celeY = 50; celeY < 550; celeY += increY){
      float increX = 40;
      for (celeX = 50; celeX < 550; celeX += increX){
        drawSaturn(celeX, celeY, saturnW/3, saturnH/3, ringW/3, ringH/3, angle);
        if (celeX <= 300){
          increX *=1.25;
        }
        if (celeX > 300){
          increX /=1.25;
        }
      }
      if (celeY <= 300){
        increY *=1.25;
      }
      if (celeY > 300){
        increY /=1.25;
      }
    }
  }
  if (option == 5){
    angle = 3;
    for (celeY = 50; celeY <=250; celeY +=50){
      for (celeX = 50; celeX <= 250; celeX += 50){
        drawSaturn(celeX, celeY, saturnW/3, saturnH/3, ringW/3, ringH/3, angle);
      }
      angle +=2;
    }
    for (celeY = 350; celeY <=550; celeY +=50){
      angle -=2;
      for (celeX = 50; celeX <= 250; celeX += 50){
        drawSaturn(celeX, celeY, saturnW/3, saturnH/3, ringW/3, ringH/3, -angle);
      }
      
    }
    angle = -3;
    for (celeY = 50; celeY <=250; celeY +=50){
      for (celeX = 350; celeX <= 550; celeX += 50){
        drawSaturn(celeX, celeY, saturnW/3, saturnH/3, ringW/3, ringH/3, angle);
      }
      angle -=2;
    }
    for (celeY = 350; celeY <=550; celeY +=50){
      angle +=2;
      for (celeX = 350; celeX <= 550; celeX += 50){
        drawSaturn(celeX, celeY, saturnW/3, saturnH/3, ringW/3, ringH/3, -angle);
      }
      
    }
  }
  if (option == 6){
    for (celeY = 100; celeY <600; celeY +=100){
      drawSaturn(300, celeY, saturnW*1.5, saturnH*1.5, ringW*1.5, ringH*1.5, angle);
      drawSaturn(300, celeY + 10, saturnW*1.5, saturnH*1.5, ringW*1.5, ringH*1.5, angle);
    }
    for (celeY = 100; celeY <600; celeY +=100){
      rectMode(CORNER);
      noStroke();
      fill(255,60);
      rect(0, celeY, 300 + 5, 600);
    }
    for (celeY = 500; celeY >0; celeY -=100){
      rectMode(CORNER);
      noStroke();
      fill(255,60);
      rect(300 - 5, 0, 600, celeY + 10);
    }
    
  }
  



}

void drawSaturn(float x, float y, float z, float i, float j, float k, int l){
  //draw saturn
  ellipseMode(CENTER);
  stroke(255, 81, 16);
  fill(138, 50, 232, 60);
  ellipse(x, y, z, i);
  //draw ring
  ellipseMode(CENTER);
  stroke(255, 81, 16);
  fill(146, 245, 189, 80);
  translate(x, y);
  rotate(PI/l);
  ellipse(0, 0, j, k);
  rotate(-PI/l);
  translate(-x, -y);
}

void keyPressed(){
  option++;
  if (option > 6){
    option = 0;
  }
  
}
