float n1 = 0.0;
float n2 = 100.0;
int modeOption = 0;
FloatList echoStormX = new FloatList();
FloatList echoStormY = new FloatList();
FloatList echoStormTemp = new FloatList();
int[] echoStormZ = new int[50];
Echomon[] echoStorm = new Echomon[50];
float n3 = 0.0;
float n4 = 10.0;

Echomon echotester1;
Echomon echotester2;

void setup(){
  size(800, 800);
  echotester1 = new Echomon(100, -100, -150, 1.2);
  echotester2 = new Echomon(200, 200, 150, 0.6);
  echoStormX.clear();
  echoStormY.clear();
  echoStormTemp.clear();
  echoStormX.append(random(-250, -200));//the first x matters
  echoStormY.append(random(-400, -500));
  for (int i = 1; i <50; i++){
    echoStormX.append(echoStormX.get(i - 1) + map(noise(n3), 0, 1, 0, 25));
    n3++;
    echoStormY.append(echoStormY.get(i - 1) - map(noise(n4), 0, 1, 300, 500));
    n4 += 5;
  }
  //println(echoStormX);
  //println(echoStormY);
  echoStormX.shuffle();
  echoStormY.shuffle();
  
  for (int i = 0; i < 50; i++){
    echoStormZ[i] = int(random(0, 255));
    echoStorm[i] = new Echomon(echoStormX.get(i), echoStormY.get(i), echoStormZ[i], 1.0); 
    echoStormTemp.append(echoStormY.get(i));
  } //echomons are distributed horizontally with perlin noise, and more random vertically
   
}

void draw(){
  background(245, 220, 240);
  if (modeOption == 0){
    echotester1.yawn();
    echotester2.display();
  }
  
  if (modeOption == 1){
    for (int i = 0; i < 50; i++){
      echoStorm[i].rain("Jupiter");
      echoStorm[i].display();
      //println(echoStormY);
    }
    //make it rain endlessly...by taking y value and change to the initial y value
    for (int i = 0; i < 50; i++){
      if (echoStorm[i].getY() > 10000){
        echoStorm[i].set2(echoStormTemp.get(i));
        //println(echoStormY);
      }
    }
  }
  
 }

 class Echomon{
   
   //Echomon variables
   //colorVar makes each echomon change color differently
   int colorVar;
   int yawnOp = 0;
   float speed = 1;
   float scaleVar, realmouseX, realmouseY, initial1, initial2, gravityAc;
   
   //Echomon construction;
   Echomon(float x, float y, int z, float s){
     initial1 = x;
     initial2 = y;
     colorVar = z;
     scaleVar = s;
   }
   
   
   //display Echomon
   void display(){
     realmouseX = (mouseX*255)/700;
     realmouseY = (mouseY*255)/700;
      //draw body of Echomon
      pushMatrix();
      scale(scaleVar);
      stroke(255);
      strokeWeight(3);
      //BDC
      fill(abs(realmouseX - 30 + colorVar), abs(realmouseX - colorVar), abs(realmouseY - 30 + colorVar), 80);
      triangle(initial1 + 325, initial2 + 255, initial1 + 250, initial2 + 310, initial1 + 305, initial2 + 310);
      
      //ADEF
      stroke(255);
      fill(200, abs(realmouseX - 70 + colorVar), abs(realmouseY - 70 - colorVar), 80);
      quad(initial1+ 275, initial2 + 250, initial1 + 250, initial2 + 310, initial1 + 295, initial2 + 350, initial1 + 375, initial2 + 350);
      
      //EHI
      stroke(255);
      fill(abs(realmouseY -190 + colorVar), abs(realmouseX + 150 - colorVar), abs(realmouseY + colorVar), 80);
      triangle(initial1 + 295, initial2 + 350, initial1 + 260, initial2 + 435, initial1 + 450, initial2 + 350);
      
      //EGJ
      stroke(255);
      fill(abs(realmouseX - colorVar), abs(realmouseY + 80 + colorVar), abs(realmouseY -60 - colorVar), 80);
      triangle(initial1 + 295, initial2 + 350, initial1 + 300, initial2 + 450, initial1 + 380, initial2 + 350);
      
      //JMLK
      stroke(255);
      fill(abs(realmouseY + colorVar), abs(realmouseX +140 - colorVar), abs(realmouseY - 170 + colorVar), 80);
      quad(initial1 + 380, initial2 + 350, initial1 + 329, initial2 + 414, initial1 + 435, initial2 + 440, initial1 + 410, initial2 + 350);
      
      //eyes
      if (yawnOp == 0){
        noStroke();
        fill(255);
        ellipseMode(CENTER);
        ellipse(initial1 + 273, initial2 + 276, 5, 5);
        ellipse(initial1 + 299, initial2 + 288, 5, 5);
      }
      if (yawnOp == 1){
        fill(255);
        strokeWeight(2.0);
        line(initial1 + 271, initial2 + 276, initial1 + 275, initial2 + 276);
        line(initial1 + 297, initial2 + 288, initial1 + 301, initial2 + 288);
      }
      
      //mouth
      //2 mouth statuses depends on whether echomon is yawning or not
      noStroke();
      fill(255);
      if (yawnOp == 0){
        triangle(initial1 + 279, initial2 + 298, initial1 + 276, initial2 + 304, initial1 + 282, initial2 + 304);
      }
      if (yawnOp == 1){
        triangle(initial1 + 279, initial2 + 294, initial1 + 273, initial2 + 304, initial1 + 285, initial2 + 304);
      }
      popMatrix();
   }
   
   //make Echomon yawn. features: eye shape changes, shaking
   void yawn(){
     yawnOp = 1;
     //shaking
     initial1 = initial1 + map(noise(n1), 0, 1, -1, 1);
     initial2 = initial2 + map(noise(n2), 0, 1, -1, 1);
     n1 += 0.8;
     n2 += 0.8;
     display();
     yawnOp = 0;
   }
   
   //tools for reset initial1
   void set1(float newX){
     initial1 = newX;
   }
   
   //tools for reset initial2
   void set2(float newY){
     initial2 = newY;
   }
   
   //tools for see the value of Echomon
   String getValue(){
     return(initial1 + ", " + initial2 + ", " + colorVar + ", " + scaleVar);
   }
   
   float getY(){
     return initial2;
   }
   
   //make Echomon rain from the sky randomly, speed based on which planets Echomon locates
   void rain(String planet){
     if (planet == "Mercury"){
       gravityAc = 3;
     }
     if (planet == "Earth"){
       gravityAc = 5;
     }
     if (planet == "Saturn"){
       gravityAc = 6;
     }
     if (planet == "Neptune"){
       gravityAc = 8;
     }
     if (planet == "Jupiter"){
       gravityAc = 17;
     }
     //reset the new y position of Echomon so that it will drop
     set2(gravityAc + initial2);
     //display();
   }
 }

//switch between yawn mode and rain mode 
void keyPressed(){
  background(245, 220, 240);
  modeOption++;
  if (modeOption > 1){
    modeOption = 0;
  }
}
