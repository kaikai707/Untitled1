class MyColor
{
  /*
    Class to animate the color of each wave
  */
  float R, G, B, Rspeed, Gspeed, Bspeed;
  
  float minSpeed = 0.6;
  float maxSpeed = 1.8;
  float minR = 150;
  float maxR = 255;
  float minG = 0;
  float maxG = 255;
  float minB = 0;
  float maxB = 150;
  
  MyColor(ColorMode mode)
  {
     switch(mode){
        case RANDOM:
         minR = 0;
         maxR = 255;
         minG = 0;
         maxG = 255;
         minB = 0;
         maxB = 255;
         break;
      case ONE:
         minR = 150;
         maxR = 255;
         minG = 0;
         maxG = 255;
         minB = 0;
         maxB = 150;
         break;
      case TWO: 
        minR = 0;
        maxR = 150;
        minG = 150;
        maxG = 255;
        minB = 0;
        maxB = 255;
        break;
      case THREE:
        minR = 0;
        maxR = 255;
        minG = 150;
        maxG = 255;
        minB = 0;
        maxB = 150;
        break;
       case FOUR:
         minR = 200;
         maxR = 255;
         minG = 20;
         maxG = 120;
         minB = 100;
         maxB = 140;
        break;
     }
    
    init();
  }
  
  public void init()
  {
    R = random(minR, maxR);
    G = random(minG, maxG);
    B = random(minB, maxB);
    
    Rspeed = (random(1) > .5 ? 1 : -1) * random(minSpeed, maxSpeed);
    Gspeed = (random(1) > .5 ? 1 : -1) * random(minSpeed, maxSpeed);
    Bspeed = (random(1) > .5 ? 1 : -1) * random(minSpeed, maxSpeed);
  }
  
  public void update()
  {
    Rspeed = ((R += Rspeed) > maxR || (R < minR)) ? -Rspeed : Rspeed;
    Gspeed = ((G += Gspeed) > maxG || (G < minG)) ? -Gspeed : Gspeed;
    Bspeed = ((B += Bspeed) > maxB || (B < minB)) ? -Bspeed : Bspeed;
  }
  
  public color getColor()
  {
    return color(R, G, B);
  }
}
