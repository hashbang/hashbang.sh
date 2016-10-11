
window.onload = function(){
    console.log("loaded")
    window.location="#!"
    var link = document.createElement("link");
    link.type = "image/png";
    link.rel = "icon";
    link.href = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQAQAAAAA3iMLMAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QAAd2KE6QAAAAYSURBVAjXY2CAAck+EKp/B0II9gMoGwYA4+MJkeae/NUAAAAldEVYdGRhdGU6Y3JlYXRlADIwMTQtMDUtMTdUMTM6MzI6MTMtMDQ6MDB7pieOAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDE0LTA1LTE3VDEzOjMxOjQ4LTA0OjAwqyt+rwAAAABJRU5ErkJggg==";
    document.getElementsByTagName("head")[0].appendChild(link);
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
