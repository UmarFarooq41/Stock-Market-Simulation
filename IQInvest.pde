// iQINVEST – Stock Market Simulator
// Automated simulation: runs one week at a time, randomly buys/sells stocks,
// and prints everything to the console. Replace the auto functions with GUI
// button calls later.
// Project Leads: Vaani Patel, Umar Farooq, Abdelrahman Mohamed

Market market;
int week = 0;
int ticksPerWeek = 25; // 5 days x 5 price updates


void setup() {
  size(400, 140);
  exit();

  market = new Market(1, 0);
  market.addStock(new Stock("APXL", "Apex Technologies",  142.50, new float[]{ 128, 131, 135, 133, 138, 140, 142 }));
  market.addStock(new Stock("NVOX", "NovaMed Biotech",     88.00, new float[]{ 78, 80, 83, 81, 85, 87, 88 }));
  market.addStock(new Stock("ZREN", "ZenRenew Energy",     55.25, new float[]{ 48, 50, 51, 53, 52, 54, 55 }));
  market.addStock(new Stock("ORCA", "OrcaBank Financial", 210.00, new float[]{ 193, 197, 202, 199, 205, 208, 210 }));

  println("╔══════════════════════════════════════════╗");
  println("║    iQINVEST – Stock Market Simulator     ║");
  println("╚══════════════════════════════════════════╝");
  printAllPrices();
}


// ── Simulate one week ─────────────────────────────────────────────────────

void simulateWeek() {
  week++;

  // Auto: randomly buy or sell before prices move
  autoTrade();

  // Run 25 price ticks
  for (int i = 0; i < ticksPerWeek; i++) market.tick();

  println("\n── Week " + week + " ──────────────────────────────────");
  printAllPrices();
  printPortfolio();
}


// ── Auto trading (replace these calls with GUI button actions later) ──────

void autoTrade() {
  // Pick a random stock
  int idx = (int) random(market.getStockCount());
  market.setActiveStock(idx);
  Stock s = market.getActiveStock();

  // 50% chance to buy, 50% chance to sell (if we own shares)
  boolean tryBuy = random(1) > 0.5;

  if (tryBuy) {
    int qty = (int) random(1, 6); // buy 1–5 shares
    market.buyActiveStock(qty);
    println("[AUTO BUY]  " + qty + " share(s) of " + s.ticker + " @ $" + nf(s.currentPrice, 1, 2));
  } else {
    if (s.sharesOwned > 0) {
      int qty = (int) random(1, s.sharesOwned + 1); // sell 1 to all owned
      market.sellActiveStock(qty);
      println("[AUTO SELL] " + qty + " share(s) of " + s.ticker + " @ $" + nf(s.currentPrice, 1, 2));
    } else {
      // Nothing to sell, buy instead
      int qty = (int) random(1, 4);
      market.buyActiveStock(qty);
      println("[AUTO BUY]  " + qty + " share(s) of " + s.ticker + " @ $" + nf(s.currentPrice, 1, 2) + " (no shares to sell)");
    }
  }
}


// ── Console output ────────────────────────────────────────────────────────

void printAllPrices() {
  println("  Ticker  Price       Change");
  for (int i = 0; i < market.getStockCount(); i++) {
    Stock s = market.getStock(i);
    String arrow = s.getPriceChange() >= 0 ? "▲" : "▼";
    String chg   = (s.getPriceChange() >= 0 ? "+" : "") + nf(s.getPriceChange(), 1, 2);
    println("  " + s.ticker + "    $" + nf(s.currentPrice, 1, 2) + "    " + arrow + " " + chg);
  }
}

void printPortfolio() {
  float totalGain = 0, totalLoss = 0;
  boolean any = false;
  println("  Portfolio:");
  for (int i = 0; i < market.getStockCount(); i++) {
    Stock s = market.getStock(i);
    if (s.sharesOwned > 0) {
      any = true;
      float pl = s.getProfitLoss();
      println("    " + s.ticker + " x" + s.sharesOwned +
              "  Value: $" + nf(s.getCurrentValue(), 1, 2) +
              "  P/L: " + (pl >= 0 ? "+$" : "-$") + nf(abs(pl), 1, 2));
      if (pl >= 0) totalGain += pl;
      else         totalLoss += pl;
    }
  }
  if (!any) { println("    (no positions held)"); return; }
  float net = market.getTotalProfitLoss();
  println("  Total Gain : +$" + nf(totalGain, 1, 2));
  println("  Total Loss :  $" + nf(totalLoss, 1, 2));
  println("  Net P/L    : " + (net >= 0 ? "+$" : "-$") + nf(abs(net), 1, 2));
}
