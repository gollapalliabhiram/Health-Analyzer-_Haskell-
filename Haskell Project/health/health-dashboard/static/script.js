// script.js

const fileInput = document.getElementById("file");
const uploadBtn = document.getElementById("uploadBtn");
const resultContainer = document.getElementById("result");
const healthScoreCard = document.getElementById("healthScoreCard");
const healthScoreValue = document.getElementById("healthScoreValue");
const uploadProgressContainer = document.getElementById("uploadProgressContainer");
const uploadProgressCircle = document.getElementById("uploadProgressCircle");
const uploadProgressText = document.getElementById("uploadProgressText");

const charts = {};

function updateCircularProgress(percent) {
  const offset = 100 - percent;
  uploadProgressCircle.style.strokeDashoffset = offset;
  uploadProgressText.textContent = `${percent}%`;
}

uploadBtn.addEventListener("click", async () => {
  const file = fileInput.files[0];
  if (!file) return alert("Please select a CSV file!");

  const formData = new FormData();
  formData.append("file", file);

  uploadProgressContainer.classList.remove("hidden");
  updateCircularProgress(0);

  try {
    const response = await fetch("/upload", {
      method: "POST",
      body: formData,
    });

    if (!response.ok) throw new Error("Upload failed.");

    const data = await response.json();

    // DEBUG: Check incoming data
    console.log("Data received from backend:", data);

    // Fill Cards
    const metrics = {
      "Heart Rate (BPM)": data.heartRate,
      "Blood Sugar (mg/dL)": data.bloodSugar,
      "Systolic BP (mmHg)": data.bloodPressureSystolic,
      "Diastolic BP (mmHg)": data.bloodPressureDiastolic,
      "Weight (kg)": data.weight,
    };

    resultContainer.innerHTML = "";
    Object.entries(metrics).forEach(([label, value]) => {
      const card = document.createElement("div");
      card.className = "bg-white rounded-lg shadow p-6";
      card.innerHTML = `
        <h3 class="text-xl font-bold text-gray-700">${label}</h3>
        <p class="text-3xl mt-2 font-extrabold text-blue-600">${value}</p>
      `;
      resultContainer.appendChild(card);
    });

    // Health Score
    const allValues = Object.values(metrics).map(Number);
    const score = Math.round(100 - Math.abs(75 - (allValues.reduce((a, b) => a + b, 0) / allValues.length)));
    healthScoreValue.textContent = score;
    healthScoreCard.classList.remove("hidden");

    // Draw Charts
    drawLineChart("heartRateChart", "Heart Rate", data.heartRateHistory || [], ["3 Days Ago", "2 Days Ago", "Yesterday", "Today"]);
    drawLineChart("bloodSugarChart", "Blood Sugar", data.bloodSugarHistory || [], ["3 Days Ago", "2 Days Ago", "Yesterday", "Today"]);
    drawLineChart("bloodPressureChart", "Systolic/Diastolic", data.bloodPressureHistory || [], ["3 Days Ago", "2 Days Ago", "Yesterday", "Today"], true);
    drawLineChart("weightChart", "Weight", data.weightHistory || [], ["3 Days Ago", "2 Days Ago", "Yesterday", "Today"]);
    drawRadarChart(data);

    updateCircularProgress(100);
    setTimeout(() => {
      uploadProgressContainer.classList.add("hidden");
    }, 1500);

  } catch (error) {
    alert("Error uploading file: " + error.message);
    updateCircularProgress(0);
    uploadProgressContainer.classList.add("hidden");
  }
});

function drawLineChart(id, label, dataPoints, labels, isBloodPressure = false) {
  const canvas = document.getElementById(id);
  const ctx = canvas.getContext("2d");
  canvas.height = 300; // enforce canvas height

  if (charts[id]) charts[id].destroy();

  if (!dataPoints || dataPoints.length === 0) {
    console.warn(`No data for chart: ${id}`);
    return;
  }

  let datasets = [];

  if (isBloodPressure && Array.isArray(dataPoints[0])) {
    // Expected structure: [[120, 80], [122, 82], ...]
    const systolic = dataPoints.map(dp => dp[0]);
    const diastolic = dataPoints.map(dp => dp[1]);

    datasets = [
      {
        label: "Systolic",
        data: systolic,
        borderColor: "#ef4444",
        backgroundColor: "rgba(239, 68, 68, 0.2)",
        fill: true,
        tension: 0.4
      },
      {
        label: "Diastolic",
        data: diastolic,
        borderColor: "#3b82f6",
        backgroundColor: "rgba(59, 130, 246, 0.2)",
        fill: true,
        tension: 0.4
      }
    ];
  } else {
    datasets = [{
      label: label,
      data: dataPoints,
      borderColor: "#3b82f6",
      backgroundColor: "rgba(59, 130, 246, 0.2)",
      fill: true,
      tension: 0.4,
      pointRadius: 4,
      pointHoverRadius: 6,
    }];
  }

  charts[id] = new Chart(ctx, {
    type: "line",
    data: {
      labels: labels,
      datasets: datasets
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        y: {
          beginAtZero: false
        }
      }
    }
  });
}

function drawRadarChart(data) {
  const canvas = document.getElementById("healthRadarChart");
  const ctx = canvas.getContext("2d");
  canvas.height = 400; // enforce canvas height

  if (charts.radar) charts.radar.destroy();

  charts.radar = new Chart(ctx, {
    type: "radar",
    data: {
      labels: [
        "Heart Rate",
        "Blood Sugar",
        "Systolic BP",
        "Diastolic BP",
        "Weight"
      ],
      datasets: [{
        label: "Vitals Overview",
        data: [
          data.heartRate,
          data.bloodSugar,
          data.bloodPressureSystolic,
          data.bloodPressureDiastolic,
          data.weight
        ],
        backgroundColor: "rgba(59, 130, 246, 0.2)",
        borderColor: "#3b82f6",
        pointBackgroundColor: "#3b82f6",
        borderWidth: 2,
        pointRadius: 4
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        r: {
          suggestedMin: 0,
          suggestedMax: 200,
          ticks: {
            beginAtZero: true,
            stepSize: 20
          },
          pointLabels: {
            font: { size: 14 }
          }
        }
      }
    }
  });
}
