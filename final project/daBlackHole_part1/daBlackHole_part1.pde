import megamu.mesh.*;

float[][] tempStars;
float[][] stars;
int starPopulation;
float[][] starLines;
Delaunay ghostStars;
int[][] starLinks;

int rows; //how many rows vertically
int oneGrid = 40;//the width and height of each grid

void setup(){
  size(800, 800, P3D);
  rows = width/oneGrid;
  starPopulation = 100;
  tempStars = new float[starPopulation][2];//40 stars(points), x and y for each stars
  stars = new float[starPopulation][2];
  for (int i = 0; i < starPopulation; i++){
    tempStars[i][0] = random(0, 800);
    tempStars[i][1] = random(0, 800);
    //println(stars[i][0], stars[i][1]);
  }
  ////rearrange the 2D array tempStars into a sorted 2D array stars in which 
  ////the points are put into rows horizontally
  ////for example: when points y<20; arrange the points based on the x
  for (int i = 0; i < rows; i++){
    for (int j = 0; j < starPopulation; j++){
      if (i*oneGrid <= tempStars[j][1] && tempStars[j][1]< (i+1)*oneGrid) {
        
      }
    }
  }
  //sortStars(tempStars);
  //for (int i = 0; i < starPopulation; i++){
  //  println(tempStars[i]);
  //}
 
  ghostStars = new Delaunay(stars);
  starLines = ghostStars.getEdges();
  starLinks = ghostStars.getLinks();
}

void draw(){
  background(0);
  stroke(3, 221, 6);
//  for(int i=0; i<starLinks.length; i++)
//{
//  int startIndex = starLinks[i][0];
//  int endIndex = starLinks[i][1];

//  float startX = stars[startIndex][0];
//  float startY = stars[startIndex][1];
//  float endX = stars[endIndex][0];
//  float endY = stars[endIndex][1];
//  stroke(3, 221, 6);
//  line( startX, startY, endX, endY );
//}
  //stroke(255);
  for (int i = 0; i < starLines.length; i++){
    float startX = starLines[i][0];
    float startY = starLines[i][1];
    float endX = starLines[i][2];
    float endY = starLines[i][3];
    //stroke(255);
    line(startX, startY, endX, endY);
  }
}

void sortStars(float[][] starPos){
  for (int i = 0; i < starPos.length; i++){
    for (int j = (i + 1); j < starPos.length; j++){
      if (starPos[i][0] > starPos[j][0]){
        float[] tempStarPos = new float[2];
        tempStarPos[0] = starPos[j][0];
        tempStarPos[1] = starPos[j][1];
        starPos[j] = starPos[i];
        starPos[i] = tempStarPos;
        
      }
    }
  }
}
//int OG = 40;  //(OG = one grid)
//int col, row;
////using 2D perlin noise so set up 2 noises
//float xNoise1, yNoise1;
//float yNoise2;
//float zNoise;//the different z of each vertex, the result of the 2D noise of xN and yN;

//float[][] daFlow;

//void setup(){
//  size(800, 800, P3D);
//  col = width/OG;
//  row = height/OG;
//  daFlow = new float[col + 1][row +1];
//  //xNoise1 = 0;
//  yNoise1 = 0;
//  //frameRate(20);
//}

//void draw(){
//  background(0);
//  xNoise1 = 0;
//  yNoise1 += 0.1;
//  yNoise2 = yNoise1; //this allows the continuity of the zNoise:
//  //every time xNoise start with 0 and ynoise2 is the real noise thats gonna be using.
//  //so yNoise2 starts 0.1 bigger than the loop before to create a flowing effect
//  for (int y = 0; y <= row; y++){
//    for (int x = 0; x <= col; x++){
//      daFlow[x][y] = map(noise(xNoise1, yNoise2), 0, 1, -50, 50);
//      xNoise1 += 0.1;
//     }
//     yNoise2 += 0.1;
//  }
//  noFill();
//  stroke(3, 221, 6);
 
//  for (int i = 0; i < row; i ++){ //y stays the same first for each loop so the outer nest is col
//    beginShape(QUAD_STRIP);
//    for (int j = 0; j <= col; j ++){
//      vertex(j*OG, i*OG, daFlow[j][i]);
//      vertex(j*OG, (i + 1)*OG, daFlow[j][i + 1]);
//      //println(i*OG, (j+1)*OG);
//    }
//     endShape();
//  } 

//}
