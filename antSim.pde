int NUM_OF_ANTS  = 1000;
int SPACE_WIDTH  =  200;
int SPACE_HEIGHT =  200;

ArrayList ants;
GridSpace space;

void setup() {
//    size(400,400);
    size(window.innerWidth * 0.9, window.innerHeight * 0.9);
    frameRate(20);
    background(0);

    space = new GridSpace(SPACE_WIDTH, SPACE_HEIGHT);
    space.setFood(SPACE_WIDTH / 2 + 50, SPACE_HEIGHT / 2 + 10);
    space.setNest(SPACE_WIDTH / 2 - 50, SPACE_HEIGHT / 2 - 10);
  
    ants = new ArrayList();
    while( ants.size() < NUM_OF_ANTS ) {
        ants.add(new Ant(space));
    }
}

void fadeToBlack() {
    noStroke();
    fill(0,98);
    rect(0,0,width,height);
}

void draw() {
    fadeToBlack();
    for( int i = 0 ; i < ants.size() ; i++ ) {
        Ant a = (Ant)ants.get(i);
        a.move();
    }
    space.update();
    space.draw();
}
