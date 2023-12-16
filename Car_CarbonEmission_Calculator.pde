import controlP5.*;

ControlP5 cp5;
PFont myFont;
PImage treeImage;

//Initializing Variables, to make adjustments to button sizes simpler
int buttonWidth = 200;
int buttonHeight = 100;
int nextButtonWidth = 100;
int nextButtonHeight = 30;

//Make boolean to clear screen after button, and sliders are selected
boolean button1Pressed = false;
boolean slidersVisible = false;
boolean nextButtonPressed = false;
boolean speedSliderClicked = false;
boolean passengerSliderClicked = false;
int passengers = 1;
int speed = 60; // Default speed value
float treeAbsorptionRate = 14; // kg of CO2 absorbed per year by a tree - (Source) https://www.treecouncil.ie/carbon-footprint


boolean Background = false; //Initializing the controlP5 background boolean


void setup() {
  size(800, 600);
  textAlign(CENTER, CENTER);
  
  //Importing font to make program easier to read for people with Dyslexia
  myFont = createFont("Comic Sans MS", 16);
  
  //Imports image from folder
  //Image taken from (had to shorten URL) https://tinyurl.com/mw6vwj2v
  treeImage = loadImage("Tree.png"); 
  textAlign(CENTER, CENTER);
  
  //Setting up ControlP5
  cp5 = new ControlP5(this);

  // Add a Toggle control, to adjust background for the colorblind
  cp5.addToggle("Background")
    .setPosition(width - 60, 20)
    .setSize(50, 20)
    .setColorLabel(0)
    .setMode(ControlP5.SWITCH)
    .setColorBackground(0)
    .setValue(false);
    
}

void draw() {
  background(200,250,200); // Default background
  
  if (Background) {
    background(255);  // White background
  } else {
    background(200, 255, 200);  // Default background
  }
  // Draw title box
  fill(100, 100, 255); // Blue color
  rect(10, 10, 180, 40); //Background box
  
  // Draw title text
  textFont(myFont); //Using Comic Sanse font
  fill(0, 255, 0); // Green color
  textSize(16); //Adjusting size
  text("Emissions Calculator", 100, 30);
  



  if (!button1Pressed) {
    // Draw Button in the center of screen
    fill(0,255,0); //Making box Green
    rect(width / 2 - buttonWidth / 2, height / 2 - buttonHeight / 2, buttonWidth, buttonHeight);
    fill(0); //Making text Black
    textSize(30);
    text("Start", width / 2, height / 2);
  }

  if (slidersVisible) {
    // Draw passenger slider in the center
    passengers = (int) passengerSlider(width / 4, height / 2 - 20, width / 2, 20, passengers, 1, 8, " ");

    // Display values
    fill(0);
    textSize(12);
    text("Passengers: " + passengers, width / 2, height / 2 - 40);

    // Draw speed slider in the center
    speed = (int) speedSlider(width / 4, height / 2 + 20, width / 2, 20, speed, 0, 120, " ");
    text("Speed: " + speed + " km/h", width / 2, height / 2 + 60);

    // Draw Next button on second page
    fill(255);
    rect(width / 2 - nextButtonWidth / 2, height / 2 + 80, nextButtonWidth, nextButtonHeight);
    fill(0);
    text("Next", width / 2, height / 2 + 95);
  }

  if (nextButtonPressed) {
    // Calling method to calculate carbon emissions for petrol and diesel based on speed
    float petrolEmission = calculatePetrolEmission(speed, passengers);
    float dieselEmission = calculateDieselEmission(speed, passengers);


    // Display the results
    fill(0);
    textSize(16);
    text("Calculated Carbon Emissions are stated (per person) per hour", width / 2, height / 2 - 80);
    text("Passenger Count: " + passengers, width / 2, height / 2);
    text("Speed: " + speed + " km/h", width / 2, height / 2 + 40);
    text("Petrol Emission: " + nf(petrolEmission, 0, 2) + " kg", width / 2, height / 2 + 80);
    text("Diesel Emission: " + nf(dieselEmission, 0, 2) + " kg", width / 2, height / 2 + 120);


    // Calculating equivalence by equation y=121.6x, an equation calculated from U.S. Environmental Agency
    float equivalenceCounter1 = 121.6 * dieselEmission;
    float equivalenceCounter2 = 121.6 * petrolEmission;
    text("Equivalence example:", width / 2, height / 2 + 180);
    text("Number of smartphones charged (diesel): " + int(equivalenceCounter1), width / 2, height / 2 + 240);
    text("Number of smartphones charged (petrol): " + int(equivalenceCounter2), width / 2, height / 2 + 260);
    
    float yearsToAbsorbD = dieselEmission / treeAbsorptionRate;
    text("Years for a evergreen tree to absorb diesel: " + nf(yearsToAbsorbD, 1, 2), width / 2, height / 2 + 200);
    float yearsToAbsorbP = petrolEmission / treeAbsorptionRate;
    text("Years for a evergreen tree to absorb petrol: " + nf(yearsToAbsorbP, 1, 2), width / 2, height / 2 + 220);
    
    image(treeImage, width - treeImage.width, height - treeImage.height);
    image(treeImage, 0, height - treeImage.height);
  }
}

void Background(boolean theFlag) {
  // Update the toggleState when the toggle is pressed
  Background = theFlag;
}

//Method following, is used to clear screen & record input after buttons are pressed
void mouseClicked() {  
  // Check if Button is pressed
  if (mouseX > width / 2 - buttonWidth / 2 && mouseX < width / 2 + buttonWidth / 2 &&
      mouseY > height / 2 - buttonHeight / 2 && mouseY < height / 2 + buttonHeight / 2) {
    clearScreen();
    button1Pressed = true;
    slidersVisible = true; // Set slidersVisible to true when Button 1 is pressed
  }

  // Check if passenger slider is clicked
  if (mouseX > width / 4 && mouseX < 3 * width / 4 && mouseY > height / 2 - 20 && mouseY < height / 2) {
    passengerSliderClicked = true;
  }

  // Check if speed slider is clicked
  if (mouseX > width / 4 && mouseX < 3 * width / 4 && mouseY > height / 2 + 20 && mouseY < height / 2 + 40) {
    speedSliderClicked = true;
  }

  // Check if Next button is pressed
  if (slidersVisible && mouseX > width / 2 - nextButtonWidth / 2 &&
      mouseX < width / 2 + nextButtonWidth / 2 && mouseY > height / 2 + 80 &&
      mouseY < height / 2 + 80 + nextButtonHeight) {
    clearScreen();
    nextButtonPressed = true;
  }
}

void clearScreen() {
  background(200);
  slidersVisible = false; // Reset slidersVisible
}

//Creating passenger slider - I created this using multiple libraries (including GitHub Co-pilot to help me gather the values from the slider) as we were not taught how to do this, without ControlP5, I have listed the most noteworthy below
//Source - https://stackoverflow.com/questions/72313759/making-a-discrete-slider-using-processing
float passengerSlider(float x, float y, float w, float h, float val, float minVal, float maxVal, String label) {
  fill(250);
  rect(x, y, w, h);

  if (passengerSliderClicked) {
    fill(100, 255, 100); // Highlight the slider when clicked
  } else {
    fill(255,0,0);
  }

  float sliderX = map(val, minVal, maxVal, x, x + w - 10);
  rect(sliderX, y, 10, h);
  fill(0);
  textSize(12);
  text(label, x + w / 2, y - 5);

  // Check if the mouse is inside the slider area and the slider is clicked
  if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h && passengerSliderClicked) {
    // Snap to the nearest integer value
    return constrain(round(map(mouseX, x, x + w, minVal, maxVal)), minVal, maxVal);
  }

  return val; // If not inside the slider area or slider is not clicked, return the current value
}

float speedSlider(float x, float y, float w, float h, float val, float minVal, float maxVal, String label) {
  fill(250);
  rect(x, y, w, h);

  if (speedSliderClicked) {
    fill(100, 255, 100); // Highlight the slider when clicked
  } else {
    fill(255,0,0);
  }

  float sliderX = map(val, minVal, maxVal, x, x + w - 10);
  rect(sliderX, y, 10, h);
  fill(0);
  textSize(12);
  text(label, x + w / 2, y - 5);

  // Check if the mouse is inside the slider area and the slider is clicked
  if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h && speedSliderClicked) {
    // Snap to the nearest multiple of 10
    return constrain(round(map(mouseX, x, x + w, minVal, maxVal) / 10) * 10, minVal, maxVal);
  }

  return val; // If not inside the slider area or slider is not clicked, return the current value
}


//Values the program uses to calculate the emissions per passenger, based on values I previously calculated (consumption per kmh multiplied by the speed travelling at)

//Fuel consumption calculated and gotten from - (Source) https://theconversation.com/climate-explained-does-your-driving-speed-make-any-difference-to-your-cars-emissions-140246 
//CO2 produced per liter gotten from - (Source) https://connectedfleet.michelin.com/blog/calculate-co2-emissions/#:~:text=One%20litre%20of%20diesel%20creates,has%20emitted%20in%20a%20month.
//chatGBT was used to problem solve the code below and to to display the values, as errors kept arising after 2 hours of problem fixing , however initial structure & method was created by myself.
float calculatePetrolEmission(int userSpeed, int userPassengers) {
  float[] emissionValues = {29.9, 21.85, 17.825, 15.64, 14.26, 13.8, 13.8, 14, 14.49, 15.41, 15.87, 16.33};
  int index = int(map(userSpeed, 10, 120, 0, emissionValues.length - 1));
  return emissionValues[index] / userPassengers;
}

float calculateDieselEmission(int userSpeed, int userPassengers) {
  float[] emissionValues = {35.1, 25.65, 20.925, 18.36, 16.74, 16.2, 16.2, 16.47, 17.01, 18.09, 18.63, 19.17};
  int index = int(map(userSpeed, 10, 120, 0, emissionValues.length - 1));
  return emissionValues[index] / userPassengers;
}
