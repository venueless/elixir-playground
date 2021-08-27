# Load test results

## 2021-08-27 docker compose on single CPX51

### Run 1

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

### Run 2

- changed silent users from 90% to 99%

```
checks..................: 92.82%  ✓ 193013       ✗ 14913
✓ { ping:no-timeout }...: 99.09%  ✓ 104513       ✗ 959
concurrent_clients......: 10014   41.526899/s
✗ connection_errors.......: 20      0.082938/s
data_received...........: 1.7 GB  7.0 MB/s
data_sent...............: 347 MB  1.4 MB/s
iteration_duration......: avg=7.94s    min=5.05s    med=6.44s  max=42.55s p(90)=9.72s p(95)=12.29s
iterations..............: 48      0.19905/s
ping_time...............: avg=630.33ms min=0s       med=93ms   max=35.91s p(90)=1.34s p(95)=2.57s
request_response_time...: avg=746.11ms min=0s       med=319ms  max=40.45s p(90)=1.63s p(95)=2.92s
vus.....................: 1       min=1          max=10099
vus_max.................: 15000   min=15000      max=15000
ws_connecting...........: avg=428.14ms min=852.41µs med=1.75ms max=18.89s p(90)=1.14s p(95)=2.15s
ws_msgs_received........: 8764750 36346.404153/s
ws_msgs_sent............: 4543232 18840.257444/s
ws_session_duration.....: avg=42.5s    min=42.5s    med=42.5s  max=42.5s  p(90)=42.5s p(95)=42.5s
ws_sessions.............: 10066   41.742537/s
```
