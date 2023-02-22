class Player {
  PImage img2;
  float posY;
  float posX;
  int size;
  float maxSpeed;
  float rotation;
  int isRotating;
  boolean shotFired;

  Player() {
    img2 = loadImage("ship.png");
    //Image Reference: https://www.pngegg.com/en/png-zwzik/download
    posX = width / 2;
    posY = height / 2;
    size = 15;
    rotation = 0;
    maxSpeed = PI/40;
    isRotating = 0;
    shotFired = false;
  }

  public void Update() {
    if (isRotating == -1) {
      rotation = rotation + maxSpeed;
    } else if (isRotating ==1) {
      rotation = rotation - maxSpeed;
    }
  }

  public void Render() {
    push();
    translate(posX, posY);
    rotate(rotation);
    imageMode(CENTER);
    //How I learned to center the image on the center point
    //https://p5js.org/reference/#/p5/imageMode
    image(img2, 0, 0, size+40, size+40);
    pop();
  }

  public Laser Fire() {
    Laser beam = new Laser(posX, posY, rotation);
    return beam;
  }
  public boolean CheckCollision(Comet a) {
    float d = dist(posX, posY, a.posX, a.posY);
    if (d < (a.size+size)*4/5)
    {
      return true;
    } else return false;
  }
}
