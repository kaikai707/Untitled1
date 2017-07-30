/*
  An interactive digital art installation for my Spring 2017 ARTS 375 class
*/
import SimpleOpenNI.*;

SimpleOpenNI kinect;

PVector rootNoise;

int numWaves = 150;
float radius = 750;
int userDist = 70;

int colorMode = 0;    // make an enumeration
int numColModes = 5;  // remove this

Boolean noiseOn = true;
PVector center;
PVector position;
PVector user = new PVector(-100, -100);

Wave[] waves;

ArrayList<PVector> users;

boolean shouldReset = true;


void setup()
{
  size(1200, 800, P2D);
  reset();
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
}

void reset()
{  
  center = new PVector(width/2, height/2);
  strokeWeight(1);
  
  rootNoise = new PVector(random(100), random(100));
  
  waves = new Wave[numWaves];
  for(int i = 0; i < numWaves; i++)
  {
    waves[i] = new Wave(i * TWO_PI/numWaves, 3 * radius, colorMode);
  }
}

void draw()
{
  noStroke();
  fill(20, 10, 20);
  rect(0, 0, width, height);
  rootNoise.add(new PVector(.01, .01));
  strokeWeight(1);
  
  kinect.update();
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  
  users = new ArrayList();
  
  //get all the current users
  for (int i = 0; i < userList.size(); i++){
    
    int userId = userList.get(i);
    
    position = new PVector();
    kinect.getCoM(userId, position);
    
    kinect.convertRealWorldToProjective(position, position);
    position.x = map(position.x, 0, 640, 0, width);
    position.y = map(position.y, 0, 480, 0, height);
    position.z = map(position.z, 3000, 0, 50, 90);  // map z value to maximum distance from kinect in mm
    
    users.add(position);
    
    noStroke();
    fill(255, 0, 0);
    ellipse(position.x, position.y, 10, 10);
  }
  
  for(int j = 0; j < numWaves; j++){
    waves[j].update();
  }
  
  // reset everyday at midnight
  if ( hour() == 0 && minute() == 0 & second() == 0 && shouldReset){
    
    println("Reseting....");
    reset();
    shouldReset = false;
  }
  if (hour() == 0 && minute() == 30 && !shouldReset){
   println("Seting was reset to false....");
   shouldReset = true;
  }
}