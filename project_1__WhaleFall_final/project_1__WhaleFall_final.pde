float realMouseX, realMouseY;
WhaleFall whaleFall1 = new WhaleFall(200);
int rectW;
int rectH;
int option = 0;
int keyPressedTime;


void setup(){
  size(800, 800);
  background(0);
  //noLoop();
}

void draw(){
  //background(0);
  noFill();
  stroke(255, 180);
  strokeWeight(0.7);
  if (option == 1){
    whaleFall1.breathing();
  } 
  //if (option == 2){
  //  println(whaleFall1.loadcenter());
  //  noLoop();
  //}
  if (option == 3){
    whaleFall1.fall();
  }
}

class WhaleFall{
  //WhaleFall variables
  float x, y;
  float selfX;
  float a = 0.0;//variable that decides each rotation
  float n1 = 10.0;
  float n2 = 20.0;
  float n3 = 30.0;
  float n4 = 40.0;//random for shrinking rate
  float n5 = 50.0;//random for rotation
  float factorShape = 70;//this is the value that determines the basic shape of the curve
  float factorX;
  float xDivider;
  float factorX1;
  float factorY;
  int cellsize = 2; //each grid is 2*2
  int cols = width/cellsize; //number of columns
  int rows = height/cellsize; //number of rows
  float shrinkNoise;
  float sRate = 0.994;//sRate start below 0.995 so that it will increase first everytime.
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
    a+= map(noise(n5), 0, 1, 0, 0.005); //this variable decides how fast the line rotates
    n5 += 0.3;
  }
  
  //load the pixel of the whalefall net
  int[] loadWhaleFallPixels(){
    int tempCount = 0;//pixels that are not black
    int[] midLoc = new int[2];//the list that's gonna be returned
    loadPixels();
    //background(0);
    int temp = width*height;
    //calculate how many pixels the whole drawing take
    for (int i = 0; i < temp; i++){
      if (pixels[i] != color(0)){
        //pixels[i/2] = pixels[i];
        //pixels[i] = color(0);
        tempCount++;
      }
    }
    //println(tempCount);
    int midCount = 0;//the pixel that is the mid number of pixels that aren't black
    //use w, h to calculate the exact loc of that medium pixel
    for (int h = 0; h < height; h++){
      for (int w = 0; w < width; w++){
        color c = get(w, h);
        if(c != color(0)){
          midCount++;
        }
        if(midCount == int(tempCount/2)){
          midLoc[0] = w;
          midLoc[1] = h;
        }
      }
    }
    
    return midLoc;
  }
  
  //create a function for getting the center of gravity
  int[] loadcenter(){
    int minW = 800;
    int maxW = 0;
    int minH = 800;
    int maxH = 0;
    for (int h = 0; h <800; h++){
      for (int w = 0; w < 800; w++){
        if (get(w, h) != color(0)){
          if (w < minW){
            minW = w;
          } else if (w > maxW){
            maxW = w;
          }
          if (h < minH){
            minH = h;
          } else if (h > maxH){
            maxH = h;
          }
        }
      }
    }
    //println(minW, maxW, minH, maxH);
    int[] gravityMid = new int[2];
    gravityMid[0] = minW + (maxW - minW)/2;
    gravityMid[1] = minH + (maxH - minH)/2;
    return gravityMid;
  }
  
  //make the effect of whale breathe, takes in the mid location as parameter 
  //the whalefall shrinks around the mid loc
  
  void breathe(float r){
    int[] midLoc1 = loadWhaleFallPixels();
    loadPixels();
    int midW = midLoc1[0];//mid width of whalefall
    int midH = midLoc1[1];//mid height of whalefall
    background(0);
    int i = 0;
    //to make it shrinking around mid point it has to be processed in 4 parts
    for (int h  = 0; h < 800; h++){
      for (int w = 0; w < 800; w++){
        if (pixels[i] == color(0)) {
          i++;
          continue;
        }
        int realW = 0;
        int realH = 0;
        //pixels closer to the middle pixels under a distance of 150 don't move 
        //problem if every pixel move is that there will be black grid appearing along the middle location
        //which I spent whole day solving but didnt work
        if (dist(midW, midH, w, h) < 150) {
          realW = w;
          realH = h;
        } else {
          realW = int((w-midW)*r+midW);//move the rest of the pixels further from the mid loc or closer towards it 
          realH = int((h-midH)*r+midH);
        }
        set(realW, realH, pixels[i]);
        i++;
      }
    }
    //updatePixels();
  }
  
  //make whalefall breathe automatically
  void breathing(){
    int lag = millis() - keyPressedTime;//only run the breathing when time is at a certain millie second; otherwise the 
    //the movement will be too fast
    //shrinkNoise = map(noise(n4), 0, 1, 0, 0.01);
    if (lag%4  == 0){
      //sRate flow between 0.995 and 1.005: when it reach 1.005 it will start to decrease; when it reach 0.995 it will start to increase
      //this way the pixels will be spreading and shrinking in a certain range
      if (sRate <= 0.995){
        shrinkNoise = map(noise(n4), 0, 1, 0, 0.001);
      } else if (sRate >= 1.005){
        shrinkNoise = map(noise(n4), 0, 1, -0.001, 0);
      }
      sRate = sRate + shrinkNoise;
      //println(sRate);
      n4 += 0.00001;
      breathe(sRate);
    }
  }
  
  //task: the drawing fades gradually in pixels
  void fall(){
    float radius = 800;
    //loadPixels();
    int[] midLoc2 = new int[2];
    midLoc2 = loadcenter();
    //println(midLoc2);
    int midW1 = midLoc2[0];
    int midH1 = midLoc2[1];
    
    //background(0);
    //falling from the outsdie layer; every layers is differed with a 50 pixels radius
    for (radius = 800; radius >= 0; radius -=100){
      int i = 0;
      loadPixels();
      background(0);
      for (int h = 0; h <800; h++){
        for (int w = 0; w < 800; w++){
          float temp = abs(dist(w, h, midW1, midH1));
          //important to have the condition radius > 40 otherwise theres gonna 
          //be remaining forever
          if(temp < radius && radius >100){
              set(w, h, pixels[i]);
              i++;//do each layer at a time so the pixels within the radius stay the same
          } else{
            if (w <= midW1){
              if (h <= midH1){
                set(w - int(random(0, radius/100 + 1)), h - int(random(0, radius/100 + 1)), pixels[i]);
                i++;
                //upper left of the gravity mid loc goes further upper left
              } else {
                set(w - int(random(0, radius/100 + 1)), h + int(random(0, radius/100 + 1)), pixels[i]);
                i++;
                //bottom left of the gravity mid loc goes further bottom left
              }
            } else{
              if (h <= midH1){
                set(w + int(random(0, radius/100 + 1)), h - int(random(0, radius/100 + 1)), pixels[i]);
                i++;
                //upper right of the gravity mid loc goes further upper right
              } else{
                set(w + int(random(0, radius/100 + 1)), h + int(random(0, radius/100 + 1)), pixels[i]);
                i++;
                //bottom right of the gravity mid loc goes further bottom right
              }
            }
          } 
        }
      }
    }
    //updatePixels();

    
  }
  
}

void mouseDragged(){
    realMouseX = mouseX;
    realMouseY = mouseY;
    if (mouseX != pmouseX){ //avoid curve cluster when the mouse stays at the same place
      whaleFall1.display();
    }
}

void keyPressed(){
  
  if (key == 's') {
    saveFrame("whaleFall-######.jpg");
  } else {
    option++;
    if (option == 1){
      keyPressedTime = millis();
    } else if (option > 3){
      option = 0;
    }
  }
}

  
 
