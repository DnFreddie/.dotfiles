---
date: "2024-08-30T12:41:16+02:00"
draft: false
title: Cloud watch configuration json
---

*Basic cofniguration to watch the ec2_instance*

``` json
{
    "agent": {
            "metrics_collection_interval": 60,
            "region": "eu-west-1",
            "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log",
            "run_as_user": "root"
    },
    "metrics": {
            "metrics_collected": {
                    "disk": {
                            "measurement": [
                                    "used_percent"
                            ],
                            "metrics_collection_interval": 60,
                            "resources": [
                                    "*"
                            ]
                    },
                    "mem": {
                            "measurement": [
                                    "mem_used_percent"
                            ],
                            "metrics_collection_interval": 60
                    }
            }
    }
}
```
