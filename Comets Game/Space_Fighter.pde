Player player;
PImage img;
ArrayList<Comet> comets;
ArrayList<Laser> lasers;
ArrayList<Pixel> pixelList;
IntList cometRemove;
IntList laserRemove;
IntList pixRemove;
int gameState;
int score;
int round;
int roundCounter;
boolean notRoundOne;

PrintWriter output;

void setup() {
  size(800, 800);
  img = loadImage("space.jpg");
  //Background URL: https://www.deviantart.com/nettlejelly/art/FREE-Bright-Space-Background-Wallpaper-704872003
  frameRate(60);
  ExpressVariables();
  gameState = 0;
  output = createWriter("score.txt");
}

void ExpressVariables() {
  player = new Player();
  comets = new ArrayList<Comet>();
  for (int i = 0; i < 4; i++) {
  //for (int i = 0; i < 35; i++) {
    //uncomment to test amount of asteroids
    comets.add(new Comet());
  }
  lasers = new ArrayList<Laser>();
  pixelList = new ArrayList<Pixel>();
  cometRemove = new IntList();
  laserRemove = new IntList();
  pixRemove = new IntList();
  score = 0;
  round = 1;
  notRoundOne = false;
  roundCounter = 180;
}

void draw() {

  switch(gameState) {
  case 0:
    push();
    image(img, 0, 0);
    textSize(40);
    fill(255);
    textAlign(CENTER, CENTER);
    //textAlign idea from https://processing.org/tutorials/text
    text("Press Enter to Start The Game" + "\n" + "or" + "\n" + "Press Tab to See The Controls", width/2, height/2);
    pop();
    break;
  case 1:
    RoundUpdate();
    Update();
    Render();
    break;

  case 2:
    push();
    image(img, 0, 0);
    textSize(40);
    textAlign(CENTER, CENTER);
    fill(255);
    text("Game Over" + "\n" + "Press Shift to Play Again" + "\n" + "Or" + "\n" + "Press Enter to End The Game", width/2, height/2);
    pop();
    break;

  case 3:
    push();
    image(img, 0, 0);
    textSize(40);
    textAlign(CENTER, CENTER);
    fill(255);
    text("Left Key = Rotate Left" + "\n" + "Right Key = Rotate Right" + "\n" + "Spacebar = Fire" + "\n" + "Press Enter to Start" + "\n" + "Press p to go Back to Title", width/2, height/2);
    pop();
    break;
  }
}

void Update() {
  player.Update();
  for (int i=0; i< comets.size(); i++) {
    comets.get(i).Update();
    if (player.CheckCollision(comets.get(i))) {
      output.println("Round: " + round);
      output.println("Score: " + score);
      gameState = 2;
    }
  }
  for (int i=0; i< lasers.size(); i++) {
    lasers.get(i).Update();
  }
  for (int l=0; l< lasers.size(); l++) {
    for (int a=0; a< comets.size(); a++) {
      if (lasers.get(l).CheckCollision(comets.get(a))) {
        laserRemove.append(l);
        cometRemove.append(a);
        score += 100;
        for (int n=0; n < 15; n++) {
          pixelList.add(new Pixel(comets.get(a).posX, comets.get(a).posY));
        }
        break;
      }
    }
  }
  for (int i = 0; i < pixelList.size(); i++) {
    if (pixelList.get(i).Update()) {
      pixRemove.append(i);
    }
  }

  for (int i=0; i<laserRemove.size(); i++) {
    if (laserRemove.get(i) < lasers.size()) lasers.remove(laserRemove.get(i));
  }
  laserRemove.clear();
  for (int i=0; i<cometRemove.size(); i++) {
    if (cometRemove.get(i) < comets.size()) comets.remove(cometRemove.get(i));
  }
  cometRemove.clear();
  for (int i=0; i<pixRemove.size(); i++) {
    if (pixRemove.get(i) < pixelList.size()) pixelList.remove(pixRemove.get(i));
  }
  pixRemove.clear();
}

void Render() {
  image(img, 0, 0);
  if (roundCounter > 0) {
    push();
    textSize(40);
    text("Round " + round, width*.4, height*.4);
    pop();
  }
  push();
  textSize(40);
  text("Score: " + score, width*.05, height*.05);
  pop();
  player.Render();
  for (int i=0; i< comets.size(); i++) {
    comets.get(i).Render();
  }
  for (int i=0; i< lasers.size(); i++) {
    lasers.get(i).Render();
  }
  for (int i = 0; i < pixelList.size(); i++) {
    pixelList.get(i).Render();
  }
}

void RoundUpdate() {
  if (roundCounter > 0) roundCounter--;
  else {
    roundCounter = 0;
    notRoundOne = true;
  }
  if (roundCounter == 1 && notRoundOne) {
    for (int i=0; i< (4 + floor(round * 0.5)); i++) {
      //this causes the game to spawn 4 comets plus the round number divided by 2 and it always rounds up to the next number so round 7 = 3.5 = 4 additional comets
      comets.add(new Comet());
    }
  }
  if (roundCounter == 0 && comets.size() == 0) {
    roundCounter = 180;
    round++;
  }
}

void keyPressed() {
  switch(gameState) {
  case 0:
    if (keyCode == 10) gameState = 1;
    //Enter
    if (keyCode == 9) gameState = 3;
    //tab
    break;

  case 1:
    if (keyCode == 39) {
      player.isRotating = -1;
    } else if (keyCode == 37) {
      player.isRotating = 1;
    }
    if (keyCode == 32) {
      if (!player.shotFired) {
        lasers.add(player.Fire());
        player.shotFired = true;
      }
    }
    break;

  case 2:
    if (keyCode == 16) {
      ExpressVariables();
      gameState = 1;
    }
    //Shift
    if (keyCode == 10) {
      output.flush();
      output.close();
      exit();
      break;
    }
    //Enter
    break;
  case 3:
    if (keyCode == 10) gameState = 1;
    //enter
    if (keyCode == 80) gameState = 0;
    //p
    break;
  }
}

void keyReleased() {
  switch(gameState) {
  case 1:
    if (keyCode == 39) {
      player.isRotating = 0;
    } else if (keyCode == 37) {
      player.isRotating = 0;
    }
    if (keyCode == 32) {
      if (player.shotFired) player.shotFired = false;
    }
    break;
  }
}
