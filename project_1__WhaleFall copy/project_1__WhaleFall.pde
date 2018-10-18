float x, y;
//float inc = TWO_PI/25.0;
float a = 0.0;
float n = 0.0;
float n1 = 10.0;
float n2 = 20.0;
float n3 = 30.0;
float factorShape = 100;//this is the value that determines the basic shape of the curve
float factorX;
float factorX1;
float factorY;
void setup(){
  size(800, 800);
  //noLoop();
}

void draw(){
  
  noFill();
  stroke(255);
  strokeWeight(0.1);
  //for (a = 1; a< 500; a++){
  //  pushMatrix();
  //  translate(400, 400);
  //  rotate(radians(a));
  //  scale(0.5);
    
  //    beginShape();
      
  //    for(x = -200; x < 200; x++){
  //      y = sin(radians(x*2))*50 + a + (map(noise(n), 0, 1, -5, 5));
  //      curveVertex(x, y);
  //      n += 0.1;
  //      x ++;
    
  //    }
  //    endShape();
  //  popMatrix();
  //}
}

void mouseDragged(){
  
  pushMatrix();
    translate(mouseX, mouseY);
    rotate(a);//how fast does the stroke rotate
    scale(0.5);
   
    factorX = map(noise(n1), 0, 1, -50, 50);//this decides the difference between each line of curve
    float xDivider = factorShape + factorX; //this variable decides how each line is fundamentally different with each other; how wide the curve is
    factorX1 = map(noise(n3), 0, 1, -4, 2);//how the curve shift horizontally
    factorY = map(noise(n2), 0, 1, 60, 150);//factorY decides the height of each curve
   
    beginShape();
    //change whats within sin() after every for loop is done so that the curve changes each time
    
    // task: make the single curve more irregular;
    //right now it looks very regular and people can tell immedietely that it is from the sin/cos curve
    for(x = -300; x < 100; x++){
       
      y = sin(x/xDivider + factorX1)*factorY;
      curveVertex(x, y);
      //n += 0.1;
      x ++;
  
    }
    endShape();
    
    beginShape();
    
    for(x = -100; x < 300; x++){
      y = cos(x/xDivider + factorX1)*factorY; 
      curveVertex(x, y);
      //n += 0.1;
      x ++;
  
    }
    endShape();
      
    popMatrix();
    a+= 0.005; //this variable decides how fast the line rotates
    n1 += 0.1;
    n2 += 0.1;
    n3 += 0.01;
    //println(a);
}
