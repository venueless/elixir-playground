# Load test results

## 2021-08-28 docker compose gunicorn on single CCX62

### Run 1

- joining clients: 33.3/s
- mean time to chat message: 15s
- silent users: 99%

```
checks..................: 79.39%   ✓ 423768       ✗ 109957
✗ { ping:no-timeout }...: 94.98%   ✓ 260408       ✗ 13748  
concurrent_clients......: 14788    27.558058/s
✗ connection_errors.......: 1466     2.731952/s
data_received...........: 5.8 GB   11 MB/s
data_sent...............: 1.2 GB   2.2 MB/s
iteration_duration......: avg=2m31s    min=5.03s    med=2m6s    max=7m10s p(90)=5m52s  p(95)=6m16s
iterations..............: 179      0.333574/s
ping_time...............: avg=2.58s    min=0s       med=355ms   max=1m55s p(90)=9.91s  p(95)=10.16s
request_response_time...: avg=4.69s    min=0s       med=1.82s   max=1m56s p(90)=13.52s p(95)=20.26s
vus.....................: 1        min=1          max=14799
vus_max.................: 30000    min=30000      max=30000
ws_connecting...........: avg=369.63ms min=607.27µs med=12.67ms max=30s   p(90)=1.05s  p(95)=1.48s
ws_msgs_received........: 29143339 54309.83454/s
ws_msgs_sent............: 15601016 29073.147645/s
ws_session_duration.....: avg=3m53s    min=43.17s   med=4m7s    max=7m10s p(90)=6m13s  p(95)=6m26s
ws_sessions.............: 14968    27.893496/s
```

### Run 2

- joining clients: 100/s
- mean time to chat message: 15s
- silent users: 99.9%

```
checks..................: 83.01%   ✓ 728374       ✗ 149003
✗ { ping:no-timeout }...: 94.75%   ✓ 433911       ✗ 24028  
concurrent_clients......: 30399    83.862481/s
✗ connection_errors.......: 48       0.132419/s
data_received...........: 2.3 GB   6.4 MB/s
data_sent...............: 427 MB   1.2 MB/s
iteration_duration......: avg=42.98s   min=6.03s    med=8.13s  max=3m57s  p(90)=2m44s p(95)=3m31s
iterations..............: 23       0.063451/s
ping_time...............: avg=2.02s    min=0s       med=154ms  max=1m5s   p(90)=8.56s p(95)=10s   
request_response_time...: avg=2.74s    min=0s       med=882ms  max=52.79s p(90)=8.53s p(95)=11.57s
vus.....................: 1        min=1          max=30399
vus_max.................: 60000    min=60000      max=60000
ws_connecting...........: avg=213.25ms min=552.35µs med=1.08ms max=30s    p(90)=1s    p(95)=1.1s  
ws_msgs_received........: 10026316 27659.848399/s
ws_msgs_sent............: 5510428  15201.75537/s
ws_session_duration.....: avg=2m41s    min=1m17s    med=3m1s   max=3m57s  p(90)=3m48s p(95)=3m52s
ws_sessions.............: 30422    83.925931/s
```

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
