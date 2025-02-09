var xhttp = new XMLHttpRequest();
xhttp.open("GET", "xml/shops.xml", true);

xhttp.onreadystatechange = function () {
  if (this.readyState == 4 && this.status == 200) {  
    document.getElementById("shop").innerHTML = this.responseText;
  }
};
xhttp.send()