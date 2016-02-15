
// Size is both the size of the screen and the size of the generated image's pixel population
final int size = 200;



float mutationRate;
int totalPopulation;

ArrayList<GeneratedImage> population;
GeneratedImage currentImage;
float happinessScore;

void setup() {  
  size(200, 200);  

  mutationRate = 0.01;

  currentImage = new GeneratedImage();

  population = new ArrayList<GeneratedImage>();
  
  // load some random parents
  population.add(new GeneratedImage());
  population.add(new GeneratedImage());
}

void draw() { 
  // TODO: replace with actual happiness score
  happinessScore = mouseX;
  currentImage.fitness();
  population.add(currentImage);

  loadPixels();

  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      int location = i + (j * size);
      pixels[location] = currentImage.imagePixels[i][j];
    }
  }
  
  updatePixels();

  // copyTODO: survival of the fittest
  //ArrayList<GeneratedImage> matingPool = new ArrayList<GeneratedImage>();

  //for (int i = 0; i < population.size(); i++) {

  //  int n = int(population.get(i).fitness * 100);
  //  for (int j = 0; j < n; j++) {
  //    matingPool.add(population.get(i));
  //  }
  //}

  GeneratedImage parentA = randomParent();
  GeneratedImage parentB = randomParent();
  GeneratedImage child = parentA.crossover(parentB);
  child.mutate(mutationRate);
  currentImage = child;
}

// TODO: replace with mating pool
GeneratedImage randomParent() {
  return population.get(int(random(0, population.size() - 1)));
}