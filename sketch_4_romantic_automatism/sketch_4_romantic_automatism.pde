PImage img;
//int tile = 20;
int tileW, tileH;
float n1 = 10.0;//noise for how the image in each tile changes
float n2 = 20.0;//noise for the difference between each tile
int[] tileNoises;
IntList tileWpos = new IntList();//a array to store allt x postion of each tile
//int baseW = 0; //the start of all the tiles are from x = 0, the left side of the screen
String text = "ROMANTIC AUTOMATISM";//my text
void setup(){
  size(800, 600);
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
    }
    copy(img, tileWpos.get(t), 0, tileW, height, tileWpos.get(t), 0, int((tileW + tileNoises[t])), height);
    n1 += 2;
  }
}

//create a function to generate irregular tiles
void generatingTiles(){
  int tempW = 0;//base of each group of irregular tiles start from the left side of the image x = 0
  //int indexW = 0;//index count for the tileWpos array
  while(tempW < width){
    tileWpos.append(tempW);// add the new x pos of the tile
    tempW += int(map(noise(n2), 0, 1, 10, 80));
    //indexW++;
    n2 += 5;
  }
}
