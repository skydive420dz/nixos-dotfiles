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

function setCard(id, data) {
  var card = document.getElementById("card-" + id);
  if (!card) return;

  card.className = data.online ? "online" : "offline";
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
  request.send(JSON.stringify({ prompt: prompt }));
}

tick();
setInterval(tick, 1000);
loadStatus();
setInterval(loadStatus, 10000);

document.getElementById("askButton").onclick = askOllama;
