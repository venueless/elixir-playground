# Load Testing

## Run

### Server

```sh
ulimit -n 30000
MIX_ENV=prod docker-compose up
```

### Load test

```sh
ulimit -n 30000
WS_URL=ws://localhost:8375/ws/world/load-test/ k6 run load-test/flood.js
```
