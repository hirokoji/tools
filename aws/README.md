# Scale Out Checker

## How to use it
Run below script with 
```
./keep_get_scale_out_info.sh <stack-name>
wait time: 5 (s)
--
2019-07-17T08:07:54Z
CPU Utlization Average
1.5850226128769793

ELB Target Group Status
["10.0.1.200","healthy"]
["10.0.0.138","healthy"]

ECS Status
2f35bf12-e947-48dd-a450-65dd715c0e42 RUNNING 10.0.0.138
8007f1fb-a0bd-4b80-9222-a5359ff9afcb RUNNING 10.0.1.200

--
2019-07-17T08:08:02Z
CPU Utlization Average
1.4248709666109725

ELB Target Group Status
["10.0.1.200","healthy"]
["10.0.0.138","healthy"]

ECS Status
2f35bf12-e947-48dd-a450-65dd715c0e42 RUNNING 10.0.0.138
8007f1fb-a0bd-4b80-9222-a5359ff9afcb RUNNING 10.0.1.200
...
# stop this script with Ctrl + c
```

You can also specify wait time like
```
./keep_get_scale_out_info.sh <stack-name> <wait-time (s)>
```
