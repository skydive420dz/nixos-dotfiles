function pad(n) {
  return n < 10 ? "0" + n : "" + n;
}

function tick() {
  var now = new Date();
  var hours = now.getHours();
  var suffix = hours >= 12 ? "PM" : "AM";
  hours = hours % 12;
  if (hours === 0) hours = 12;

  document.getElementById("clock").innerHTML =
    hours + ":" + pad(now.getMinutes()) + " " + suffix;

  document.getElementById("date").innerHTML =
    now.toDateString();
}

function text(card, field, value) {
  var node = card.querySelector('[data-field="' + field + '"]');
  if (node) node.innerHTML = value || "--";
}

function number(value) {
  var n = parseInt(value, 10);
  return isNaN(n) ? 0 : n;
}

function bar(field, value) {
  var node = document.querySelector('[data-bar="' + field + '"]');
  if (!node) return;
  var n = number(value);
  if (n < 0) n = 0;
  if (n > 100) n = 100;
  node.style.width = n + "%";
  node.className = n >= 85 ? "critical" : n >= 70 ? "warn" : "";
}

function hostClass(data) {
  if (!data.online) return "offline";
  if (number(data.disk_pct) >= 85) return "online critical";
  if (data.battery_pct !== "" && number(data.battery_pct) < 30) return "online critical";
  if (number(data.gpu_temp) >= 80) return "online critical";
  if (number(data.disk_pct) >= 70) return "online warn";
  if (number(data.gpu_temp) >= 70) return "online warn";
  if (data.services && data.services.indexOf("inactive") >= 0) return "online warn";
  return "online";
}

function setCard(id, data) {
  var card = document.getElementById("card-" + id);
  if (!card) return;

  card.className = hostClass(data);
  text(card, "state", data.online ? "online" : "offline");
  text(card, "uptime", "uptime: " + (data.uptime || "--"));
  text(card, "load", "load: " + (data.load || "--"));
  text(card, "extra", data.extra || "");
}

function detail(field, value) {
  var node = document.querySelector('[data-detail="' + field + '"]');
  if (node) node.innerHTML = value || "--";
}

function setDetails(data) {
  var msi = data.msi || {};
  var t430 = data.t430 || {};
  var x230t = data.x230t || {};

  detail("t430Battery", "T430: " + (t430.battery || "--"));
  detail("x230tBattery", "X230T: " + (x230t.battery || "--"));

  detail("msiDisk", "MSI: " + (msi.disk || "--"));
  detail("t430Disk", "T430: " + (t430.disk || "--"));
  detail("x230tDisk", "X230T: " + (x230t.disk || "--"));

  detail("msiServices", "MSI: " + (msi.services || "--"));
  detail("t430Services", "T430: " + (t430.services || "--"));
  detail("x230tServices", "X230T: " + (x230t.services || "--"));

  detail("gpu", "GPU: " + (msi.gpu || "--"));
  detail("ollama", "Ollama: " + (msi.ollama || "--"));

  detail("msiCpu", (msi.cpu_pct || "0") + "%");
  detail("msiRam", (msi.ram_pct || "0") + "%");
  bar("msiCpu", msi.cpu_pct);
  bar("msiRam", msi.ram_pct);

  detail("router", "Router: " + ((data.router && data.router.online) ? "online" : "offline"));
  detail("routerHttp", "HTTP: " + ((data.router && data.router.http) ? "ready" : "unavailable"));
  detail("alerts", alerts(data).join("<br>") || "All quiet.");
  setEvents(data);
}

function alerts(data) {
  var out = [];
  addHostAlerts(out, "MSI", data.msi || {});
  addHostAlerts(out, "T430", data.t430 || {});
  addHostAlerts(out, "X230T", data.x230t || {});
  if (data.ipad && !data.ipad.online) out.push("iPad is offline");
  if (data.ipad && data.ipad.uptime && data.ipad.uptime.indexOf("unknown") >= 0) {
    out.push("iPad SSH not ready");
  }
  if (data.router && !data.router.online) out.push("Router is offline");
  return out;
}

function addHostAlerts(out, label, host) {
  if (!host.online) {
    out.push(label + " offline");
    return;
  }
  if (host.battery_pct !== "" && number(host.battery_pct) < 30) {
    out.push(label + " battery low: " + host.battery_pct + "%");
  }
  if (number(host.disk_pct) >= 85) out.push(label + " disk high: " + host.disk_pct + "%");
  if (number(host.gpu_temp) >= 80) out.push(label + " GPU hot: " + host.gpu_temp + "C");
  if (host.services && host.services.indexOf("inactive") >= 0) out.push(label + " service inactive");
}

function setEvents(data) {
  var events = [];
  events.push("MSI " + ((data.msi && data.msi.online) ? "online" : "offline"));
  events.push("Ollama " + ((data.msi && data.msi.ollama && data.msi.ollama !== "not reachable") ? "ready" : "unavailable"));
  events.push("Router " + ((data.router && data.router.online) ? "online" : "offline"));
  events.push("iPad " + ((data.ipad && data.ipad.online) ? "awake" : "offline"));
  events.push("T430 " + ((data.t430 && data.t430.online) ? "online" : "offline"));
  events.push("X230T " + ((data.x230t && data.x230t.online) ? "online" : "offline"));
  for (var i = 0; i < 4; i++) {
    var node = document.querySelector('[data-event="' + i + '"]');
    if (node) node.innerHTML = events[i] || "";
  }
}

function loadStatus() {
  var request = new XMLHttpRequest();
  request.onreadystatechange = function() {
    if (request.readyState !== 4) return;
    if (request.status !== 200) return;

    try {
      var data = JSON.parse(request.responseText);
      setCard("msi", data.msi || {});
      setCard("t430", data.t430 || {});
      setCard("x230t", data.x230t || {});
      setCard("ipad", data.ipad || {});
      setDetails(data);
      document.getElementById("updated").innerHTML =
        "Updated: " + (data.updated || "--");
    } catch (e) {
      document.getElementById("updated").innerHTML = "Updated: parse error";
    }
  };
  request.open("GET", "status.json?t=" + new Date().getTime(), true);
  request.send();
}

function askOllama() {
  var prompt = document.getElementById("prompt").value;
  var model = document.getElementById("model").value;
  var answer = document.getElementById("answer");
  var state = document.getElementById("askState");
  var button = document.getElementById("askButton");

  if (!prompt || prompt.replace(/^\s+|\s+$/g, "") === "") {
    state.innerHTML = "type something";
    return;
  }

  state.innerHTML = "thinking...";
  button.disabled = true;
  answer.innerHTML = "";

  var request = new XMLHttpRequest();
  request.onreadystatechange = function() {
    if (request.readyState !== 4) return;
    button.disabled = false;

    if (request.status !== 200) {
      state.innerHTML = "error";
      answer.innerHTML = request.responseText || "Request failed.";
      return;
    }

    try {
      var data = JSON.parse(request.responseText);
      state.innerHTML = "done";
      answer.innerHTML = data.response || "";
    } catch (e) {
      state.innerHTML = "parse error";
      answer.innerHTML = request.responseText;
    }
  };

  request.open("POST", "/ask", true);
  request.setRequestHeader("Content-Type", "application/json");
  request.send(JSON.stringify({ prompt: prompt, model: model }));
}

function setPresetButtons() {
  var buttons = document.querySelectorAll("[data-preset]");
  for (var i = 0; i < buttons.length; i++) {
    buttons[i].onclick = function() {
      document.getElementById("prompt").value = this.getAttribute("data-preset");
    };
  }
}

function toggleNight() {
  if (document.body.className === "night") {
    document.body.className = "";
    document.getElementById("modeButton").innerHTML = "Night";
  } else {
    document.body.className = "night";
    document.getElementById("modeButton").innerHTML = "Day";
  }
}

tick();
setInterval(tick, 1000);
loadStatus();
setInterval(loadStatus, 10000);

document.getElementById("askButton").onclick = askOllama;
document.getElementById("modeButton").onclick = toggleNight;
setPresetButtons();
