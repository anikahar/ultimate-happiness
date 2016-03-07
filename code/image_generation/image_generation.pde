import processing.video.*;

// Size is both the size of the screen and the size of the generated image's pixel population
final int myDisplayWidth = 2880;
final int myDisplayHeight = 1800;

final int initialParentCount = 100;

float mutationRate;
int totalPopulation;

ArrayList<GeneratedImage> population;
GeneratedImage currentImage;
float happinessScore;
float previousHappiness;
float g_time, g_time2, g_time3;
  

Capture camera;

void setup() {  
  size(1024, 768);  
  colorMode(RGB, 1);
  mutationRate = 0.1;
 
  population = new ArrayList<GeneratedImage>();

  g_time = 0.0;
  g_time2 = 0.0;
  g_time3 = 0.0;
  
  increaseGlobalTimeFactors();
  currentImage = new GeneratedImage();
       
  // load some random parents  
  loadRandomParents();
  
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    camera = new Capture(this, cameras[0]);
    camera.start();     
  } 
}

void loadRandomParents() {
  for (int i = 0; i < initialParentCount; i++) {
    increaseGlobalTimeFactors();
    GeneratedImage initialParent = new GeneratedImage();
    initialParent.fitness = random(0, 0.5);
    population.add(initialParent);  
  }
}

int linearize(int x, int y) {
  x = constrain(x, 0, width - 1);
  y = constrain(y, 0, height - 1);
 
  return x + y * width;
}
 
void increaseGlobalTimeFactors() {
  g_time += 0.1;
  g_time2 += 0.2;
  g_time3 += 0.3;
}

void draw() {
  if (happinessScore == previousHappiness) {    
     return;
  } else {
     previousHappiness = happinessScore;
  }
         
  increaseGlobalTimeFactors();
  
  println("passed"); 
  
  currentImage.fitness();
  population.add(currentImage);
  
  loadPixels();

  for (int i = 0; i < myDisplayWidth; i++) {
    for (int j = 0; j < myDisplayHeight; j++) {
      //float r = noise(g_time / 1.0, float(i) / 100.0, float(j) / 100.0);
      //float g = noise(g_time2 / 1.0, float(i) / 100.0, float(j) / 100.0);
      //float b = noise(g_time3 / 1.0, float(i) / 100.0, float(j) / 100.0);
      //pixels[linearize(i, j)] = color(r, g, b);

      pixels[linearize(i, j)] = currentImage.imagePixels[i][j];
    }
  }
  
  updatePixels();
  
  ArrayList<GeneratedImage> matingPool = new ArrayList<GeneratedImage>();
    
  // normalizeFitnessValues();

  for (int i = 0; i < population.size(); i++) {

   int n = int(population.get(i).fitness * 100);
   for (int j = 0; j < n; j++) {
     matingPool.add(population.get(i));
   }
  }

  GeneratedImage parentA = randomParent(matingPool, null);
  GeneratedImage parentB = randomParent(matingPool, parentA);
  //GeneratedImage parentA = randomParent();
  //GeneratedImage parentB = randomParent();
  GeneratedImage child = parentA.crossover(parentB);
  child.mutate(mutationRate);
  currentImage = child;
}

void normalizeFitnessValues() { //<>// //<>//
  float sumFitness = 0.0;
  for (int i = 0; i < population.size(); i++) {
    sumFitness += population.get(i).fitness;
  } //<>//
   //<>//
  for (int i = 0; i < population.size(); i++) { //<>//
    population.get(i).fitness = population.get(i).fitness / sumFitness; //<>// //<>//
  } //<>//
}

void keyTyped() {    
  println("key typed");
  if (key >= '0' && key <= '9') {
    int keyIndex = key - '0';
    println(keyIndex);    
    happinessScore = (float) keyIndex / 10;
    println(happinessScore);
  } else if (key == ' ') {
    EmoVuAPI api = new EmoVuAPI();
    EmoVuAPIResult result = api.processImage(camera);
    if (result.tracked) {
      happinessScore = result.joy;
    }    
  }
}

void captureEvent(Capture c) {
  c.read();
}

// TODO: replace with mating pool
GeneratedImage randomParent() {
  return population.get(int(random(0, population.size() - 1)));
}

GeneratedImage randomParent(ArrayList<GeneratedImage> matingPool, GeneratedImage otherParent) {  
  GeneratedImage parent = matingPool.get(int(random(matingPool.size())));
  if (otherParent != null) {
    while (parent == otherParent) {
      println("parent equal to other parent trying another one");
      parent = matingPool.get(int(random(matingPool.size())));
    }
  }
  
  return parent; 
}