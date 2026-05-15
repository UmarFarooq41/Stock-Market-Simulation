// Market Class 
class Market {

  ArrayList<Stock> stocks;
  Stock activeStock;

  int riskLevel;
  final String[] CONDITION_LABELS = { "Stable", "Calm", "Moderate", "Volatile", "Turbulent", "Extreme Volatility" };

  int  tickIntervalMs;
  int  lastTickTime;
  boolean running;


  Market(int initialRiskLevel, int tickIntervalMs) {
    stocks              = new ArrayList<Stock>();
    activeStock         = null;
    this.tickIntervalMs = tickIntervalMs;
    lastTickTime        = 0;
    running             = false;
    setRiskLevel(initialRiskLevel);
  }


  void addStock(Stock s) {
    s.setRiskLevel(riskLevel);
    stocks.add(s);
  }

  Stock getStock(int index) {
    if (index < 0 || index >= stocks.size()) return null;
    return stocks.get(index);
  }

  int getStockCount() { return stocks.size(); }


  boolean setActiveStock(int index) {
    if (index < 0 || index >= stocks.size()) return false;
    activeStock = stocks.get(index);
    return true;
  }

  boolean setActiveStockByTicker(String ticker) {
    for (Stock s : stocks) {
      if (s.ticker.equalsIgnoreCase(ticker)) { activeStock = s; return true; }
    }
    return false;
  }

  void setRandomActiveStock() {
    if (stocks.size() > 0) activeStock = stocks.get((int) random(stocks.size()));
  }

  Stock getActiveStock() { return activeStock; }


  // Propagates new risk level to every stock
  void setRiskLevel(int level) {
    riskLevel = constrain(level, 0, 5);
    for (Stock s : stocks) s.setRiskLevel(riskLevel);
  }

  int    getRiskLevel()            { return riskLevel; }
  String getMarketConditionLabel() { return CONDITION_LABELS[riskLevel]; }


  void startSimulation()  { running = true;  lastTickTime = millis(); }
  void pauseSimulation()  { running = false; }
  void resumeSimulation() { running = true;  lastTickTime = millis(); }
  boolean isRunning()     { return running; }

  // Call every draw() loop — fires a tick when the interval has elapsed
  void update() {
    if (!running) return;
    int now = millis();
    if (now - lastTickTime >= tickIntervalMs) { tick(); lastTickTime = now; }
  }

  // Advances every stock's price by one step
  void tick() {
    for (Stock s : stocks) s.updatePrice();
  }

  void setTickInterval(int ms) { if (ms > 0) tickIntervalMs = ms; }


  boolean buyActiveStock(int shares)  { return activeStock != null && activeStock.buyShares(shares); }
  boolean sellActiveStock(int shares) { return activeStock != null && activeStock.sellShares(shares); }


  float getTotalPortfolioValue() { float t = 0; for (Stock s : stocks) t += s.getCurrentValue();       return t; }
  float getTotalAmountInvested() { float t = 0; for (Stock s : stocks) t += s.totalAmountInvested;     return t; }
  float getTotalProfitLoss()     { return getTotalPortfolioValue() - getTotalAmountInvested(); }


  void printMarketStatus() {
    println("╔══════════════════════════════════════════╗");
    println("║            MARKET STATUS                 ║");
    println("╚══════════════════════════════════════════╝");
    println("  Risk   : " + riskLevel + " – " + getMarketConditionLabel());
    println("  Status : " + (running ? "RUNNING" : "PAUSED"));
    println("  Active : " + (activeStock != null ? activeStock.ticker : "none"));
    println("  Total Value : $" + nf(getTotalPortfolioValue(), 1, 2));
    println("  Total P/L   : $" + nf(getTotalProfitLoss(), 1, 2));
    for (Stock s : stocks) s.printStatus();
  }

  void printAllPrices() {
    println("── Prices ───────────────────────────────────");
    for (Stock s : stocks) {
      String arrow = s.currentPrice >= s.initialPrice ? "▲" : "▼";
      println("  " + s.ticker + "  $" + nf(s.currentPrice, 1, 2) +
              "  " + arrow + " " + nf(abs(s.getPriceChangePercent()), 1, 2) + "%" +
              "  [owned: " + s.sharesOwned + "]");
    }
    println("─────────────────────────────────────────────");
  }
}
