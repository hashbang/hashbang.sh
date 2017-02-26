window.onload = function(){
    console.log("loaded")
    window.location="#!"

    var sourceEl = document.getElementById("view-source")
    sourceEl.removeAttribute("href");
    sourceEl.onclick = function(){
        var client = new XMLHttpRequest();
        client.open('GET', 'http://localhost:8080/');
        client.onreadystatechange = function() {
            console.log(client.responseText)
            var div = document.createElement("div");
            var sourceText = document.createTextNode(client.responseText)
            div.appendChild(sourceText)
            div.id = "source"
            document.getElementsByTagName("html")[0].appendChild(div);
        }
        client.send();
    }
}
