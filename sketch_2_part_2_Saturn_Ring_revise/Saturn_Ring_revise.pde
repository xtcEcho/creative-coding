
float radius = 60.0;
float mapRange;
int portions;
float n1 = 0.0;
float n2 = 100.0;
float increment;
float x;
float y;
FloatList xList = new FloatList();
FloatList yList = new FloatList();
int pressCount = 0;
int option = 0;
int lineX;
int lineY;
FloatList mxList = new FloatList();
FloatList myList = new FloatList();
int setCount = 0;
FloatList orixList = new FloatList();
FloatList oriyList = new FloatList();


void setup(){
  size(800, 800);
  background(111, 115, 117);
  frameRate(20);
}

void draw(){
  noFill();
  noStroke();
  portions = 180;
  mapRange = 10.0;
  increment = 0.2;
  if (option == 0){
    if (mousePressed && pressCount == 0){
      drawRings(mouseX, mouseY, radius, portions, mapRange, increment);
      lineX = mouseX;
      lineY = mouseY;
      pressCount++;
    } else if (mousePressed && pressCount >0){
      fill(98, 121, 145);
      strokeWeight(0.5);
      stroke(233, 255, 94);
      beginShape();
      for (int i = 0; i < portions; i++){
        vertex(xList.get(i), yList.get(i));
      }
      endShape();
      for (int i = 0; i < portions; i++){
        line(lineX, lineY, xList.get(i), yList.get(i));
        float tempx = xList.get(i)*1.01;
        xList.set(i, tempx);
        float tempy = yList.get(i)*1.01;
        yList.set(i, tempy);
        
      }
    }
    if (mousePressed == false){
      radius = 60;
      pressCount = 0;
    }
  }
  
  if (option == 1){
     if (mousePressed && pressCount == 0){
       drawRings(mouseX, mouseY, radius, portions, mapRange, increment);
       lineX = mouseX;
       lineY = mouseY;
      //radius++;
        pressCount++;
      } else if (mousePressed && pressCount >0){
        pushMatrix();
        translate(lineX, lineY);
        fill(191, 62, 55, 20);
        strokeWeight(0.3);
        stroke(163, 230, 255);
        if (setCount == 0){
          for (int i = 0; i < portions; i++){
            float matrixX = xList.get(i) - lineX;
            mxList.set(i, matrixX);
            float matrixY = yList.get(i) - lineY;
            myList.set(i, matrixY);
          }
          setCount++;
        }
        beginShape();
        for (int i = 0; i < portions; i++){
          vertex(mxList.get(i), myList.get(i));
        }
        endShape();
        
        
        for (int i = 0; i < portions; i++){
          line(0, 0, mxList.get(i), myList.get(i));
          mxList.set(i, mxList.get(i)*1.05);
          myList.set(i, myList.get(i)*1.05);
        }
        popMatrix();
      }
      if (mousePressed == false){
        radius = 60;
        pressCount = 0;
        setCount = 0;
      }
  }
}


void drawRings(float x, float y, float radius, int portions, float mapRange, float increment){
  xList.clear();
  yList.clear();
  beginShape();
  float x1;
  float y1;
  for(int i = 0; i<portions; i++){
    x1 =  x + radius*cos(TWO_PI*i/portions);
    y1 = y + radius*sin(TWO_PI*i/portions);
    x1 += map(noise(n1),0,1,-mapRange,mapRange);
    xList.append(x1);
    y1 += map(noise(n2),0,1,-mapRange,mapRange);
    yList.append(y1);
    vertex(x1,y1);
    n1 += increment;
    n2 += increment;
  }
  endShape();
  for(int i = 0; i < portions; i++){
    line(x, y, xList.get(i), yList.get(i));
  }
  
}

void mouseClicked(){
  //noFill();
  //stroke(0, 50);
  //radius = 120.0;
  //portions = 180;
  //mapRange = 10.0;
  //increment = 0.2;
  //drawRings(mouseX, mouseY, radius, portions, mapRange, increment);
  //option 1
}

void mouseDragged(){
  if (option == 2){
    radius = 90.0;
    portions = 225;
    mapRange = 15.0;
    increment = 0.2;
    if (pressCount == 0){
      noStroke();
      noFill();
      drawRings(mouseX, mouseY, radius, portions, mapRange, increment);
      for (int i = 0; i < portions; i++) {
        orixList.append(xList.get(i) - mouseX);
        oriyList.append(yList.get(i) - mouseY);
      }
      pressCount++;
    }
    pushMatrix();
    translate(mouseX, mouseY);
    for (int i = 0; i < portions; i++){
      strokeWeight(0.7);
      stroke(191, 171, 185);
      point(orixList.get(i), oriyList.get(i)); 
    } 
    popMatrix();  
  }
}


void mouseReleased(){
  radius = 60.0;
  pressCount = 0;
  setCount = 0;
  orixList.clear();
  oriyList.clear();
  n1 = 0.0;
  n2 = 100.0;
}

void keyPressed(){
  background(111, 115, 117);
  option++;
  if (option > 2){
    option = 0;
  }
}
