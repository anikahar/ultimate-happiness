class GeneratedImage {
  color imagePixels[][];
  float fitness;
  
  GeneratedImage() {
    imagePixels = new color[myDisplayWidth][myDisplayHeight];
    for (int i = 0; i < myDisplayWidth; i++){
      for (int j = 0; j < myDisplayHeight; j++) {        
        imagePixels[i][j] = colorForIndex(i, j);                
      }
    }
  } 
  
  void fitness() {
    fitness = happinessScore;    
  }
  
  GeneratedImage crossover(GeneratedImage otherImage) {
    GeneratedImage result = new GeneratedImage();
    
    int midpoint = int(random(myDisplayHeight));    
    
    for (int i = 0; i < myDisplayWidth; i++){
      for (int j = 0; j < myDisplayHeight; j++) {
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
    for (int i = 0; i < myDisplayWidth; i++){
      for (int j = 0; j < myDisplayHeight; j++) {        
        if (noise(g_time / 1.0, float(i) / 100.0, float(j) / 100.0) < mutationRate) {
          println("mutation");
          imagePixels[i][j] = colorForIndex(i, j);
        }        
      }
    }
  }  
  
  color colorForIndex(int i, int j) {
    float r = noise(g_time / 1.0, float(i) / 100.0, float(j) / 100.0);
    float g = noise(g_time2 / 1.0, float(i) / 100.0, float(j) / 100.0);
    float b = noise(g_time3 / 1.0, float(i) / 100.0, float(j) / 100.0);
    color result = color(r, g, b);
    //println(result);
    return result;
    // return randomColor();
  }

  color randomColor() {
    return color(randomRGBValue(), randomRGBValue(), randomRGBValue());
  }
  
  int randomRGBValue() {
    return int(random(0, 255));
  }
}