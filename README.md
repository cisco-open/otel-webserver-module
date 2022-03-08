# otel-webserver-module

The OTEL webserver module comprises only Apache webserver module currently. Further support for Nginx webserver would be added in future.

## Apache Webserver Module

The Apache Module enables tracing of incoming requests to the server by injecting instrumentation into the Apache server at runtime. Along with the above mentioned capability, the Apache web server module has capabilities to capture the response time of many modules (including mod_proxy) involved in an incoming request, thereby including the hierarchical time consumption by each module.

### Module wise Monitoring

Monitoring individual modules is crucial to the instrumentation of Apache web server. As the HTTP request flows through individual modules, delay in execution or errors might occur at any of the modules involved in the request. To identify the root cause of any delay or errors in request processing, module wise information (such as response time of individual modules) would enhance the debuggability of the Apache web server.

#### Some of the Modules monitored by Apache Module
| Some of the use cases handled by Apache Module | Module used |
| ---------------------------------------------- | ----------- |
| Monitor each module in the login phase         | mod_sso     |
| Monitor php application running on the same machine | mod_php|
| Monitor requests to remote server              | mod_dav     |
| Monitor reverse proxy requests                 | mod_proxy   |
| Monitor the reverse proxy load balancer        | mod_proxy_balancer |

### Build and Installation

## Build and Install directly

## Manual build and Installation

### Maintainers
* [Kumar Pratyush](https://github.com/kpratyus), Cisco
* [Lakshay Gaba](https://github.com/lakshay141), Cisco
* [Debajit Das] (https://github.com/DebajitDas), Cisco

