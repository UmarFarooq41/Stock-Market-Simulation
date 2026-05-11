class Stock {

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
  final float[] volatility = {0.005, 0.01, 0.02, 0.04, 0.07, 0.12};

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


  // Price Simulation

  //Advances the stock price by one simulated time step. Uses a simple random-walk model scaled by the current risk level. 
  // The new price is appended to priceHistory.

  void updatePrice() {
    float volatility  = volatility[constrain(riskLevel, 0, 5)];

    // Random percentage change centred around 0, scaled by volatility
    float pctChange   = (random(-1, 1) * volatility);

    // Small positive drift so long-held stocks can grow
    float drift       = 0.001 * (1.0 / (riskLevel + 1));

    currentPrice = max(0.01, currentPrice * (1 + pctChange + drift));
    priceHistory.add(currentPrice);
  }

}
