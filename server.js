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
server.listen(8095);
