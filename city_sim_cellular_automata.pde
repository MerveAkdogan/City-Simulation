// Size of cells
int cellSize = 20;

// How likely for a cell to be konut at start (in percentage)
float probabilityOfKonutAtStart = 65;
float probabilityOfKamuAtStart = 20;

// Variables for timer
int interval = 100;
int lastRecordedTime = 0;

// Colors for active/inactive cells
color konut = color(255, 0, 0); 
color bos = color(0);
color kamu = color(0,200,0);
color konutx2 = color(139, 0, 0); //bordo

// Array of cells
int[][] cells; 
// Buffer to record the state of the cells and use this while changing the others in the interations
int[][] cellsBuffer; 

// Pause
boolean pause = false;

void setup() {
  size (640,360);

  // Instantiate arrays 
  cells = new int[width/cellSize][height/cellSize];
  cellsBuffer = new int[width/cellSize][height/cellSize];

  // This stroke will draw the background grid
  stroke(48);

  noSmooth();

  // Initialization of cells
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      float state = random (100);
      if (state > probabilityOfKonutAtStart) { 
        state = 1;
      }
      else if (probabilityOfKonutAtStart>= state && state>= probabilityOfKamuAtStart) { 
        state = 1;
      }
       else if (state< probabilityOfKamuAtStart) { 
        state = 2;
      }
      else {
        state = 0;
      }
      cells[x][y] = (int)(state); // Save state of each cell
    }
  }
  background(0); // Fill in black in case cells don't cover all the windows
}


void draw() {

  //Draw grid
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      if (cells[x][y]==1) {
        fill(konut); // If konut
      }
      else if (cells[x][y]==2) {
        fill(kamu); // If kamu
      }
      else if (cells[x][y]==3) {
       fill(konutx2);
      }
      else {
        fill(bos); // If bos
      }
      rect (x*cellSize, y*cellSize, cellSize, cellSize);
    }
  }
  // Iterate if timer ticks
  if (millis()-lastRecordedTime>interval) {
    if (!pause) {
      iteration();
      lastRecordedTime = millis();
    }
  }

  // Create  new cells manually on pause
  if ( mousePressed) {
    // Map and avoid out of bound errors
    int xCellOver = (int)(map(mouseX, 0, width, 0, width/cellSize));
    xCellOver = constrain(xCellOver, 0, width/cellSize-1);
    int yCellOver = (int)(map(mouseY, 0, height, 0, height/cellSize));
    yCellOver = constrain(yCellOver, 0, height/cellSize-1);

    // Check against cells in buffer
    if (cellsBuffer[xCellOver][yCellOver]==1) { // Cell is konut
      cells[xCellOver][yCellOver]=0; // bosalt
      fill(bos); // Fill with bos color
    }
    else if(cellsBuffer[xCellOver][yCellOver]==2) { // Cell is kamu
      cells[xCellOver][yCellOver]=2; // bosalt
      fill(kamu); // Fill with kamu color
    }
    else { // Cell is bos
      cells[xCellOver][yCellOver]=1; // Make konut
      fill(konut); // Fill konut color
    }
  } 
  else if (!mousePressed) { // And then save to buffer once mouse goes up
    // Save cells to buffer (so we opeate with one array keeping the other intact)
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cellsBuffer[x][y] = cells[x][y];
      }
    }
  }
}



void iteration() { // When the clock ticks
  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }

  // Visit each cell:
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      // And visit all the neighbours of each cell
      int neighbours = 0; // We'll count the neighbours
      int neighbours2 = 0; // We'll count the neighbours 2
      for (int xx=x-1; xx<=x+1;xx++) {
        for (int yy=y-1; yy<=y+1;yy++) {  
          if (((xx>=0)&&(xx<width/cellSize))&&((yy>=0)&&(yy<height/cellSize))) { // Make sure you are not out of bounds
            if (!((xx==x)&&(yy==y))) { // Make sure to to check against self
              if (cellsBuffer[xx][yy]==1){
                neighbours ++; // Check konut neighbours and count them
              }
              else if (cellsBuffer[xx][yy]==2){
                neighbours2 ++; // Check kamu neighbours and count them
              } 
            } // End of if
          } // End of if
        } // End of yy loop
      } //End of xx loop
      // We've checked the neigbours: apply rules!
      if (cellsBuffer[x][y]==1) { // The cell is konut
        if (neighbours < 1 && neighbours2 == 2  ){
            cells[x][y] = 1;  
          }
         else if (neighbours < 1 &&  neighbours2 == 3)
          {
            cells[x][y] = 2; 
          }
          else if (neighbours < 1 &&  neighbours2 == 0) {
            cells[x][y] = 0;
          }
          else if(neighbours <1 && neighbours2 ==1) {
            cells[x][y] = 1;
          }
          else if(neighbours2 ==4) {
            cells[x][y] = 1;
          }
          else if (neighbours == 1 && neighbours2== 1)  {
          cells[x][y] = 1;
        }
        else if (neighbours == 1 && neighbours2== 2)  {
          cells[x][y] = 1;
        }
        else if (neighbours == 1 && neighbours2== 3)  {
          cells[x][y] = 1;
        }
      else if (neighbours == 1 && neighbours2== 0)  {
          cells[x][y] = 1;
        }
      else if (neighbours == 2 && neighbours2<= 1) {
          cells[x][y] = 1;
        }
      else if (neighbours == 2 && neighbours2== 2){
          cells[x][y] = 1;
        }
      else if (neighbours ==3) {
        cells[x][y]= 3;
      }
      else if(neighbours ==4) {
        cells[x][y]= 0;
      }
      }
      
        
      if (cellsBuffer[x][y]==2) { 
        if (neighbours  <1  && neighbours2 <1 ) {
          cells[x][y] = 0;
        }
        else if (neighbours  ==1 && neighbours2 <= 1) {
          cells[x][y] = 2;
        }
        else if (neighbours  ==1 && neighbours2 > 1) {
          cells[x][y] = 2;
        }
        else if (neighbours  ==2 && neighbours2 <= 1) {
          cells[x][y] = 2;
        }
        else if (neighbours  ==2 && neighbours2 > 1) {
          cells[x][y] = 2;
        }
        else if (neighbours  ==3 && neighbours2 < 1) {
          cells[x][y] = 2;
        }
        else if (neighbours  ==3 && neighbours2 == 1) {
          cells[x][y] = 2;
        }
      } // End of if
    } // End of y loop
  } // End of x loop
} // End of function

void keyPressed() {
  if (key=='r' || key == 'R') {
    // Restart: reinitialization of cells
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        float state = random (100);
        if (state > probabilityOfKonutAtStart) {
          state = 1;
        }
        else if (state < probabilityOfKamuAtStart) {
          state = 2;
        }
        else {
          state = 0;
        }
        cells[x][y] = (int)(state); // Save state of each cell
      }
    }
  }
  if (key=='m') { // On/off of pause
    pause = !pause;
  }
  if (key=='c' || key == 'C') { // Clear all
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cells[x][y] = 0; // Save all to zero
      }
    }
  }
}
