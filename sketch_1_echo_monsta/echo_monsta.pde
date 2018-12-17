int initial1;
int initial2;
IntList snowXlist;
IntList snowYlist;
int initialY;

void setup() {
  size(700, 700);
  initial1 = 0;
  initial2 = 0;
  initialY = 0;
  snowXlist = new IntList();
  snowYlist = new IntList();
  for (int i = 0; i <15; i++){
    snowXlist.append(int(random(0, 700)));
    snowYlist.append(0 - int(random(0, 700)));
  }
  
}

void draw() {
  background(245, 220, 240);
  float realmouseX = (mouseX*255)/700;
  float realmouseY = (mouseY*255)/700;
  //add snow
  for (int i = 0; i < 15; i++){
    
    noStroke();
    fill(255);
    int snowY = snowYlist.get(i) + initialY;
    if (snowY > 700) {
      initialY = 0; 
    }
    ellipse(snowXlist.get(i), snowY + initialY, 10, 10);
  }
  initialY++;
  //BDC
  stroke(255);
  strokeWeight(3);
  fill(abs(realmouseX - 30), realmouseX, abs(realmouseY - 30), 80);
  triangle(initial1 + 325, initial2 + 255, initial1 + 250, initial2 + 310, initial1 + 305, initial2 + 310);
  
  //ADEF
  stroke(255);
  fill(200, abs(realmouseX - 70), abs(realmouseY - 70), 80);
  quad(initial1+ 275, initial2 + 250, initial1 + 250, initial2 + 310, initial1 + 295, initial2 + 350, initial1 + 375, initial2 + 350);
  
  //EHI
  stroke(255);
  fill(abs(realmouseY -190), abs(realmouseX + 150), realmouseY, 80);
  triangle(initial1 + 295, initial2 + 350, initial1 + 260, initial2 + 435, initial1 + 450, initial2 + 350);
  
  //EGJ
  stroke(255);
  fill(realmouseX, abs(realmouseY + 80), abs(realmouseY -60), 80);
  triangle(initial1 + 295, initial2 + 350, initial1 + 300, initial2 + 450, initial1 + 380, initial2 + 350);
  
  //JMLK
  stroke(255);
  fill(realmouseY, abs(realmouseX +140), abs(realmouseY - 170), 80);
  quad(initial1 + 380, initial2 + 350, initial1 + 329, initial2 + 414, initial1 + 435, initial2 + 440, initial1 + 410, initial2 + 350);
  
  //eyes
  noStroke();
  fill(255);
  ellipseMode(CENTER);
  ellipse(initial1 + 273, initial2 + 276, 5, 5);
  ellipse(initial1 + 299, initial2 + 288, 5, 5);
  
  //mouth
  noStroke();
  fill(255);
  triangle(initial1 + 279, initial2 + 298, initial1 + 276, initial2 + 304, initial1 + 282, initial2 + 304);
  
  if (keyPressed == true) {
    int random1 = int(random(-5, 5));
    initial1 = initial1 + random1;
    int random2 = int(random(-5, 5));
    initial2 = initial2 + random2;
    if (initial2 + 450 > 700){
      int reverse1 = abs(initial2 + 450 - 700);
      initial2 = 700 - reverse1 - 450;
    }
    if (initial1 + 250 < 0){
      int reverse2 = abs(initial1 + 250);
      initial1 = 250 - reverse2;
    }
    if (initial2 + 250 < 0){
      int reverse3 = abs(initial2 + 250);
      initial2 = 250 - reverse3;
    }
    if (initial1 + 450 > 700) {
      int reverse4 = abs(initial1 + 450 - 700);
      initial1 = 700 - reverse4 - 450;
    }
  
  
    
}



}
