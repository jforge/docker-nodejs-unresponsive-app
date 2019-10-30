'use strict';
const http = require('http');
var isResponsive = false;

function respond200Json(res, info) {
    res.writeHead(200, {'Content-Type': 'application/json'});
    var responsivity = isResponsive ? "responsive" : "unresponsive";

    if (info) {
        res.end('{ "status" : "OK", ' + info + ' }');
    } else {
        res.end('{ "status" : "OK", "responsivity" : "' + responsivity + '" }');
    }

}

const server = http.createServer((req, res) => {
    if (req.url === '/manage/health' || req.url === '/api/health') {
        respond200Json(res);
    }

    if (req.method === 'GET') {
        if (req.url === '/manage/set_responsive') {
            isResponsive = true;
            respond200Json(res);
        } else if (req.url === '/manage/set_unresponsive') {
            isResponsive = false;
            respond200Json(res);
        }
    }

    if (isResponsive) {
        respond200Json(res, '"requestUri" : "' + req.url + '"');
    }

});

// Handle clientError to prevent Node from closing sockets on non-HTTP requests
server.on('clientError', function (err, socket) {
    // Only if App is set to responsive, kill the socket.
    if (isResponsive) socket.destroy('Invalid request!');
});

server.listen(8095, function () {
    console.log('Server listening on Port ' + this.address().port + '...')
});
