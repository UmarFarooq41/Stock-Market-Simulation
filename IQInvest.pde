// iQINVEST - Stock Market Simulator
// This is the main file. It sets up the market, runs the simulation,
// and draws the stock price graph with a hover tooltip.
// Change DISPLAYED_STOCK to pick which company shows up (GUI will handle this later).
// Project Leads: Vaani Patel, Umar Farooq, Abdelrahman Mohamed

// change this number to switch which stock is displayed (0=APXL 1=NVOX 2=ZREN 3=ORCA)
int DISPLAYED_STOCK = 0;

Market market;
int day = 0;

//////// Vaani main tab, integrate with previous main program: ///////////

// Need G4P library
import g4p_controls.*;

userStockPortfolio myPortfolio;

Stock appleStock;
Stock costcoStock;
Stock nvidiaStock;
Stock walmartStock;

// user hasn't selected any company yet
boolean appleSelected = false;
boolean costcoSelected = false;
boolean nvidiaSelected = false;
boolean walmartSelected = false;

int sharesToBuy = 0; // initially user hasn't inputed their first initial investment value or sale value
int sharesToSell = 0;

//// for debugging
//boolean buyClicked = false;
//boolean sellClicked = false;

void setup(){
  size(1500, 900);
  createGUI();
  //customGUI();
 
  //name will update as user enters it through gui
  myPortfolio = new userStockPortfolio("");

  appleStock = new Stock("AAPL", "Apple", 180.0, new ArrayList<Float>());
  costcoStock = new Stock("COST", "Costco", 570.0, new ArrayList<Float>());
  nvidiaStock = new Stock("NVDA", "Nvidia", 800.0, new ArrayList<Float>());
  walmartStock = new Stock("WMT", "Walmart", 60.0, new ArrayList<Float>());
 
  // making sure that only window 1 starts and not everyother one
  window2.setVisible(false);
  window3.setVisible(false);
 
}

void draw(){
  background(230);
 
  myPortfolio.myHoldings.clear();
 
  if (appleSelected) { myPortfolio.addStock(appleStock); }
  if (costcoSelected) { myPortfolio.addStock(costcoStock); }
  if (nvidiaSelected) { myPortfolio.addStock(nvidiaStock); }
  if (walmartSelected) { myPortfolio.addStock(walmartStock); }
 
  stroke(150);
  line(700,0,700,1000); // dividing the user portfolio from the stock graph
 
  //title for portfolio
  textSize(15);
  fill(0);
 
  if (myPortfolio.userName.equals("")){
   
    text("ENTER YOUR NAME TO GET STARTED!", 720,40);
  }
 
  else{
    text(myPortfolio.userName + "'s STOCK PORTFOLIO", 720,40);
}
 
  myPortfolio.showPortfolio(720,80);
 
  stroke(150);
  line(700,220,1000,220);
 
  myPortfolio.showEachStock(720,260);
 
}

///////////////////////////////////////////////////////////////////////



// these define where the graph sits on the screen
int gX = 70;  // left edge
int gY = 80;  // top edge
int gW = 860; // width
int gH = 420; // height

// colour palette
color COL_BG = color(13, 27, 42);
color COL_LINE = color(0, 200, 140);
color COL_FILL = color(0, 200, 140, 40);
color COL_GRID = color(255, 255, 255, 18);
color COL_TEXT = color(220, 230, 255);
color COL_SUBTEXT = color(100, 130, 160);
color COL_TOOLTIP = color(18, 35, 55);
color COL_CROSS = color(255, 255, 255, 80);


void setup() {
  size(1000, 600);
  frameRate(2); // 2 frames per second so you can actually watch the graph grow

  market = new Market(1, 0);
  market.addStock(new Stock("APXL", "Apex Technologies", 142.50, new float[]{ 128, 131, 135, 133, 138, 140, 142 }));
  market.addStock(new Stock("NVOX", "NovaMed Biotech", 88.00, new float[]{ 78, 80, 83, 81, 85, 87, 88 }));
  market.addStock(new Stock("ZREN", "ZenRenew Energy", 55.25, new float[]{ 48, 50, 51, 53, 52, 54, 55 }));
  market.addStock(new Stock("ORCA", "OrcaBank Financial", 210.00, new float[]{ 193, 197, 202, 199, 205, 208, 210 }));

  market.setActiveStock(DISPLAYED_STOCK);
}


void draw() {
  market.tick(); // simulate one day
  day++;

  background(COL_BG);
  drawHeader();
  drawGraph();
  drawHoverTooltip();
}


// draws the ticker, company name, price and change at the top
void drawHeader() {
  Stock s = market.getActiveStock();

  fill(COL_LINE);
  textAlign(LEFT, TOP);
  textSize(22);
  text(s.ticker, 70, 18);

  fill(COL_TEXT);
  textSize(13);
  text(s.companyName, 120, 22);

  fill(COL_TEXT);
  textSize(20);
  textAlign(RIGHT, TOP);
  text("$" + nf(s.currentPrice, 1, 2), width - 70, 14);

  float chg = s.getPriceChange();
  float chgPct = s.getPriceChangePercent();
  fill(chg >= 0 ? color(0, 200, 140) : color(220, 70, 70));
  textSize(12);
  text((chg >= 0 ? "▲ +" : "▼ ") + nf(chg, 1, 2) +
    "  (" + (chg >= 0 ? "+" : "") + nf(chgPct, 1, 2) + "%)" +
    "   Day " + day,
    width - 70, 40);
}


// draws the grid, price line, and the filled area underneath it
void drawGraph() {
  Stock s = market.getActiveStock();
  ArrayList<Float> hist = s.getPriceHistory();
  int n = hist.size();
  if (n < 2) return;

  // figure out the min and max price so we can scale everything to fit
  float minP = hist.get(0);
  float maxP = hist.get(0);
  for (float p : hist) {
    minP = min(minP, p);
    maxP = max(maxP, p);
  }
  // add a little padding so the line doesn't touch the very top or bottom
  float pad = (maxP - minP) * 0.12;
  minP -= pad;
  maxP += pad;

  // horizontal grid lines and Y axis price labels
  stroke(COL_GRID);
  strokeWeight(1);
  int gridLines = 5;
  for (int i = 0; i <= gridLines; i++) {
    float t = (float) i / gridLines;
    float py = gY + gH - t * gH;
    float pv = minP + t * (maxP - minP);
    line(gX, py, gX + gW, py);
    fill(COL_SUBTEXT);
    noStroke();
    textAlign(RIGHT, CENTER);
    textSize(11);
    text("$" + nf(pv, 1, 2), gX - 8, py);
  }

  // X axis day labels - only show every few days so they don't pile up
  int labelEvery = max(1, n / 10);
  for (int i = 0; i < n; i += labelEvery) {
    float px = gX + map(i, 0, n - 1, 0, gW);
    fill(COL_SUBTEXT);
    noStroke();
    textAlign(CENTER, TOP);
    textSize(10);
    text("Day " + (i + 1), px, gY + gH + 6);
  }

  // shaded area under the price line
  noStroke();
  fill(COL_FILL);
  beginShape();
  vertex(gX, gY + gH);
  for (int i = 0; i < n; i++) {
    float px = gX + map(i, 0, n - 1, 0, gW);
    float py = gY + map(hist.get(i), minP, maxP, gH, 0);
    vertex(px, py);
  }
  vertex(gX + gW, gY + gH);
  endShape(CLOSE);

  // the actual price line
  stroke(COL_LINE);
  strokeWeight(2.2);
  noFill();
  beginShape();
  for (int i = 0; i < n; i++) {
    float px = gX + map(i, 0, n - 1, 0, gW);
    float py = gY + map(hist.get(i), minP, maxP, gH, 0);
    vertex(px, py);
  }
  endShape();

  // dot at the most recent price point
  float lastPx = gX + gW;
  float lastPy = gY + map(hist.get(n - 1), minP, maxP, gH, 0);
  noStroke();
  fill(COL_LINE);
  circle(lastPx, lastPy, 8);

  strokeWeight(1);
}


// shows a vertical line and info box when the mouse is hovering over the graph
void drawHoverTooltip() {
  // don't do anything if the mouse isn't inside the graph area
  if (mouseX < gX || mouseX > gX + gW || mouseY < gY || mouseY > gY + gH) return;

  Stock s = market.getActiveStock();
  ArrayList<Float> hist = s.getPriceHistory();
  int n = hist.size();
  if (n < 2) return;

  // figure out which day the mouse is closest to
  int hoverIdx = round(map(mouseX, gX, gX + gW, 0, n - 1));
  hoverIdx = constrain(hoverIdx, 0, n - 1);

  float px = gX + map(hoverIdx, 0, n - 1, 0, gW);

  // recalculate the price range so we can position the dot correctly
  float minP = hist.get(0);
  float maxP = hist.get(0);
  for (float p : hist) {
    minP = min(minP, p);
    maxP = max(maxP, p);
  }
  float pad = (maxP - minP) * 0.12;
  minP -= pad;
  maxP += pad;

  float py = gY + map(hist.get(hoverIdx), minP, maxP, gH, 0);
  float hPrice = hist.get(hoverIdx);
  int hDay = hoverIdx + 1;

  // vertical line going from top to bottom of the graph
  stroke(COL_CROSS);
  strokeWeight(1);
  line(px, gY, px, gY + gH);

  // small tick on the y-axis showing what price level the crosshair is at
  stroke(COL_CROSS);
  line(gX - 4, py, gX + 4, py);

  // dot snapped to the price line at the hover point
  noStroke();
  fill(255);
  circle(px, py, 9);
  fill(COL_LINE);
  circle(px, py, 5);

  // price label next to the y-axis
  fill(COL_LINE);
  noStroke();
  textAlign(RIGHT, CENTER);
  textSize(10);
  text("$" + nf(hPrice, 1, 2), gX - 10, py);

  // tooltip box with day, price, and change info
  float ttW = 140;
  float ttH = 52;
  float ttX = px + 12;
  float ttY = py - ttH / 2;

  // flip to the left side if we're near the right edge of the graph
  if (ttX + ttW > gX + gW) ttX = px - ttW - 12;
  ttY = constrain(ttY, gY, gY + gH - ttH);

  fill(COL_TOOLTIP);
  stroke(COL_LINE);
  strokeWeight(1);
  rect(ttX, ttY, ttW, ttH, 5);

  noStroke();
  fill(COL_SUBTEXT);
  textAlign(LEFT, TOP);
  textSize(10);
  text("Day " + hDay, ttX + 10, ttY + 8);

  fill(COL_TEXT);
  textSize(14);
  text("$" + nf(hPrice, 1, 2), ttX + 10, ttY + 22);

  // show the change from the previous day in green or red
  if (hoverIdx > 0) {
    float prev = hist.get(hoverIdx - 1);
    float change = hPrice - prev;
    fill(change >= 0 ? color(0, 200, 140) : color(220, 70, 70));
    textSize(10);
    text((change >= 0 ? "▲ +" : "▼ ") + nf(change, 1, 2), ttX + 10, ttY + 40);
  }

  strokeWeight(1);
}
