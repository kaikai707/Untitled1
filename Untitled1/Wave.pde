class Wave
{
  final static float DIST_MAX = 4.0;       //length of each segment
  final static float maxWidth = 50;        //max width of base line
  final static float minWidth = 11;        //min width of base line
  final static float FLOTATION = -3.5;     //floatation constatant

  float mouseDist; //mouse interaction distancce
  int numSegments;
  
  PVector[] pos;
  color[] cols;
  float[] rad;
  
  MyColor myCol;
  
  float x, y;
  float cosi, sinu;
  
    
  Wave(float p_rad, float p_length, int colorMode)
  {
     numSegments = (int)(p_length / DIST_MAX);
     pos = new PVector[numSegments];
     cols =  new color[numSegments];
     rad = new float[numSegments];
     
     myCol = new MyColor(colorMode);
     
     cosi = cos(p_rad);
     sinu = sin(p_rad);
     
     x = width/2 + radius*cosi;
     y = height/2 + radius*sinu;
     
     mouseDist = userDist;
     
     pos[0] = new PVector(x, y);
     for (int i = 1; i < numSegments; i++)
     {
       pos[i] = new PVector(pos[i -1].x - DIST_MAX*cosi, pos[i-1].y - DIST_MAX*sinu);
       cols[i] = myCol.getColor();
       rad[i] = 3;
     }
  }
  
  void update()
  {
     
     pos[0] = new PVector(x, y);
     for(int i = 1;  i < numSegments; i++)
     {
       float n = noise(rootNoise.x + .002 * pos[i].x, rootNoise.y + .002 * pos[i].y);
       float noiseForce = (.5 - n) * 7;
       if(noiseOn)
       {
         pos[i].x += noiseForce;
         pos[i].y += noiseForce;
       }
       
       PVector pv = new PVector(cosi, sinu);
       pv.mult(map(i, 1, numSegments, FLOTATION, .6*FLOTATION));
       pos[i].add(pv);
       
       // user interatction
       for (int k = 0; k < users.size(); k++)
       {
        user = users.get(k);
        handleCollisions(pos, i, user);
       }
       
       PVector tmp = PVector.sub(pos[i-1], pos[i]);
       tmp.normalize();
       tmp.mult(DIST_MAX);
       pos[i] = PVector.sub(pos[i - 1], tmp);
       
       // keep the wave points inside the circle
       if(PVector.dist(center, pos[i]) > radius)
       {
         PVector tmpPV = pos[i].get();
         tmpPV.sub(center);
         tmpPV.normalize();
         tmpPV.mult(radius);
         tmpPV.add(center);
         pos[i] = tmpPV.get();
       }
     }
     
     updateColors();
     display();
  }
  
  void display(){
     beginShape();
     noFill();
     
     for(int i = 0; i < numSegments; i++)
     {
       float r = rad[i];
       stroke(cols[i]);
       vertex(pos[i].x, pos[i].y);
     }
     endShape();
  }
  
  void handleCollisions(PVector[] t_pos, int i, PVector target)
  {
    target = new PVector(user.x, user.y);
    mouseDist = user.z;
    
    float d =  PVector.dist(target, pos[i]);
    if (d < mouseDist)
    {
      PVector tmpPV =  target.get();
      tmpPV.sub(pos[i]);
      tmpPV.normalize();
      tmpPV.mult(mouseDist);
      tmpPV = PVector.sub(target, tmpPV);
      pos[i] = tmpPV.get();
    }
  }
  
  void updateColors()
  {
    myCol.update();
    cols[0] = myCol.getColor();
    for(int i = numSegments - 1; i > 0; i--)
    {
      cols[i] = cols[i-1];
    }
  } 
}