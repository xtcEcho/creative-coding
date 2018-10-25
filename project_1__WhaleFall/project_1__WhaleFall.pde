float realMouseX, realMouseY;
WhaleFall whaleFall1 = new WhaleFall(200);

void setup(){
  size(800, 800);
  background(0);
  //noLoop();
}

void draw(){
  
  noFill();
  stroke(255);
  strokeWeight(0.1);
  
}

class WhaleFall{
  //WhaleFall variables
  float x, y;
  float selfX;
  float a = 0.0;//variable that decides each rotation
  float n1 = 10.0;
  float n2 = 20.0;
  float n3 = 30.0;
  float factorShape = 70;//this is the value that determines the basic shape of the curve
  float factorX;
  float xDivider;
  float factorX1;
  float factorY;
  //float realMouseX, realMouseY;
  //WhaleFall constructor

  WhaleFall(float realX){
    selfX = realX; // the user can define a new Whalefall curve by the input realX which decides how long the curve will be
  }
  
  //display one curve
  void display(){
    pushMatrix();
    translate(realMouseX, realMouseY);
    rotate(a);//how fast does the stroke rotate
    scale(0.5);
   
    factorX = map(noise(n1), 0, 1, -30, 30);//this decides the difference between each line of curve
    xDivider = factorShape + factorX; //this variable decides how each line is fundamentally different with each other; how wide the curve is
    factorX1 = map(noise(n3), 0, 1, -5, 5);//how the curve shift horizontally
    factorY = map(noise(n2), 0, 1, 30, 80);//factorY decides the height of each curve
   
    beginShape();
    //change whats within sin() after every for loop is done so that the curve changes each time
    
    // task: make the single curve more irregular; complete
    for(x = -selfX; x < selfX; x = x + 10){
      y = sin(x/xDivider + factorX1)*factorY + cos(x/(xDivider - 30) + factorX1)*factorY*0.3;//adding sin and cos together makes the curve really irregular
      //line(x - 1, y + 5, x + 1, y - 5);
      curveVertex(x, y);
      if (x%15 == 0){
        line(x - 0, y + 10, x + 0, y - 10);//vertical lines along each curve to make the net effect
      }
      
      //n += 0.1;
      //x ++;
      
    }
    endShape();
    popMatrix();
    //variables increase so that each curve is randomly different than each other
    a+= 0.01; //this variable decides how fast the line rotates
    n1 += 0.1;
    n2 += 0.1;
    n3 += 0.005;
  }
  
  //task: after the user stop drawing, rotate one axis so that the drawing looks like breathing
  //task: the drawing fades gradually in pixels
  //pixels/lines flow down
}

void mouseDragged(){
    realMouseX = mouseX;
    realMouseY = mouseY;
    if (mouseX != pmouseX){ //avoid curve cluster when the mouse stays at the same place
      whaleFall1.display();
    }
  }
