class Market {

  ArrayList<Stock> stocks;
  Stock activeStock;

  int riskLevel;

  int tickIntervalMs;
  int lastTickTime;
  boolean running;

  String marketConditionLabel;

  final String[] CONDITION_LABELS = {
    "Stable",
    "Calm",
    "Moderate",
    "Volatile",
    "Turbulent",
    "Extreme Volatility"
  };

  Market(int initialRiskLevel, int tickIntervalMs) {
    this.stocks = new ArrayList<Stock>();
    this.activeStock = null;
    this.tickIntervalMs = tickIntervalMs;
    this.lastTickTime = 0;
    this.running = false;

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

  int getStockCount() {
    return stocks.size();
  }

  boolean setActiveStock(int index) {
    if (index < 0 || index >= stocks.size()) return false;
    activeStock = stocks.get(index);
    return true;
  }

  boolean setActiveStockByTicker(String ticker) {
    for (Stock s : stocks) {
      if (s.ticker.equalsIgnoreCase(ticker)) {
        activeStock = s;
        return true;
      }
    }
    return false;
  }

  void setRandomActiveStock() {
    if (stocks.size() == 0) return;
    int idx = (int) random(stocks.size());
    activeStock = stocks.get(idx);
  }

  Stock getActiveStock() {
    return activeStock;
  }

  void setRiskLevel(int level) {
    riskLevel = constrain(level, 0, 5);
    marketConditionLabel = CONDITION_LABELS[riskLevel];

    for (Stock s : stocks) {
      s.setRiskLevel(riskLevel);
    }
  }

  int getRiskLevel() {
    return riskLevel;
  }

  String getMarketConditionLabel() {
    return marketConditionLabel;
  }

  void startSimulation() {
    running = true;
    lastTickTime = millis();
  }

  void pauseSimulation() {
    running = false;
  }

  void resumeSimulation() {
    running = true;
    lastTickTime = millis();
  }

  boolean isRunning() {
    return running;
  }

  void update() {
    if (!running) return;

    int now = millis();

    if (now - lastTickTime >= tickIntervalMs) {
      tick();
      lastTickTime = now;
    }
  }

  void tick() {
    for (Stock s : stocks) {
      s.updatePrice();
    }
  }

  void setTickInterval(int ms) {
    if (ms > 0) tickIntervalMs = ms;
  }

  boolean buyActiveStock(int shares) {
    if (activeStock == null) return false;
    return activeStock.buyShares(shares);
  }

  boolean sellActiveStock(int shares) {
    if (activeStock == null) return false;
    return activeStock.sellShares(shares);
  }

  float getTotalPortfolioValue() {
    float total = 0;

    for (Stock s : stocks) {
      total += s.getCurrentValue();
    }

    return total;
  }

  float getTotalAmountInvested() {
    float total = 0;

    for (Stock s : stocks) {
      total += s.totalAmountInvested;
    }

    return total;
  }

  float getTotalProfitLoss() {
    return getTotalPortfolioValue() - getTotalAmountInvested();
  }

  void printMarketStatus() {
    println("══════════════════════════════════════");
    println("  MARKET STATUS");
    println("  Risk Level  : " + riskLevel + " (" + marketConditionLabel + ")");
    println("  Simulation  : " + (running ? "RUNNING" : "PAUSED"));
    println("  Tick Every  : " + tickIntervalMs + " ms");
    println("  Stocks      : " + stocks.size());
    println("  Active      : " + (activeStock != null ? activeStock.ticker : "none"));
    println("  Portfolio   : $" + nf(getTotalPortfolioValue(), 1, 2));
    println("  Invested    : $" + nf(getTotalAmountInvested(), 1, 2));
    println("  Total P/L   : $" + nf(getTotalProfitLoss(), 1, 2));
    println("══════════════════════════════════════");

    for (Stock s : stocks) {
      s.printStatus();
    }
  }
}
