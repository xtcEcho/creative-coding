PImage img;
//int tile = 20;
int tileW, tileH;
float n1 = 10.0;//noise for how the image in each tile changes
float n2 = 20.0;//noise for the difference between each tile
int[] tileNoises;
IntList tileWpos = new IntList();//a array to store allt x postion of each tile
//int baseW = 0; //the start of all the tiles are from x = 0, the left side of the screen
String[] textString; 
String text1;
PFont font;
int realMove = 0;
void setup(){
  size(800, 600);
  textString = loadStrings("romantic automatism1.txt"); 
  text1 = textString[0];//my text
  font = loadFont("SourceSansPro-SemiboldIt-48.vlw");
  img = loadImage("romantic automatism.jpg");
  image(img, 0, 0);
  generatingTiles();
  tileWpos.append(width);//add the last x pos at the end of the right side of the image
  tileNoises = new int[tileWpos.size() - 1];//create an array for the change of each tile
  for(int t = 0; t < (tileWpos.size()-1); t++){ 
    tileNoises[t] = 0;
  }
}

void draw() {
  background(187, 42, 11);
  //example tile: 10; change later for a more generative outcome
  //tileW = width/tile;
  //tileH = height/tile;
  for (int t = 0; t < (tileWpos.size() - 1); t++){
    tileNoises[t] += map(noise(n1), 0, 1, -7, 7);
    tileW = tileWpos.get(t+1) - tileWpos.get(t);//get the width of each tile, the last tile is neglected
    if (tileNoises[t] >0){
      tileNoises[t] = 0;
    } else if (tileNoises[t] < -tileW){
      tileNoises[t] = -int(tileW);
    }//the noise will always be in between 0 and the width of the tile
    copy(img, tileWpos.get(t), 0, tileW, height, tileWpos.get(t), 0, int((tileW + tileNoises[t])), height);
    n1 += 1;
    
    //singleAutomatism(tileWpos.get(t), -tileNoises[t], realMove);
  }
  
  for(int i = 0; i < tileNoises.length; i++){
    singleAutomatism(tileWpos.get(i + 1), int(-tileNoises[i]*1.5), realMove);//the abs of tileNoise has to times 1.5 to fill up the space
  }
  realMove+= 1;
  //textFont(font, 50);
  //textAlign(LEFT);
  //int temp = 50;
  //for (int i = 0; i < text1.length(); i++){
  //  text(text1.charAt(i), temp, 400);
  //  temp += textWidth(text1.charAt(i));
  //}
}

//create a function to generate irregular tiles
void generatingTiles(){
  int tempW = 0;//base of each group of irregular tiles start from the left side of the image x = 0
  //int indexW = 0;//index count for the tileWpos array
  while(tempW < width){
    tileWpos.append(tempW);// add the new x pos of the tile
    tempW += int(map(noise(n2), 0, 1, 20, 80));
    //indexW++;
    n2 += 10;
  }
}

//create a funtion to print out text in the blank space on one single tile
//textPos is the x pos on the canvas and textSize equals the noise change of each tile
//the text line up out outside of the canvas in this function
void singleAutomatism(int textPos, int textSize, int move){
  //IntList 
  if (textSize > 0){
    IntList tempList = new IntList();
    pushMatrix();
    translate(textPos, 0);
    rotate(-PI/2);//tanslate the canvas anti clockwise 90 degree so that the text come out vertically
    textFont(font, textSize);
    textAlign(LEFT);
    fill(0);
    int tempLetterPos = 0;//the initial postion of the first letter
    for (int m = 0; m < text1.length(); m ++){
      //println(tempLetterPos);
      char letter = text1.charAt(m);
      text(letter, tempLetterPos - move, 0);//move is the parameter that make the line move down
      tempList.append(tempLetterPos - move);
      tempLetterPos += textWidth(letter);//tempLetterPos increase so that the whole text line line up vertically off the canvas
    }
    popMatrix();
    //println(tempList);
  }
  
}

////make the line up text roll down endlessly
//void singleRolling(){
//  //IntList testInOneTile;//this is the arraylist for the chars in showing in one tile
//  i
//}
