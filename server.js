'use strict'
const http = require('http')
const responseHeaders = {'Content-Type': 'application/json'}
let isResponsive = false
let isHeadRequestAllowed = true
let isOptionsRequestAllowed = true

function respond200ResponsivityStatus(res) {
    res.writeHead(200, responseHeaders)
    let responsivity = isResponsive ? "responsive" : "unresponsive"
    let headMethodMode = isHeadRequestAllowed ? "allowed" : "blocked"
    let optionsMethodMode = isOptionsRequestAllowed ? "allowed" : "blocked"
    res.end(`{ "status" : "OK", "responsivity" : "${responsivity}", "HEAD" : "${headMethodMode}", "OPTIONS": "${optionsMethodMode}" }`)
}

function respond200ReflectUri(res, info) {
    res.writeHead(200, responseHeaders)
    res.end(`{ "status" : "OK", ${info} }`)
}

function respondHead200(req, res) {
    console.log('HEAD request for ' + req.url)
    res.writeHead(200, responseHeaders)
    res.end()
}

function respondOptions200(req, res) {
    console.log('OPTIONS request for ' + req.url)
    const responseHeaderOptions = {
        'Allow': 'GET,POST,HEAD,OPTIONS',
        'Access-Control-Allow-Methods': 'GET,POST,HEAD,OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type'
    }
    res.writeHead(200, responseHeaderOptions)
    res.end()
}

const server = http.createServer((req, res) => {

    if (req.method == 'HEAD') {
        if (isHeadRequestAllowed) {
            respondHead200(req, res)
        }
        return
    } else if (req.method == 'OPTIONS') {
        if (isOptionsRequestAllowed) {
            respondOptions200(req, res)
        }
        return
    } else if (req.url === '/manage/health' || req.url === '/api/health') {
        // response for any method but HEAD
        respond200ResponsivityStatus(res)
        return
    }

    if (req.method === 'GET') {
        let isManagementUrl = true
        switch (req.url) {
            case "/manage/set_responsive":
                isResponsive = true
                break;
            case "/manage/set_unresponsive":
                isResponsive = false
                break;
            case "/manage/method/head/allow":
                isHeadRequestAllowed = true
                break;
            case "/manage/method/head/block":
                isHeadRequestAllowed = false
                break;
            case "/manage/method/options/allow":
                isOptionsRequestAllowed = true
                break;
            case "/manage/method/options/block":
                isOptionsRequestAllowed = false
                break;
            default:
                isManagementUrl = false
        }
        if (isManagementUrl) {
            respond200ResponsivityStatus(res)
            return
        }
    }

    if (isResponsive) {
        respond200ReflectUri(res, `"requestUri" : "${req.url}"`)
    }

})

// Handle clientError to prevent Node from closing sockets on non-HTTP requests
server.on('clientError', function (err, socket) {
    // kill the socket only, if the app is set to responsive
    if (isResponsive) socket.destroy('Invalid request!')
})

server.listen(8095, function () {
    console.log(`Server listening on Port ${this.address().port}...`)
})
