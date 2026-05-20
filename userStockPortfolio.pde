class userStockPortfolio {

  // Fields
  String userName;

  ArrayList<Stock> myHoldings;


  // Constructor
  userStockPortfolio(String name) {

    // store username
    this.userName = name;
    myHoldings = new ArrayList <Stock>(); // create empty ArrayList

  }

  // Method to add a stock into portfolio
  void addStock(Stock s) {

    // add stock into ArrayList
    myHoldings.add(s);
   

  }


  // Method to calculate total value
  float getTotalValue() {

    float total = 0; // starts a 0 and grows based on our calculations

    // go through all stocks
   
    for (int i = 0; i < myHoldings.size(); i++){
     
      Stock currStock = myHoldings.get(i);
     
      total += currStock.getCurrentValue();  
    }

        // add each stock's value to total

    return total;
  }


  // Method to calculate total profit/loss
  float getTotalProfit() {

    float totalProfit = 0;

    // go through all stocks
   
    for (int i = 0; i<myHoldings.size(); i++){
     
      // get one stock from list
      Stock currStock = myHoldings.get(i);
     
      totalProfit += currStock.getProfitLoss();
    }

        // add each stock's profit/loss

    return totalProfit;
  }

  void showPortfolio( float x, float y){
   
    textSize (15);
    fill(0);
   
    text("Total Share Value: $ " + getTotalValue(), x, y);
    text("Profit/Loss: $ " + getTotalProfit(), x, y+30);
    text("Companies Invested In: " + myHoldings.size(), x,y+60);
  }
 
  void showEachStock(float x, float y){
   
    // for every stock the user owns
    for ( int i =0; i< myHoldings.size(); i++){
     
      Stock currStock = myHoldings.get(i); // getting one stock at a time
     
      float rowY = y+ (i*40); // each stock gets its own row where its displayed on screen i*30 pushed row down
     
      text(currStock.companyName + " Shares: " + currStock.sharesOwned + " Value $ " + currStock.getCurrentValue() + " Profit: $ " + currStock.getProfitLoss(), x,rowY);
    }
 
  }


  // Display method
  void printSummary() {

    println("User: " + userName);

    println("Number of Stocks: " + myHoldings.size());

    println("Total Portfolio Value: $" + getTotalValue());

    println("Total Profit/Loss: $" + getTotalProfit());

  }
}
