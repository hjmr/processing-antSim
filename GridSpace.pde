float DEFAULT_NEST_PHEROMONE = 20.0;

int FOOD_SIZE = 2;
int NEST_SIZE = 2;

class GridSpace {
    int x_size, y_size;
    int food_x, food_y;
    int nest_x, nest_y;

    Ant[][] antSpace;
    float[][] foodPheromone;
    float[][] nestPheromone;

    GridSpace(int w, int h) {
        x_size = w;
        y_size = h;
        antSpace = new Ant[x_size][y_size];
        for( int x = 0 ; x < x_size ; x++ ) {
            for( int y = 0 ; y < y_size ; y++ ) {
                antSpace[x][y] = null;
            }
        }

        foodPheromone = new float[x_size][y_size];
        for( int x = 0 ; x < x_size ; x++ ) {
            for( int y = 0 ; y < y_size ; y++ ) {
                foodPheromone[x][y] = 0;
            }
        }

        nestPheromone = new float[x_size][y_size];
        for( int x = 0 ; x < x_size ; x++ ) {
            for( int y = 0 ; y < y_size ; y++ ) {
                nestPheromone[x][y] = 0;
            }
        }
        
        food_x = food_y = -1;
        nest_x = nest_y = -1;
    }

    void setFood(int x, int y) {
        food_x = x;
        food_y = y;
    }

    boolean isFoodAt(int x, int y) {
        boolean yn = false;
        float dist = sqrt((food_x - x) * (food_x - x) + (food_y - y) * (food_y - y));
        if( dist <= FOOD_SIZE ) {
            yn = true;
        }
        return yn;
    }
    
    void setNest(int x, int y) {
        nest_x = x;
        nest_y = y;
    }

    boolean isNestAt(int x, int y) {
        boolean yn = false;
        float dist = sqrt((nest_x - x) * (nest_x - x) + (nest_y - y) * (nest_y - y));
        if( dist <= NEST_SIZE ) {
            yn = true;
        }
        return yn;
    }

    int getWidth() {
        return x_size;
    }

    int getHeight() {
        return y_size;
    }

    void removeAnt(int x, int y) {
        antSpace[x][y] = null;
    }

    void setAnt(Ant a, int x, int y) {
        antSpace[x][y] = a;
    }

    Ant getAnt(int x, int y) {
        return antSpace[x][y];
    }

    void setFoodPheromone(int x, int y, float v) {
        foodPheromone[x][y] = v;
    }

    double getFoodPheromone(int x, int y) {
        return foodPheromone[x][y];
    }

    void setNestPheromone(int x, int y, float v) {
        nestPheromone[x][y] = v;
    }

    double getNestPheromone(int x, int y) {
        return nestPheromone[x][y];
    }

    void update() {
        int[][] d = {{-1,-1},{ 0,-1},{ 1,-1},
                     {-1, 0},        { 1, 0},
                     {-1, 1},{ 0, 1},{ 1, 1}};

        float[][] foodTmp = new float[x_size][y_size];
        float[][] nestTmp = new float[x_size][y_size];

        nestPheromone[nest_x][nest_y] = DEFAULT_NEST_PHEROMONE;

        for( int x = 0 ; x < x_size ; x++ ) {
            for( int y = 0 ; y < y_size ; y++ ) {
                foodTmp[x][y] = foodPheromone[x][y];
                nestTmp[x][y] = nestPheromone[x][y];
                for( int i = 0 ; i < 8 ; i++ ) {
                    int nx = x + d[i][0];
                    int ny = y + d[i][1];
                    if( 0 <= nx && nx < x_size && 0 <= ny && ny < y_size ) {
                        foodTmp[x][y] += foodPheromone[nx][ny];
                        nestTmp[x][y] += nestPheromone[nx][ny];
                    }
                }
                foodTmp[x][y] = 0.970 * (foodTmp[x][y] / 9.0);
                nestTmp[x][y] = 0.999 * (nestTmp[x][y] / 9.0);
            }
        }

        for( int x = 0 ; x < x_size ; x++ ) {
            for( int y = 0 ; y < y_size ; y++ ) {
                foodPheromone[x][y] = foodTmp[x][y];
                nestPheromone[x][y] = nestTmp[x][y];
            }
        }
    }

    void draw() {
        noStroke();

        float ux = (float)width  / x_size;
        float uy = (float)height / y_size;

        rectMode(RADIUS);
        ellipseMode(RADIUS);

        color colorBlack = color(  0,  0,  0);
        color fpColor    = color(200,  0,  0);
        color npColor    = color(  0,  0,200);
        for( int x = 0 ; x < x_size ; x++ ) {
            for( int y = 0 ; y < y_size ; y++ ) {
                color c = lerpColor(colorBlack, fpColor, min(1.0,foodPheromone[x][y]))
                        + lerpColor(colorBlack, npColor, min(1.0,nestPheromone[x][y]));
                fill(c);
                rect(ux * x, uy * y, max(1,ux / 2.0), max(1,uy / 2.0));
            }
        }

        if( 0 <= food_x && 0 <= food_y ) { 
            fill(255, 255, 0);
            rect(ux * food_x, uy * food_y,
                 max(1,ux * FOOD_SIZE / 2.0), max(1,uy * FOOD_SIZE / 2.0));
        }

        if( 0 <= nest_x && 0 <= nest_y ) { 
            fill(0, 255, 0);
            rect(ux * nest_x, uy * nest_y,
                 max(1,ux * NEST_SIZE / 2.0), max(1,uy * NEST_SIZE / 2.0));
        }

        for( int x = 0 ; x < x_size ; x++ ) {
            for( int y = 0 ; y < y_size ; y++ ) {
                if( antSpace[x][y] != null ) {
                    if( antSpace[x][y].bringFood ) {
                        fill(255);
                    } else {
                        fill(160);
                    }
                    ellipse(ux * x, uy * y, max(1,ux / 2.0), max(1,uy / 2.0));
                }
            }
        }
    }
}
