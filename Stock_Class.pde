class Stock {

  //Fields
  
  // naming fields
  String ticker;          // e.g. "AAPL"
  String companyName;     // e.g. "Apple Inc."

  // price fields
  float currentPrice;           // Most recent price
  float initialPrice;           // Price at time of first purchase
  ArrayList<Float> priceHistory; // Full history of prices (used for graph)

  // ownership
  int sharesOwned;          // Number of shares currently held
  float totalAmountInvested; // Total dollars spent buying shares

  // Risk level 0–5 supplied by the Market; stored here for convenience
  int riskLevel;

  // Volatility multipliers indexed by risk level (0 = very stable, 5 = wild)
  final float[] voltatility = {0.005, 0.01, 0.02, 0.04, 0.07, 0.12};

  // Transaction history
  ArrayList<String> transactionHistory; // Human-readable log of buys/sells


  // Constructor

  Stock(String ticker, String companyName, float startingPrice, ArrayList<Float> history) {
    this.ticker      = ticker;
    this.companyName = companyName;
    this.currentPrice = startingPrice;
    this.initialPrice = startingPrice;

    this.priceHistory = new ArrayList<Float>(history);
    this.priceHistory.add(startingPrice); // make sure the current price is included

    this.sharesOwned         = 0;
    this.totalAmountInvested = 0.0;
    this.riskLevel           = 0;

    this.transactionHistory = new ArrayList<String>();
  }


  // Methods

  // Price Simulation
 

  //Advances the stock price by one simulated time step. Uses a simple random-walk model scaled by the current risk level. 
  // The new price is appended to priceHistory.

  void updatePrice() {
    float volatility  = voltatility[constrain(riskLevel, 0, 5)];

    // Random percentage change centred around 0, scaled by volatility
    float pctChange   = (random(-1, 1) * volatility);

    // Small positive drift so long-held stocks can grow
    float drift       = 0.001 * (1.0 / (riskLevel + 1));

    currentPrice = max(0.01, currentPrice * (1 + pctChange + drift));
    priceHistory.add(currentPrice);
  }

  //Sets the market risk level used when simulating price changes.

  void setRiskLevel(int level) {
    riskLevel = constrain(level, 0, 5);
  }

  // Buy / Sell

  // Buys a given number of shares at the current price. Records the transaction and adjusts ownership/investment totals.

  boolean buyShares(int shares) {
    if (shares <= 0) return false;

    float cost = shares * currentPrice;
    sharesOwned          += shares;
    totalAmountInvested  += cost;

    // Set initialPrice on first-ever buy
    if (sharesOwned == shares) {
      initialPrice = currentPrice;
    }

    transactionHistory.add(
      "BUY  " + shares + " share(s) of " + ticker +
      " @ $" + nf(currentPrice, 1, 2) +
      "Total cost: $" + nf(cost, 1, 2)
    );
    return true;
  }

  // Sells a given number of shares at the current price. Records the transaction and adjusts ownership totals.
   
  boolean sellShares(int shares) {
    if (shares <= 0 || shares > sharesOwned) return false;

    float revenue = shares * currentPrice;

    // Reduce invested amount proportionally
    if (sharesOwned > 0) {
      totalAmountInvested *= (float)(sharesOwned - shares) / sharesOwned;
    }
    sharesOwned -= shares;

    transactionHistory.add(
      "SELL " + shares + " share(s) of " + ticker +
      " @ $" + nf(currentPrice, 1, 2) +
      "Revenue: $" + nf(revenue, 1, 2)
    );
    return true;
  }

  // Statistics / Portfolio Helpers

  //Returns the current market value of all owned shares.

  float getCurrentValue() {
    return sharesOwned * currentPrice;
  }

  //Returns the raw dollar profit or loss on this stock.

  float getProfitLoss() {
    return getCurrentValue() - totalAmountInvested;
  }

  //Returns profit/loss as a percentage of the amount invested.

  float getProfitLossPercent() {
    if (totalAmountInvested == 0) return 0.0;
    return (getProfitLoss() / totalAmountInvested) * 100.0;
  }

  //Returns the dollar change in the stock price since the initial purchase.
  
  float getPriceChange() {
    return currentPrice - initialPrice;
  }

  //Returns the percentage change in price since the initial purchase.
   
  float getPriceChangePercent() {
    if (initialPrice == 0) return 0.0;
    return ((currentPrice - initialPrice) / initialPrice) * 100.0;
  }

  //Returns the full ArrayList of historical prices
  
  ArrayList<Float> getPriceHistory() {
    return priceHistory;
  }

  //Returns a copy of the transaction history log.
   
  ArrayList<String> getTransactionHistory() {
    return new ArrayList<String>(transactionHistory);
  }

  // Display / Debug

  void printStatus() {
    println("──────────────────────────────────");
    println("  " + companyName + " (" + ticker + ")");
    println("  Current Price : $" + nf(currentPrice, 1, 2));
    println("  Shares Owned  : " + sharesOwned);
    println("  Market Value  : $" + nf(getCurrentValue(), 1, 2));
    println("  Invested      : $" + nf(totalAmountInvested, 1, 2));
    println("  P/L           : $" + nf(getProfitLoss(), 1, 2) +
            "  (" + nf(getProfitLossPercent(), 1, 2) + "%)");
    println("  Price Change  : $" + nf(getPriceChange(), 1, 2) +
            "  (" + nf(getPriceChangePercent(), 1, 2) + "%)");
    println("  Risk Level    : " + riskLevel);
    println("──────────────────────────────────");
  }
}
