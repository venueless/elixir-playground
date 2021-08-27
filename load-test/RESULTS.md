# Load test results

## 2021-08-27 docker compose on single CPX51

```
checks..................: 79.38%   ✓ 59508        ✗ 15454  
✗ { ping:no-timeout }...: 94.27%   ✓ 37726        ✗ 2293   
concurrent_clients......: 5044     30.120054/s
data_received...........: 2.1 GB   13 MB/s
data_sent...............: 448 MB   2.7 MB/s
iteration_duration......: avg=6.11s    min=5.08s    med=6.07s  max=8.18s  p(90)=7.37s  p(95)=7.78s
iterations..............: 5        0.029857/s
ping_time...............: avg=2.67s    min=0s       med=384ms  max=28.57s p(90)=10.05s p(95)=10.25s
request_response_time...: avg=2.6s     min=0s       med=781ms  max=35.16s p(90)=8.16s  p(95)=10.32s
vus.....................: 3        min=3          max=5033
vus_max.................: 10000    min=10000      max=10000
ws_connecting...........: avg=241.55ms min=841.48µs med=28.2ms max=8.31s  p(90)=1.04s  p(95)=1.12s
ws_msgs_received........: 11134543 66489.498649/s
ws_msgs_sent............: 6006093  35865.155167/s
ws_sessions.............: 5049     30.149911/s
```
