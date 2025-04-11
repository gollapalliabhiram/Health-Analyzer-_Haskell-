# 🩺 Health Monitoring Dashboard

A lightweight web application built using **Haskell (Scotty)** and **Tailwind CSS** to upload a health report CSV file and visualize key vitals like Heart Rate, Blood Pressure, Blood Sugar, and Weight.

---

## 📦 Features

- Upload patient CSV report
- Parse vitals like heart rate, blood pressure, sugar, and weight
- Dynamic dashboard with Tailwind UI
- Visualize:
  - 🫀 Heart Rate (Line Chart)
  - 🩸 Blood Sugar (Bar Chart)
- Backend in Haskell using Scotty
- Frontend with HTML, Tailwind CSS, and Chart.js

---


---

## 🚀 Getting Started

### 🔧 Prerequisites

- [Haskell & GHC](https://www.haskell.org/platform/)
- [Cabal](https://www.haskell.org/cabal/)
- A browser

---

### 🛠 Installation & Run

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/health-dashboard.git
cd health-dashboard

# Build the project
cabal build

# Run the server
cabal run health-dashboard

