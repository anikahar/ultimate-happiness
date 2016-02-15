class GeneratedImage {
  color imagePixels[][];
  float fitness;
  
  GeneratedImage() {
    imagePixels = new color[size][size];
    for (int i = 0; i < size; i++){
      for (int j = 0; j < size; j++) {        
        imagePixels[i][j] = randomColor();                
      }
    }
  }
  
  void fitness() {
    fitness = happinessScore;    
  }
  
  GeneratedImage crossover(GeneratedImage otherImage) {
    GeneratedImage result = new GeneratedImage();
    
    int midpoint = int(random(size));    
    
    for (int i = 0; i < size; i++){
      for (int j = 0; j < size; j++) {
        if (j > midpoint) {          
           result.imagePixels[i][j] = otherImage.imagePixels[i][j];
        } else {
           result.imagePixels[i][j] = imagePixels[i][j]; 
        }        
      }
    }
    
    return result;
  }
  
  void mutate(float mutationRate) {
    for (int i = 0; i < size; i++){
      for (int j = 0; j < size; j++) {
        if (random(1) < mutationRate) {
          imagePixels[i][j] = randomColor();
        }        
      }
    }
  }  
  
  color randomColor() {
    return color(randomRGBValue(), randomRGBValue(), randomRGBValue());
  }
  
  int randomRGBValue() {
    return int(random(0, 255));
  }
}