import com.thomasdiewald.pixelflow.java.DwPixelFlow; //<>//
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;

import processing.core.*;
import processing.opengl.PGraphics2D;

DwFluid2D fluid;
PGraphics2D pg_fluid;

ArrayList<Boid> flock;
QuadTree quadtree;

float alignValue = .8;
float cohesionValue = .9;
float seperationValue = .9;

int flockSize = 500;

void setup() {
  fullScreen(P2D);
  colorMode(HSB, 360, 100, 100);
  DwPixelFlow context = new DwPixelFlow(this);
  fluid = new DwFluid2D(context, width, height, 1);

  fluid.param.dissipation_velocity = 0.99f;
  fluid.param.dissipation_density  = 0.8f;



  pg_fluid = (PGraphics2D) createGraphics(width, height, P2D);
  pg_fluid.smooth(4);

  flock = new ArrayList<Boid>();
  for (int i = 0; i < flockSize; i++) {
    flock.add(new Boid());
  }
}

void draw() {
  fluid.update();

  // clear render target
  pg_fluid.beginDraw();
  pg_fluid.background(0);
  pg_fluid.endDraw();

  // render fluid stuff
  fluid.renderFluidTextures(pg_fluid, 0);

  // display
  image(pg_fluid, 0, 0);
  //background(pg_fluid);


  stroke(0, 255, 0);
  rectMode(CENTER);

  Rectangle boundary = new Rectangle(width/2, height/2, width, height);
  fluid.addCallback_FluiData(new  DwFluid2D.FluidData() {
    public void update(DwFluid2D fluid) {
      //    PVector loc;
      //    for (Boid b : newBoidsCopy) {
      //      loc.sub(b.position);
      //    }
      //    float px     = loc.x;
      //    float py     = loc.y;
      //    float vx     = (loc.x - loc.x) * +15;
      //    float vy     = (loc.y - loc.y) * -15;
      //    fluid.addVelocity(px, py, 14, vx, vy);
      //    fluid.addDensity (px, py, 20, 0.0f, 0.4f, 1.0f, 1.0f);
      //    fluid.addDensity (px, py, 8, 1.0f, 1.0f, 1.0f, 1.0f);
      //  }
      //}
      //);

      if (mousePressed) {
        float px     = mouseX;
        float py     = height-mouseY;
        float vx     = (mouseX - pmouseX) * +15;
        float vy     = (mouseY - pmouseY) * -15;
        fluid.addVelocity(px, py, 14, vx, vy);
        fluid.addDensity (px, py, 20, 0.0f, 0.0f, 1.0f, 1.0f);
        fluid.addDensity (px, py, 8, 1.0f, 1.0f, 1.0f, 1.0f);
      }
    }
  }
  );
  quadtree = new QuadTree(boundary, 4);

  for (Boid b : flock) {
    quadtree.insert(b);
    b.edges();
    b.update();
    //b.flock(flock);
    b.show();
  }
  ArrayList<Boid> newBoidsCopy = new ArrayList<Boid>();
  for (Boid boid : flock) {
    Rectangle range = new Rectangle(boid.position.x, boid.position.y, 50, 50);
    ArrayList<Boid> newBoids = new ArrayList<Boid>();
    newBoids = quadtree.query(range, newBoids);
    //println(newBoids.size());
    boid.flock(newBoids);
    newBoidsCopy = newBoids;
  }
}



//quadtree.show();
//println(frameRate);



void keyPressed() {
  if (key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6') {
    for (Boid boid : flock) {
      boid.changeColor();
    }
  }

  if (key == 'q' || key == 'w' || key == 'e' || key == 'r' || key == 't' || key == 'y') {

    if (key == 'q') {
      changeFlockSize(200);
      for (Boid boid : flock) {
        boid.changeSpeed();
      }
    }
    if (key == 'w') {
      changeFlockSize(300);
      for (Boid boid : flock) {
        boid.changeSpeed();
      }
    }
    if (key == 'e') {
      changeFlockSize(400);
      for (Boid boid : flock) {
        boid.changeSpeed();
      }
    }
    if (key == 'r') {
      changeFlockSize(600);
      for (Boid boid : flock) {
        boid.changeSpeed();
      }
    }
    if (key == 't') {
      changeFlockSize(800);
      for (Boid boid : flock) {
        boid.changeSpeed();
      }
    }
    if (key == 'y') {
      changeFlockSize(1000);
      for (Boid boid : flock) {
        boid.changeSpeed();
      }
    }
  }


  //  if (key == '9') {
  //    int speed = 0;
  //    //println(num);
  //    if (flock.get(1).maxSpeed == 5) {
  //      speed = 12;
  //    }
  //    if (flock.get(1).maxSpeed == 12) {
  //      speed = 18;
  //    }
  //    if (flock.get(1).maxSpeed == 18) {
  //      speed = 8;
  //    }
  //    if (flock.get(1).maxSpeed == 8) {
  //      speed = 15;
  //    }
  //    if (flock.get(1).maxSpeed == 15) {
  //      speed = 10;
  //    }
  //    if (flock.get(1).maxSpeed == 10) {
  //      speed = 5;
  //    }
  //    println(speed);
  //    for (Boid boid : flock) {
  //      boid.changeSpeed();
  //    }
  //  }

  if (key == '7') {
    int lower = int(random(200, 300));
    int upper = int(random(300, 400));
    for (int i = lower; i < upper; i++) {
      flock.remove(i);
      flock.get(i).maxSpeed -= 1;
    }
  }

  if (key == '8') {
    int lower = int(random(200, 300));
    int upper = int(random(300, 400));
    for (int i = lower; i < upper; i++) {
      flock.add(new Boid());
      flock.get(i).maxSpeed += 1;
    }
  }

  if (key == '6') {
  }
}

void changeFlockSize(int x) {
  println(flock.size());
  int missingSize = x - flock.size();

  println(missingSize);

  if (missingSize > 0) {
    for (int i =0; i< missingSize; i++) {
      flock.add(new Boid());
    }
  }

  if (missingSize < 0) {
    println(abs(missingSize));
    for (int i =0; i< abs(missingSize); i++) {
      flock.remove(0);
    }
  }
}
