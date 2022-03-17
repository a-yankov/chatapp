<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<p id="connectionStatus"></p>
Username: <input id="username"><br>
Message: <input id="messageField"><button onclick="send()">send</button>

<div id="messages">
</div>

<script>
    const webSocket = new WebSocket('ws://93.183.170.31:8080/app/chat-endpoint');

    webSocket.onerror = function (event) {
        onError(event)
    };
    webSocket.onopen = function (event) {
        onOpen(event)
    };
    webSocket.onmessage = function (event) {
        onMessage(event)
    };

    function onMessage(event) {
        const eventPayload = JSON.parse(event.data);
        console.log(eventPayload);
        var p = document.createElement("p");
        p.innerText = eventPayload.user + ": " + eventPayload.message;

        document.getElementById("messages").appendChild(p);
        //document.getElementById('messages').innerHTML +=
        //    `<tr><td>${eventPayload.stock}</td><td>${eventPayload.price} $</td></tr>`;
    }

    function onOpen(event) {
        document.getElementById('connectionStatus').innerHTML = 'Connection established';
    }

    function onError(event) {
        alert('An error occurred:' + event.data);
    }

    function send() {
        const payload = {
            'message': document.getElementById('messageField').value,
            'user': document.getElementById('username').value,
            'timestamp': Date.now()
        };

        if (payload.message !== ""){
            webSocket.send(JSON.stringify(payload));
            document.getElementById('messageField').value = '';
        }
    }

    // Get the input field
    var input = document.getElementById("messageField");

    // Execute a function when the user releases a key on the keyboard
    input.addEventListener("keyup", function(event) {
        // Number 13 is the "Enter" key on the keyboard
        if (event.keyCode === 13) {
            // Cancel the default action, if needed
            event.preventDefault();
            // Trigger the button element with a click
            send();
        }
    });
</script>
</body>
</html>
