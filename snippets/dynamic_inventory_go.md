---
date: "2024-07-27T15:57:35+02:00"
draft: false
title: dynamic inventory in go
---

[Dynamic inventories
Ansible](/Notes/posts/ansible/Ansible#dynamic-inverntories)

``` go
package main

import (
    "encoding/json"
    "fmt"
    "os"
)


// Represents  hosts and variables.
type Group struct {
    Hosts []string          `json:"hosts"`
    Vars  map[string]string `json:"vars"`
}

func main() {
    inventory:= Group{
            Hosts: []string{"host1", "host2"},
            Vars: map[string]string{
                "var1": "value1",
                "var2": "value2",
            },
        }

    output, err := json.MarshalIndent(inventory, "", "  ")
    if err != nil {
        fmt.Println("Error:", err)
        os.Exit(1)
    }

    fmt.Println(string(output))
}
```
