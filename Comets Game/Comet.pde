class Comet {
  float posY;
  float posX;
  float speed;
  float randDir;
  float size;
  PImage img3;

  Comet() {
    img3 = loadImage("comet.png");
    //source for image: https://dryicons.com/free-icons/comet
    RandPosition();
    size = (50);
    randDir = random(0, TWO_PI);
    speed = (round * 0.5) + 1;
    //speed = 0;
    //uncomment line for testing hitboxes of comets
  }

  public void Update() {
    posX += cos(randDir)*speed;
    posY += sin(randDir)*speed;
    //How I got the random direction code idea
    //https://gamedev.stackexchange.com/questions/117951/how-can-i-move-an-object-around-a-canvas-in-a-random-direction-at-random-times
    Edge();
  }

  public void Render() {
    push();
    translate(posX, posY);
    
    //I ended up figuring out how to make the comets show up instead of just circles
    
    //fill(#636373);
    //Color code source
    //https://www.crispedge.com/faq/what-is-the-color-of-comet/
    //stroke(0);
    //strokeWeight(2);
    //circle(0, 0, size);
    
    imageMode(CENTER);
    image(img3, 0, 0, size, size);
    pop();
  }

  public void Edge() {
    if (posX > width) posX = 0;
    if (posX < 0) posX = width;
    if (posY > height) posY = 0;
    if (posY < 0) posY = height;
  }

  private void RandPosition() {
    boolean top = false;
    boolean left = false;
    if (floor(random(0, 2)) == 0) top = true;
    if (floor(random(0, 2)) == 0) left = true;

    if (top && left) {
      posX = random(0, (width/2 - 100));
      posY = random(0, (height/2 - 100));
    } else if (top && !left) {
      posX = random((width/2 + 100), width);
      posY = random(0, (height/2 - 100));
    } else if (!top && left) {
      posX = random(0, (width/2 - 100));
      posY = random((height/2 + 100), height);
    } else {
      posX = random((width/2 + 100), width);
      posY = random((height/2 + 100), width);
    }
  }
}
