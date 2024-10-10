class Planet{
  Vector velocity;
  Vector position;
  double mass;
  double extent;
  double forceMagnitude;
  //maybe add volume instance vairable
 
   
  Planet(Vector velocity, Vector position, double mass, double extent){
      this.velocity = velocity;
      this.mass = mass;
      this.position = position;
      this.extent = extent;
  }
 
  public double getMass(){
    return mass;
  }
 
  void updatePosition(float timeStep){
    Vector acceleration = computeAcceleration();
   
    Vector newPosition = position.vAdd(velocity.scale(timeStep)).vAdd(acceleration.scale(0.5 * timeStep * timeStep));
    Vector newVelocity = newPosition.subtract(position).scale(1.0 / timeStep);
   
    position = newPosition;
    velocity = newVelocity;
  }

  Vector computeAcceleration(){
    Vector acceleration = new Vector(0, 0, 0);
   
    for(Planet otherPlanet : planets){
      if(otherPlanet != this){
        Vector distance = otherPlanet.position.subtract(position);
        double r = distance.length();
        double forceMagnitude = (6.67 * pow(10, -11) * mass * otherPlanet.mass) / (r * r);
       
        Vector forceDirection = distance.normalize();
        Vector accGrav = forceDirection.scale(forceMagnitude / mass);
        acceleration = acceleration.vAdd(accGrav);
      }
    }
    return acceleration;
  }
 
    //create a linked list to store all asteriods of specfic size,
    //possibly in a new class
   
    //to find the merged circle:
    //first particle: pi(radius)^2
    //second particle: pi(radius)^2
   
    //create new particle with combined masses of both particles
    //new particle: add them together to get area
    //basically a^2 + b^2 = c^2
 
   
    //calculate the new velocity vector:
    //add the two current velocitys together
    //do vector math
   
   
    //displaying particle:
    //get rid of the two particles that collided
    //create new particle in linked list with values calculated from before
    //draw that particle
 
  float getParticleRadius(){
    //we know volume of theia, 1.63×10^11 cubic km
    //we know radius of theia, 3389.5 km
    //to get voulme of each particle, volume/number of particles
    //to find radius, particle voulme = 4/3(pi)(r^3), and solve for r
   
   
    return 0.0;
  }
 
 
  Vector getVelocity(){
    return velocity;
  }
 
  void planetDraw(){
    fill(255, 255, 255);
    circle((float)position.getDX() / 1000000, (float)position.getDY() / 1000000, (float)extent / 50000); //scale extent to meters, not km
  }
}
