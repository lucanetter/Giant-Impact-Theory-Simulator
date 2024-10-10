ArrayList<Planet> planets;

float deltaTime = 200;
float clock = 0;
float theiaMass = 6.39 * (float)Math.pow(10, 23); //mars mass
float theiaRadius = 3390000; //original radius (mars)
float debris = 100;

int hits;
int escaped;

void setup(){
  size(800, 800);
  planets = new ArrayList<Planet>();
 
  Planet earth = new Planet(new Vector(0, 0, 0), new Vector(0, 1, 0), 5.97 * Math.pow(10, 24), 6390000); //scale to meters, not km
  //Planet moon = new Planet(new Vector(0, 1023, 0), new Vector(200000000, 0, 0), 7.34 * Math.pow(10, 22), 1737000); //scale to meters, not km
 
  float volumeTheia = (4/3) * (float)(PI) * (float)(Math.pow(theiaRadius, 3));
  float particleMass = theiaMass / debris;
  float particleVolume = volumeTheia / debris;
  float particleRadius = (float)Math.pow((3 * particleVolume) / (4 * Math.PI), 1.0f/3.0f);
 
  System.out.println(volumeTheia);
  System.out.println(particleMass);
  System.out.println(particleRadius);
  planets.add(earth);
 
  for(int i = 0; i < debris; i++){
     Planet newParticle = new Planet(new Vector(0, 1000, 0), new Vector(random(-350000000, -150000000), random(-100000000, 100000000) , 0), particleMass, particleRadius);
     planets.add(newParticle);
  }
 
  //process to determine planets:
  //theia is thought to be the size of mars, earth staying the same
  //most of debris are from theia, but for simplicity we can assume all debris are from theia
  //not all debris stayed in orbit, we can assume half left since radius of mars is 2x the moons radius
  //mars is about 8.67x times heavier than the moon, but about  7.35 × 10^22 kg of theias mass would have to stay
 
  //mass of mars: 6.39 × 10^23 kg
  //radius of mars: 3389.5 km
 
  //mass of moon: 7.35 × 10^22 kg
  //radius of moon: 1737.4 km
 
  //mass of earth: 5.97 × 10^24 kg
  //radius of earth: 6378.1 km
 
  //equations: (not sure)
  //3.34 g/cm^3 is approximate density of moon
  //spawn the paricles near the earth, and give upwards velocity to get out of orbit
  //find volume of theia: volume = 4/3(pi)(r^3)
  //each particle is 1/(particles) the mass of theia
  //volume of each particle = voulume of theia * 1/amount of particles
  //to find radius, 1/amount of particles = 4/3(pi)(r^3) (solve for r, radius)
  //create 10 particles of equal radius and mass
 
  //planets.add(moon);
  //planets.add(moon2);
}


void mergeDust(ArrayList<Planet> planets){
    int size = planets.size();
   
    for(int i = 0; i < size; i++){
      Planet p1 = planets.get(i);
      float volumeP1 = (4/3) * (float)(PI) * (float)(Math.pow(p1.extent, 3));
      for(int j = i + 1; j < size; j++){
        Planet p2 = planets.get(j);
        float volumeP2 = (4/3) * (float)(PI) * (float)(Math.pow(p2.extent, 3));
 
          Vector difference = p1.position.subtract(p2.position);
          double distance = difference.length();
         
          if(distance < 100000){
            //System.out.println("100,000 less");
          }
         
          if(distance < p1.extent + p2.extent){
            //System.out.println("hits");
            hits++;
            //System.out.println(hits);
            
            double combinedMass = (p1.getMass() + p2.getMass());
            float volumeP3 = volumeP1 + volumeP2;
            double newRadius = Math.pow((3 * volumeP3) / (4 * Math.PI), 1.0f / 3.0f);
            Vector newVelocity = (p1.getVelocity().scale(p1.getMass()).vAdd(p2.getVelocity().scale(p2.getMass()))).scale(1/combinedMass);   // base this off momentum instead, m3v3 = m1v1 + m2v2
 
            planets.remove(p1);
            planets.remove(p2);                
 
            Planet mergedParticle = new Planet(newVelocity, p1.position, combinedMass, newRadius);
            planets.add(mergedParticle);
            size--;

         }
       }
    }
    
    for(int i = 0; i < planets.size(); i++){
      if(planets.get(i).position.dx > 400000000 || planets.get(i).position.dx < -400000000 || planets.get(i).position.dy > 400000000 || planets.get(i).position.dy < -400000000 ){
        planets.remove(planets.get(i));
        escaped++;
    }
  }
}
 
void draw(){
  background(0);
  translate(400,400);
  ellipseMode(CENTER);
  
  clock = clock + deltaTime;
  double earthMass = 0;
   
  for(Planet planet : planets){
    planet.updatePosition(deltaTime);
    planet.planetDraw();
  }
   
  for(int i = 0; i < planets.size(); i++){
    planets.get(i).updatePosition(deltaTime);
    planets.get(i).planetDraw();
  }
   
  mergeDust(planets);
  
  for(int i = 0; i < planets.size(); i++){
    if(planets.get(i).mass > earthMass){
      earthMass = planets.get(i).mass;
    }
  }
   
  textSize(25);
  text("Particles: (In Simulation) " + (planets.size() - 1), -380, -345);
  text("Particles: (Escaped) " + escaped, -380, -320);
  text("Merges: " + hits, -380, -370);
  //text("Earth Mass: " + earthMass, -380, -320);
  
  if(clock == 60000){ //5 seconds of running
    System.out.println(escaped + " " + (planets.size() - 1) + " " + hits);
  }
  
  if(clock == 120000){ //10 seconds of running
    System.out.println(escaped + " " + (planets.size() - 1) + " " + hits);
  }
  
  if(clock == 180000){ //15 seconds of running
    System.out.println(escaped + " " + (planets.size() - 1) + " " + hits);
  }
  
  if(clock > 240000){ //20 seconds of running
    System.out.println(escaped + " " + (planets.size() - 1) + " " + hits);
    stop();
  }
  
}
