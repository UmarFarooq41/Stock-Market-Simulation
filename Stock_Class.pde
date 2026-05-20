// Stock class
// This handles everything related to a single company's stock.
// It tracks the price over time, lets you buy and sell shares,
// and calculates things like profit/loss.
// Author: Umar Farooq

class Stock {

  String ticker;
  String companyName;

  float currentPrice;
  float initialPrice; // the price when the user first bought shares
  ArrayList<Float> priceHistory;

  int sharesOwned;
  float totalAmountInvested;

  int riskLevel;
  // how much the price can swing at each risk level (0 = barely moves, 5 = very wild)
  final float[] VOLATILITY = { 0.005, 0.01, 0.02, 0.04, 0.07, 0.12 };

  ArrayList<String> transactionHistory;


  Stock(String ticker, String companyName, float startingPrice, float[] seedHistory) {
    this.ticker = ticker;
    this.companyName = companyName;
    this.currentPrice = startingPrice;
    this.initialPrice = startingPrice;

    // load in the past prices so the graph has something to show from the start
    priceHistory = new ArrayList<Float>();
    for (float p : seedHistory) priceHistory.add(p);
    priceHistory.add(startingPrice);

    sharesOwned = 0;
    totalAmountInvested = 0.0;
    riskLevel = 0;
    transactionHistory = new ArrayList<String>();
  }


  // moves the price forward by one day using a random walk model
  void updatePrice() {
    float vol = VOLATILITY[constrain(riskLevel, 0, 5)];
    float pctChange = random(-1, 1) * vol;
    float drift = 0.001 * (1.0 / (riskLevel + 1)); // small upward bias so stocks can grow
    currentPrice = max(0.01, currentPrice * (1 + pctChange + drift));
    priceHistory.add(currentPrice);
  }

  void setRiskLevel(int level) {
    riskLevel = constrain(level, 0, 5);
  }


  // buy some shares at the current price, returns false if the quantity is invalid
  boolean buyShares(int shares) {
    if (shares <= 0) return false;
    float cost = shares * currentPrice;
    if (sharesOwned == 0) initialPrice = currentPrice; // lock in the starting price for P/L
    sharesOwned += shares;
    totalAmountInvested += cost;
    transactionHistory.add("BUY " + shares + " @ $" + nf(currentPrice, 1, 2) + "  cost $" + nf(cost, 1, 2));
    return true;
  }

  // sell some shares, returns false if you don't own enough
  boolean sellShares(int shares) {
    if (shares <= 0 || shares > sharesOwned) return false;
    float revenue = shares * currentPrice;
    // reduce the invested amount proportionally so P/L stays accurate
    totalAmountInvested *= (float)(sharesOwned - shares) / sharesOwned;
    sharesOwned -= shares;
    transactionHistory.add("SELL " + shares + " @ $" + nf(currentPrice, 1, 2) + "  revenue $" + nf(revenue, 1, 2));
    return true;
  }


  float getCurrentValue() { return sharesOwned * currentPrice; }
  float getProfitLoss() { return getCurrentValue() - totalAmountInvested; }
  float getProfitLossPercent() { return totalAmountInvested == 0 ? 0 : (getProfitLoss() / totalAmountInvested) * 100.0; }
  float getPriceChange() { return currentPrice - initialPrice; }
  float getPriceChangePercent() { return initialPrice == 0 ? 0 : ((currentPrice - initialPrice) / initialPrice) * 100.0; }

  ArrayList<Float> getPriceHistory() { return priceHistory; }
  ArrayList<String> getTransactionHistory() { return new ArrayList<String>(transactionHistory); }


  void printStatus() {
    String pl = (getProfitLoss() >= 0 ? "+" : "") + nf(getProfitLoss(), 1, 2);
    String plPct = (getProfitLossPercent() >= 0 ? "+" : "") + nf(getProfitLossPercent(), 1, 2) + "%";
    String chg = (getPriceChange() >= 0 ? "+" : "") + nf(getPriceChange(), 1, 2);
    String chgPct = (getPriceChangePercent() >= 0 ? "+" : "") + nf(getPriceChangePercent(), 1, 2) + "%";
    println("  " + companyName + " (" + ticker + ")");
    println("  Price    : $" + nf(currentPrice, 1, 2) + "  (" + chg + " / " + chgPct + ")");
    println("  Shares   : " + sharesOwned);
    println("  Value    : $" + nf(getCurrentValue(), 1, 2));
    println("  Invested : $" + nf(totalAmountInvested, 1, 2));
    println("  P/L      : $" + pl + "  (" + plPct + ")");
  }
}
