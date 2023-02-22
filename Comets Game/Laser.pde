class Laser {

  float posX;
  float posY;
  float speed;
  float dir;
  float size;

  Laser(float pX, float pY, float pDir) {
    posX = pX;
    posY = pY;
    speed = 5;
    dir = pDir-HALF_PI;
    posX += 25*cos(dir);
    posY += 25*sin(dir);
    size = 2;
  }

  void Update() {
    posX += speed*cos(dir);
    posY += speed*sin(dir);
  }

  void Render() {
    push();
    noFill();
    stroke(255);
    strokeWeight(1);
    circle(posX, posY, size);
    pop();
  }
  public boolean CheckCollision(Comet a){
    float d = dist(posX, posY, a.posX, a.posY);
    if(d < (a.size+size)*3/5){
     return true; 
    }
    else return false;
  }
  
}
