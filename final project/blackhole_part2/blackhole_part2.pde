import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import megamu.mesh.*;
import ddf.minim.*;
Minim minim;

AudioPlayer space;
AudioPlayer oddity;
AudioPlayer die;

int blackHoleR = 30;
//float currentX, currentY;
//GhostCloud tester;
//two random angle values to determine the start of the cloud
float randomAngle1;
float randomAngle2;

float rangeOneside = PI/8;//this is the range (one side) that the stars will appear on the edge of the blackhole
//according to the position of mouse
PVector humanForce;//real time mouse location while dragging
PVector forceSpeed = new PVector(0.0, 0.0);
PVector locationForce = new PVector(0.0, 0.0);
Boolean forceBoolean = false;
float currentSpeed; //how fast the mouse dragged, use to control volume

int startTime;

int currentTime;

ArrayList<Star> oneDragCloud = new ArrayList<Star>(); //array that store stars that are created in one drag
ArrayList<Star> totalCloud = new ArrayList<Star>();//every star here
ArrayList<Star> baseStars = new ArrayList<Star>(2);// this is the array that stores the base stars that rooted on the edge of the black hole
//base stars are 2 stars generated based on the location and angle of the mouse when it's dragged

//float noiseR = 10.0;//noise input for generate cloud based on the line between two stars
int portion;


void setup() {
  size(800, 800);
  minim = new Minim(this);
  space = minim.loadFile("Actual Sounds From Space NASA Voyager Recordings.mp3");
  oddity = minim.loadFile("space lol  (AU Tracks) Audio.mp3");
  die = minim.loadFile("167929__speedenza__whoosh-puff.wav");
}

void draw() {
  background(0);
  ellipseMode(RADIUS);
  noFill();
  //todo: fill this black hole with radiance
  //stroke(30, 255, 63);
  for (int i = 1; i <= blackHoleR; i ++){
    float opacity = map(i, 1, blackHoleR, 0, 120);
    stroke(30, 255, 63, opacity);
    ellipse(width/2, height/2, i, i);
  }
 
  
  
  //change the delta time here!!
  if (keyPressed == true){
    //space.rewind();
    //space.play();
    currentTime = millis();
    if (oneDragCloud.size() != 0){ 
      ArrayList<Star> baseAndCloud = new ArrayList<Star>();
      baseAndCloud.addAll(baseStars);
      baseAndCloud.addAll(oneDragCloud);
      generateCloud(baseAndCloud);
      for (Star star: oneDragCloud){
        star.display();
        star.forcing();
      }
      //when mouse force is gone, black hole starts to absorb and in this process
      //the stars that meet with the edge of the black hole disappear
      if (mousePressed == false){
        //println("start");
        for(int i = 0; i < oneDragCloud.size(); i++){
          //determine whether the star has met the black hole edge
          //println(oneDragCloud.get(i).position.x, oneDragCloud.get(i).position.y);
          float tempDist = dist(width/2, height/2, oneDragCloud.get(i).position.x, oneDragCloud.get(i).position.y);
          if (tempDist < blackHoleR + 0.15 && tempDist > blackHoleR - 0.15){ //can't do == blackholeR bc its too precise will never work
           // println("work");
           fill(238, 255, 164);
           ellipse(oneDragCloud.get(i).position.x, oneDragCloud.get(i).position.y, 9, 9);
           die.rewind();
           die.setGain(200);
           die.play();
           oneDragCloud.remove(i);
          }
        }
      }
    }
  }
  
}

//todo:
//based on the delaunay cloud, generate star dust based on the edges:
//on a line between 2 end, the further away from either of the end (middle part), the bigger the offset is 
// or 
//build 1d perlin noise based on the line and make it flow like terrain
//or
//make each point on the line shines irregularly 
//generate Delaunay lines based on oneDragCloud
void generateCloud(ArrayList<Star> inputStars){
  float[][] oCloud = new float[inputStars.size()][2];
  for (int i = 0; i <inputStars.size(); i++){
    oCloud[i][0] = inputStars.get(i).position.x;
    oCloud[i][1] = inputStars.get(i).position.y;
  }
  Delaunay oneCloud = new Delaunay(oCloud);
  float[][] edges = oneCloud.getEdges();
  for (int i = 0; i < edges.length; i ++){
    float startX = edges[i][0];
    float startY = edges[i][1];
    float endX = edges[i][2];
    float endY = edges[i][3];
    generateDust(startX, startY, endX, endY);
    line(startX, startY, endX, endY);
  }
}

//generate dust base on the lines between every two stars
void generateDust(float sx, float sy, float ex, float ey){
  strokeWeight(0.1);
  noFill();
  stroke(19, 158, 39, 60);
  float noiseR = 10.0;
  float slope = (ey - sy)/(ex - sx);
  for (float x = sx; x < ex; x++){
    float y = slope*(x - sx) + sy;
    //generate radius of the circle based on the position on the line
    float distP = dist(sx, sy, x, y);//distance beween starting point and the real x,y
    float distTotal = dist(sx, sy, ex, ey);//total distance
    //make sure the distance can be measured from both end
    if (distP> distTotal/2){
      distP = dist(x, y, ex, ey);
    }
    float r = map(distP, 0, distTotal/2, 0, distTotal/2) + random(-10, 20);
    
    portion = int(map(distP, 0, distTotal/2, 20, 45));
    float onePortion = TWO_PI/portion;
    //draw the little circles in a circle around the x, y point on the line
    //the offsetR makes the circle relatively irregular
    for (int i = 0; i < portion; i++){
      float offsetR = map(noise(noiseR), 0, 1, 0, r);
      float x1 = (cos(onePortion *i))*(r - offsetR) + x;
      float y1 = (sin(onePortion *i))*(r - offsetR) + y;
      noiseR+=0.3;
      ellipse(x1, y1, 1, 1);//use nofill ellipse to make the dust looks pixelated to generate a telescope effect
    }
  }
}
PVector[] generateLocation(float mouseLocX, float mouseLocY){
  float mouseDir = atan2((mouseLocY - height/2),(mouseLocX - width/2));
  //println(mouseDir);
  //create the real whole range where stars will be generated
  float limit1 = mouseDir - rangeOneside;
  float limit2 = mouseDir + rangeOneside;
  //println(limit1, limit2);
  //ellipse(cos(limit1)*blackHoleR + width/2, sin(limit1)*blackHoleR + height/2, 3, 3);
  //ellipse(cos(limit2)*blackHoleR + width/2, sin(limit2)*blackHoleR + height/2, 3, 3);
  int oneTime = int(random(1, 4));//this is how many stars that will be generated once: 1, 2 or 3
  PVector[] starLoc= new PVector[oneTime];//store the location of each star
  //create new stars with PVector that stores the xpos and the ypos
  for (int i = 0; i < oneTime; i++){
    float tempAngle = random(limit1, limit2);
    starLoc[i] = new PVector(cos(tempAngle)*blackHoleR + width/2, sin(tempAngle)*blackHoleR + height/2);
  }
  return starLoc;
}

//this function is for genrating base stars on the blackhole based on the loaction of the mouse
ArrayList<Star> generateBaseStars(float mX, float mY){
  ArrayList<Star> tempBase = new ArrayList<Star>(2);
  if (keyPressed == true){
    
    float mouseDirTemp = atan2((mY - height/2), (mX - width/2));
    float mouseAngleTemp = PI/12;
    PVector Pbase1 = new PVector(cos(mouseDirTemp - mouseAngleTemp)*blackHoleR + width/2, sin(mouseDirTemp - mouseAngleTemp)*blackHoleR + height/2);
    PVector Pbase2 = new PVector(cos(mouseDirTemp + mouseAngleTemp)*blackHoleR + width/2, sin(mouseDirTemp + mouseAngleTemp)*blackHoleR + height/2);
    Star baseStar1 = new Star(Pbase1);
    Star baseStar2 = new Star(Pbase2);
    baseStar1.setStarRadius(0.1);
    baseStar2.setStarRadius(0.1);
    baseStar1.display();
    baseStar2.display();
    tempBase.add(0, baseStar1);
    tempBase.add(1, baseStar2);
  }
  return tempBase;
}

class Star {
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector randomForce;
  PVector blackHoleForce;
  PVector accBlackHoleForce;
  float starRadius;
  float noiseX;
  float noiseY;
  //float noiseZ;
  //perlin noise for the 3 dimension

  Star(PVector Pos) {
    position = new PVector(Pos.x, Pos.y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    randomForce = new PVector(0, 0);
    blackHoleForce = new PVector(0, 0);
    //accBlackHoleForce = new PVector(0, 0);//accumulative
    starRadius = random(1, 4);//change later: the bigger the radius is the bigger the mass is
    noiseX = int(random(1, 9)) * 10;
    noiseY = (random(1, 9)) * 10;
    //noiseZ = 10; // int(random(1, 9)) * 10;
  }

  void setStarRadius(float r){
    starRadius = r;
  }
  void display() {
    ellipseMode(RADIUS);
    fill(30, 255, 63);
    stroke(30, 255, 63);
    strokeWeight(1);
    ellipse(position.x, position.y, starRadius, starRadius);
  }

  void generateRandomForce(){
    randomForce = new PVector(map(noise(noiseX), 0, 1, -2, 2), map(noise(noiseY), 0, 1, -2, 2));
    noiseX+= 0.01;
    noiseY+= 0.01;
  }
  
  //create a function to generate blackhole gravity, so that the star will gradually move towards the edge of the the black hole 
  //while the mouse is not used
  void blackHoleForce(){
    float starDirTemp = atan2((position.y - height/2), (position.x - width/2));
    //this is the point on the black hole thats the closest to the star
    PVector forceOrigin = new PVector(cos(starDirTemp)*blackHoleR + width/2, sin(starDirTemp)*blackHoleR + height/2);
    PVector tempForce = new PVector(forceOrigin.x - position.x, forceOrigin.y - position.y);
    blackHoleForce.set(PVector.div(tempForce, map(starRadius, 1, 4, 400, 100)));
  }
  
  //todo: add another force base on the relative location of mouse to black hole
  void forcing() {
    //gonna have two force: the velocity that accumulates perlin noise acceleration
    //and the real time force that comes from the mouse movement
   
    PVector realF = PVector.div(forceSpeed, map(starRadius, 1, 4, 4, 1)); //real force depends on the size of the stars
    generateRandomForce(); 
    PVector realRF = PVector.div(randomForce, map(starRadius, 1, 4, 4, 1));
    //create the 3D effect by making the bigger ones move faster and the smaller one move slower
    position.add(velocity);
    position.add(realF);
    position.add(realRF);
    if (mousePressed == false){
      blackHoleForce();
      //accBlackHoleForce.add(blackHoleForce);
      position.add(blackHoleForce);
  
    }
  }
}

void mousePressed() {
  if (keyPressed == true){
    //oddity.setGain(0);
    oddity.loop();
    startTime = millis();
  
    //create the first two stars when first press down the mouse
    if (oneDragCloud.size() == 0){
      PVector[] tempPVList = generateLocation(mouseX, mouseY);//put the stars that are generated together in a temp array
      for (int i = 0; i < tempPVList.length; i++){
        Star tempStar = new Star(tempPVList[i]);
        oneDragCloud.add(tempStar);//put every star into the global arraylist so that it will show up in display and not disappearing
      }
    }
  
  }
 
}


//implement:
//stars will only be generated when mouse is moving further from the center of the black hole
//but existing stars will be attacted to mouse no matter where the mouse is moving to
void mouseDragged() {
  if (keyPressed == true){
    
    //int currentTime = millis();
    float deltaX = mouseX - pmouseX;
    float deltaY = mouseY - pmouseY;
    currentSpeed = sqrt(sq(deltaX) + sq(deltaY));
    println(currentSpeed);
    oddity.setGain(map(currentSpeed, 0, 15, -20, 60));
    //this is important in order to keep the mousedragg not so sensitive
    if (deltaX != 0 || deltaY != 0){
      //implement base Star 
      baseStars = generateBaseStars(mouseX, mouseY);
      
      int deltaTime = currentTime - startTime;
    
      float temp1 = dist(width/2, height/2, mouseX, mouseY);
      float temp2 = dist(width/2, height/2, pmouseX, pmouseY);
      if (temp1 >= temp2) {
        forceBoolean = true;
        forceSpeed.set((mouseX-pmouseX), (mouseY-pmouseY));
      } else {
        forceBoolean = false;
        forceSpeed.set((mouseX-pmouseX), (mouseY-pmouseY));
      }//determine whether is moving further from the blackhole center
      
      //only if when mouse is moving further from the blackhole and the delta time is dividable for 0
      //there will be new stars generated
      if (forceBoolean == true && deltaTime%100 == 0){
        println(deltaTime);
        PVector[] tempPVList = generateLocation(mouseX, mouseY);
        for (int i = 0; i < tempPVList.length; i++){
          Star tempStar = new Star(tempPVList[i]);
          oneDragCloud.add(tempStar);
        }
      }
    }
  }
  
}

void mouseReleased() {
  oddity.pause(); 
  forceBoolean = false;
  forceSpeed.set(0.0, 0.0);
  locationForce.set(0.0, 0.0);
}

void keyPressed(){
  space.setGain(100);
  space.play();
}
void keyReleased(){
  space.pause();
  startTime = -1;
  baseStars.clear();
  forceBoolean = false;
  forceSpeed.set(0.0, 0.0);
  oneDragCloud.clear();
}
