[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=jforge_docker-nodejs-unresponsive-app&metric=alert_status)](https://sonarcloud.io/dashboard?id=jforge_docker-nodejs-unresponsive-app)
[![Actions Status](https://github.com/jforge/docker-nodejs-unresponsive-app/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/jforge/docker-nodejs-unresponsive-app/actions?query=workflow%3A"Docker+Image+CI")

# The Unresponsive App

Simple Node.js application NOT responding to any TCP request (except for the HTTP maintenance endpoints).

This application is used as a system test helper for circuit breaker scenarios in real environments.
Although it is meant as an HTTP application, 'unresponsitivity' can as well be tested with any TCP-based protocol (requires Node v6 or higher).

## Startup

Run docker with
```
docker run -p 8080:8095 docker.pkg.github.com/jforge/docker-nodejs-unresponsive-app/unresponsive-webapp:v-1572443441
```

This project matches requirements for a Docker Hub Automated Build, e.g. https://hub.docker.com/r/jforge/unresponsive-app/

A corresponding Docker image can be used e.g. for a AWS EC2 Container deployment to get a public available "unresponsive" application very quickly, e.g. http://<your-ec2-instance-id>.<aws-region>.compute.amazonaws.com/manage/health


## API

Default behaviour is "unresponsive". 
The server then never responds except for the health checks and responsive switch.

HTTP-GET for the switches is just used for convenience and does not follow any REST-oriented approach (sorry).

Available HTTP requests:

|HTTP method |Uri |Response |Description
|:---|:---|---:|:---|
|HEAD|*|200|Returns empty, if head request is not blocked
|OPTIONS|*|200|Returns with options response headers, if not blocked
|GET|/manage/health|200|Returns health and responsivity status
|GET|/api/health|200|Returns health and responsivity status
|GET|/manage/set_responsive|200|Sets the behaviour to "responsive"
|GET|/manage/set_unresponsive|200|Sets the behaviour to "unresponsive"
|GET|/manage/method/head/allow|200|Allows HEAD requests (default)
|GET|/manage/method/head/block|200|Blocks HEAD requests
|GET|/manage/method/options/allow|200|Allows OPTIONS requests (default)
|GET|/manage/method/options/block|200|Blocks OPTIONS requests
|GET, POST|/any/other/uri|none (timeout)|Server does not answer with (default) mode "unresponsive"
|GET, POST|/any/other/uri|200|Server returns always with 200 with mode "responsive"

"Unresponsive" := the server doesn't answer at all, if using

"Allows/Blocks" : = the server allows or blocks requests with the particular http method.


#### Manage Response Payload

The above-mentioned /manage methods answer with OK-health and the current (global) responsivity setting.

The values for the http method HEAD and OPTIONS are displayed accordingly.

```json
{ 
  "status": "OK",
  "responsivity": "unresponsive",
  "HEAD" : "allowed",
  "OPTIONS": "allowed"
}
```


#### Response in "responsive" mode

If the server is set to "responsive", any Uri request but the above-mentioned /api/health and /manage methods 
causes an HTTP 200-OK response together with a payload containing the requested resource.

```json
{
  "status": "OK",
  "requestUri": "/any/other/uri"
}
```
