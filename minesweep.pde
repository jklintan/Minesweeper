ArrayList<Firework> fireworks;
PVector gravity = new PVector(0, 0.1);

void setup() {
  size(800, 500);
  fireworks = new ArrayList<Firework>();
  colorMode(HSB);
  background(30);
}

void draw() {
	textSize(30);
	text("Happy New Year", 16, 60);
	
  fireworks.add(new Firework()); //Add new fireworks
  fill(30, 29);
  noStroke();
  rect(0,0,width,height); //Color over the old tracks

  for (int i = fireworks.size()-1; i >= 0; i--) {
    Firework f = fireworks.get(i);
    f.run();
    if (f.done()) {
      fireworks.remove(i);
    }
  }

}

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  boolean subParticle = false;
  float partcolor;

	//Constructors
  Particle(float x, float y, float c) {
    partcolor = c;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, random(-10, -2));
    location =  new PVector(x, y);
    subParticle = true;
    lifespan = 180;
  }

  Particle(PVector l, float c) {
    partcolor = c;
    acceleration = new PVector(0, 0);
    velocity = PVector.random2D();
    velocity.mult(random(4, 8));
    location = l;
    lifespan = 180;
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void run() {
    update();
    display();
  }

  boolean explode() {
    if (subParticle && velocity.y > 0) {
      lifespan = 0;
      return true;
    }
    return false;
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    if (!subParticle) {
      lifespan -= 5.0;
      velocity.mult(0.9);
    }
    acceleration.mult(0);
  }

  void display() {
    stroke(partcolor, 255, 255, lifespan);
    if (subParticle) {
      strokeWeight(4);
    } else {
      strokeWeight(2);
    }
    ellipse(location.x, location.y, 1, 15);
		
  }

  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

class Firework {
  ArrayList<Particle> particles;    // An arraylist for all the particles
  Particle firework;
  float partcolor;
	
	//Constructor
  Firework() {
    partcolor = random(255);
    firework = new Particle(random(width), height, partcolor);
    particles = new ArrayList<Particle>();  
  }

  boolean done() {
    if (firework == null && particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }

  void run() {
    if (firework != null) {
      fill(partcolor,255,255);
      firework.applyForce(gravity);
      firework.update();
      firework.display();

      if (firework.explode()) {
        for (int i = 0; i < 100; i++) {
          particles.add(new Particle(firework.location, partcolor));    
        }
        firework = null;
      }
    }

    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.applyForce(gravity);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }

}
