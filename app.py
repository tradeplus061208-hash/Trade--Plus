import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
import streamlit as st

# Page Configuration
st.set_page_config(
    page_title="Trade Plus - XAUUSD AI Dashboard",
    page_icon="📈",
    layout="wide",
)

st.title("📈 Trade Plus: XAUUSD AI-Assisted Dashboard")
st.markdown(
    "Real-time technical indicators, machine learning trend predictions, and"
    " automated risk management for Gold trading."
)


# Generate Simulated Live XAUUSD Data
@st.cache_data(ttl=60)
def load_data():
  np.random.seed(42)
  dates = pd.date_range(start="2025-01-01", periods=300, freq="D")
  base_price = 2600.0
  price_changes = np.random.normal(loc=1.5, scale=15.0, size=300)
  prices = base_price + np.cumsum(price_changes)

  df = pd.DataFrame(
      {
          "Date": dates,
          "Open": prices - np.random.uniform(0, 5, 300),
          "High": prices + np.random.uniform(5, 15, 300),
          "Low": prices - np.random.uniform(5, 15, 300),
          "Close": prices + np.random.uniform(-5, 5, 300),
      }
  )
  df.set_index("Date", inplace=True)
  return df


df = load_data()

# Technical Indicators
df["SMA_50"] = df["Close"].rolling(window=50).mean()
df["SMA_200"] = df["Close"].rolling(window=200).mean()
delta = df["Close"].diff()
gain = (delta.where(delta > 0, 0)).rolling(window=14).mean()
loss = (-delta.where(delta < 0, 0)).rolling(window=14).mean()
rs = gain / loss
df["RSI"] = 100 - (100 / (1 + rs))
df.dropna(inplace=True)

# Machine Learning Signal Generator
df["Target"] = np.where(df["Close"].shift(-1) > df["Close"], 1, 0)
features = ["Open", "High", "Low", "Close", "SMA_50", "RSI"]
X = df[features]
y = df["Target"]

model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X, y)
df["AI_Signal"] = model.predict(X)

# Dashboard Layout
st.subheader("📊 Live XAUUSD Market Overview")
col1, col2, col3 = st.columns(3)

latest_close = float(df["Close"].iloc[-1])
prev_close = float(df["Close"].iloc[-2])
price_change = latest_close - prev_close
latest_rsi = float(df["RSI"].iloc[-1])
latest_signal = (
    "🟢 BUY (Bullish)"
    if int(df["AI_Signal"].iloc[-1]) == 1
    else "🔴 SELL (Bearish)"
)

col1.metric(
    "Current Gold Price",
    f"${latest_close:.2f}",
    f"{price_change:+.2f} USD",
)
col2.metric("RSI (14)", f"{latest_rsi:.2f}")
col3.metric("AI Trend Signal", latest_signal)

st.line_chart(df[["Close", "SMA_50"]])

st.subheader("⚙️ Risk & Position Calculator")
account_balance = st.number_input(
    "Account Balance ($)", min_value=100.0, value=10000.0, step=100.0
)
risk_pct = st.slider("Risk Percentage per Trade (%)", 0.5, 5.0, 1.0)
stop_loss_pips = st.number_input("Stop Loss (Pips / Points)", value=30.0)

risk_amount = account_balance * (risk_pct / 100.0)
st.write(
    f"**Recommended Risk Amount:** ${risk_amount:.2f} | **Suggested Lot"
    f" Size:** {risk_amount / (stop_loss_pips * 10):.2f} Lots"
)
