float DEFAULT_FOOD_PHEROMONE = 1.0;

class Ant {
    GridSpace space;
    int x, y, v;
    int[] vx = {-1,  0,  1,  1,  1,  0, -1, -1};
    int[] vy = {-1, -1, -1,  0,  1,  1,  1,  0};
    boolean bringFood;

    Ant(GridSpace s) {
        space = s;
        x = (int)random(0,space.getWidth());
        y = (int)random(0,space.getHeight());
        v = (int)random(0,vx.length);
        space.setAnt(this, x, y);
        bringFood = false;
    }

    int torusValue(int val, int range) {
        if( val     <  0 ) val += range;
        if( range <= val ) val -= range;
        return val;
    }
    
    int limitValue(int val, int range) {
        if( val     <  0 ) val = 0;
        if( range <= val ) val = range-1;
        return val;
    }

    void move() {
        int mx = 0;
        int my = 0;
        float maxPheromone = 0.0;

        for( int dv = -1 ; dv <= 1 ; dv++ ) {
            int tv = torusValue(v + dv, vx.length);
            int tx = limitValue(x + vx[tv], space.getWidth());
            int ty = limitValue(y + vy[tv], space.getHeight());

            float p = 0.0;
            if( bringFood == true ) {
                p = space.getNestPheromone(tx, ty);
            } else {
                p = space.getFoodPheromone(tx, ty);
            }

            if( maxPheromone < p ) {
                maxPheromone = p;
                mx = tx;
                my = ty;
            }
        }

        if( maxPheromone < 0.01 ) {
            v  = torusValue(v + int(random(-1,2)), vx.length);
            mx = limitValue(x + vx[v], space.getWidth());
            my = limitValue(y + vy[v], space.getHeight());
        }

//        if( space.getAnt(mx, my) == null ) {
            space.removeAnt(x, y);
            x = mx;
            y = my;
            space.setAnt(this, x, y);
//        }

        if( space.isFoodAt(x, y) == true ) {
            bringFood = true;
        }

        if( space.isNestAt(x, y) == true ) {
            bringFood = false;
        }

        if( bringFood == true ) {
            space.setFoodPheromone(x, y, DEFAULT_FOOD_PHEROMONE);
        }
    }
}

