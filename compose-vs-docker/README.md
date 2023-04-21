---
tags: docker-compose, for-public, bloc, how-to, notes, locked

---

# How to simplify docker instance executions? or, why you should use compose?

## TLDR;

You should use docker compose for all container that are not meant to be executed only once.

## Notes

## Abstract

This document aims to highlight the many benefits of utilizing Docker Compose as the primary tool for interacting and working with Docker containers. Compose offers a simplified command line interface that enhances productivity and eliminates the need to rely on Docker's interface for every reused container. For one-shot containers, Docker's interface can still be used without any additional overhead. By leveraging Docker Compose in this way, users can efficiently manage and scale containers while streamlining their overall workflow.

## Problem

Developers often face challenges while using Docker's command line interface (CLI) for container management, even when working with single containers or particularly when dealing with complex dependencies between multiple containers. Some of these challenges include:

1. Complexity in Docker CLI: Although Docker CLI is a powerful tool, its commands and syntax can be complex and difficult to remember, especially for those new to containerization.

2. Difficulty in managing complex dependencies: When multiple containers have intricate dependencies and relationships, managing them with Docker CLI becomes more challenging, leading to increased chances of errors and misconfigurations.

3. Dependency on scripts: A common practice to overcome these difficulties is to store 'docker run' commands in scripts, which are then used to reproduce or scale a given setup. This approach, however, adds another layer of complexity and potential points of failure, as well as increasing the maintenance burden for the team.

4. Limited scalability: Relying on scripts to manage containers might work for small-scale projects, but as the number of containers and dependencies grow, this approach becomes harder to maintain and scale effectively.

These challenges make it difficult for developers to efficiently manage their containerized applications using Docker CLI, leading to increased risk of errors, longer development cycles, and reduced productivity.


## Solution

Docker Compose addresses these challenges by allowing the team to define, configure, and run multi-container Docker applications. By using Docker Compose, the team can:

1. Maintain consistent environments: Docker containers encapsulate all dependencies and configurations, ensuring that the application runs consistently across development, testing, and production environments.

2. Simplify dependency management: Each component can have its own container with its specific dependencies, avoiding conflicts and making it easier to manage.

3. Improve scalability: Docker Compose allows for easy addition and configuration of new components as the application grows, making the process of scaling up more streamlined.

4. Accelerate onboarding: Docker Compose enables new team members to quickly set up their development environment by running a single command, reducing the time spent on setup and increasing overall productivity.

By using Docker Compose, the team can overcome the challenges mentioned above, resulting in a smoother development process, more efficient deployment, and better overall application performance.

## Explanation

A `compose.yaml` encapsulates a given docker setup and provides a simple interface to spin up and scale. By just executing `docker compose up` even untrained users are able to start complex setups.

While docker compose also just utilizes the docker API each service specified in a compose.yaml is grouped by a common project reducing name space conflicts on shared systems (docker as root).

Given the following compose file `docker compose up` produces a slightly different result compared to `docker run --rm hello-world`
```yaml=
services:
  hello:
    image: hello-world
```

Comparing both container after their execution with `docker inspect <container_id>` the major differences are the `labels` and `network` settings of the compose run container.

```
[								[
    {								    {
        "Id": "e1f74888b179438d5db3e8d82dd912885a69cda484ab6d |	        "Id": "9c39cf78136f55dbe64fdf530eb01f5bc54a368b2575f9
        "Created": "2023-04-21T20:27:20.573367557Z",	      |	        "Created": "2023-04-21T20:25:54.484047096Z",
        "Path": "/hello",					        "Path": "/hello",
        "Args": [],						        "Args": [],
        "State": {						        "State": {
            "Status": "exited",					            "Status": "exited",
            "Running": false,					            "Running": false,
            "Paused": false,					            "Paused": false,
            "Restarting": false,				            "Restarting": false,
            "OOMKilled": false,					            "OOMKilled": false,
            "Dead": false,					            "Dead": false,
            "Pid": 0,						            "Pid": 0,
            "ExitCode": 0,					            "ExitCode": 0,
            "Error": "",					            "Error": "",
            "StartedAt": "2023-04-21T20:27:21.003610671Z",    |	            "StartedAt": "2023-04-21T20:25:54.936373159Z",
            "FinishedAt": "2023-04-21T20:27:21.003490052Z"    |	            "FinishedAt": "2023-04-21T20:25:54.935944027Z"
        },							        },
        "Image": "sha256:feb5d9fea6a5e9606aa995e879d862b82596	        "Image": "sha256:feb5d9fea6a5e9606aa995e879d862b82596
        "ResolvConfPath": "/var/lib/docker/containers/e1f7488 |	        "ResolvConfPath": "/var/lib/docker/containers/9c39cf7
        "HostnamePath": "/var/lib/docker/containers/e1f74888b |	        "HostnamePath": "/var/lib/docker/containers/9c39cf781
        "HostsPath": "/var/lib/docker/containers/e1f74888b179 |	        "HostsPath": "/var/lib/docker/containers/9c39cf78136f
        "LogPath": "/var/lib/docker/containers/e1f74888b17943 |	        "LogPath": "/var/lib/docker/containers/9c39cf78136f55
        "Name": "/gifted_ardinghelli",			      |	        "Name": "/project-hello-1",
        "RestartCount": 0,					        "RestartCount": 0,
        "Driver": "btrfs",					        "Driver": "btrfs",
        "Platform": "linux",					        "Platform": "linux",
        "MountLabel": "",					        "MountLabel": "",
        "ProcessLabel": "",					        "ProcessLabel": "",
        "AppArmorProfile": "docker-default",			        "AppArmorProfile": "docker-default",
        "ExecIDs": null,					        "ExecIDs": null,
        "HostConfig": {						        "HostConfig": {
            "Binds": null,				      |	            "Binds": [],
            "ContainerIDFile": "",				            "ContainerIDFile": "",
            "LogConfig": {					            "LogConfig": {
                "Type": "json-file",				                "Type": "json-file",
                "Config": {}					                "Config": {}
            },							            },
            "NetworkMode": "default",			      |	            "NetworkMode": "project_default",
            "PortBindings": {},					            "PortBindings": {},
            "RestartPolicy": {					            "RestartPolicy": {
                "Name": "no",				      |	                "Name": "",
                "MaximumRetryCount": 0				                "MaximumRetryCount": 0
            },							            },
            "AutoRemove": false,				            "AutoRemove": false,
            "VolumeDriver": "",					            "VolumeDriver": "",
            "VolumesFrom": null,				            "VolumesFrom": null,
            "CapAdd": null,					            "CapAdd": null,
            "CapDrop": null,					            "CapDrop": null,
            "CgroupnsMode": "private",				            "CgroupnsMode": "private",
            "Dns": [],					      |	            "Dns": null,
            "DnsOptions": [],				      |	            "DnsOptions": null,
            "DnsSearch": [],				      |	            "DnsSearch": null,
            "ExtraHosts": null,				      |	            "ExtraHosts": [],
            "GroupAdd": null,					            "GroupAdd": null,
            "IpcMode": "private",				            "IpcMode": "private",
            "Cgroup": "",					            "Cgroup": "",
            "Links": null,					            "Links": null,
            "OomScoreAdj": 0,					            "OomScoreAdj": 0,
            "PidMode": "",					            "PidMode": "",
            "Privileged": false,				            "Privileged": false,
            "PublishAllPorts": false,				            "PublishAllPorts": false,
            "ReadonlyRootfs": false,				            "ReadonlyRootfs": false,
            "SecurityOpt": null,				            "SecurityOpt": null,
            "UTSMode": "",					            "UTSMode": "",
            "UsernsMode": "",					            "UsernsMode": "",
            "ShmSize": 67108864,				            "ShmSize": 67108864,
            "Runtime": "runc",					            "Runtime": "runc",
            "ConsoleSize": [					            "ConsoleSize": [
                0,						                0,
                0						                0
            ],							            ],
            "Isolation": "",					            "Isolation": "",
            "CpuShares": 0,					            "CpuShares": 0,
            "Memory": 0,					            "Memory": 0,
            "NanoCpus": 0,					            "NanoCpus": 0,
            "CgroupParent": "",					            "CgroupParent": "",
            "BlkioWeight": 0,					            "BlkioWeight": 0,
            "BlkioWeightDevice": [],			      |	            "BlkioWeightDevice": null,
            "BlkioDeviceReadBps": null,				            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,			            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,			            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,			            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,					            "CpuPeriod": 0,
            "CpuQuota": 0,					            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,				            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,				            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",					            "CpusetCpus": "",
            "CpusetMems": "",					            "CpusetMems": "",
            "Devices": [],				      |	            "Devices": null,
            "DeviceCgroupRules": null,				            "DeviceCgroupRules": null,
            "DeviceRequests": null,				            "DeviceRequests": null,
            "KernelMemory": 0,					            "KernelMemory": 0,
            "KernelMemoryTCP": 0,				            "KernelMemoryTCP": 0,
            "MemoryReservation": 0,				            "MemoryReservation": 0,
            "MemorySwap": 0,					            "MemorySwap": 0,
            "MemorySwappiness": null,				            "MemorySwappiness": null,
            "OomKillDisable": null,				            "OomKillDisable": null,
            "PidsLimit": null,					            "PidsLimit": null,
            "Ulimits": null,					            "Ulimits": null,
            "CpuCount": 0,					            "CpuCount": 0,
            "CpuPercent": 0,					            "CpuPercent": 0,
            "IOMaximumIOps": 0,					            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,				            "IOMaximumBandwidth": 0,
            "MaskedPaths": [					            "MaskedPaths": [
                "/proc/asound",					                "/proc/asound",
                "/proc/acpi",					                "/proc/acpi",
                "/proc/kcore",					                "/proc/kcore",
                "/proc/keys",					                "/proc/keys",
                "/proc/latency_stats",				                "/proc/latency_stats",
                "/proc/timer_list",				                "/proc/timer_list",
                "/proc/timer_stats",				                "/proc/timer_stats",
                "/proc/sched_debug",				                "/proc/sched_debug",
                "/proc/scsi",					                "/proc/scsi",
                "/sys/firmware"					                "/sys/firmware"
            ],							            ],
            "ReadonlyPaths": [					            "ReadonlyPaths": [
                "/proc/bus",					                "/proc/bus",
                "/proc/fs",					                "/proc/fs",
                "/proc/irq",					                "/proc/irq",
                "/proc/sys",					                "/proc/sys",
                "/proc/sysrq-trigger"				                "/proc/sysrq-trigger"
            ]							            ]
        },							        },
        "GraphDriver": {					        "GraphDriver": {
            "Data": null,					            "Data": null,
            "Name": "btrfs"					            "Name": "btrfs"
        },							        },
        "Mounts": [],						        "Mounts": [],
        "Config": {						        "Config": {
            "Hostname": "e1f74888b179",			      |	            "Hostname": "9c39cf78136f",
            "Domainname": "",					            "Domainname": "",
            "User": "",						            "User": "",
            "AttachStdin": false,				            "AttachStdin": false,
            "AttachStdout": true,				            "AttachStdout": true,
            "AttachStderr": true,				            "AttachStderr": true,
            "Tty": false,					            "Tty": false,
            "OpenStdin": false,					            "OpenStdin": false,
            "StdinOnce": false,					            "StdinOnce": false,
            "Env": [						            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbi	                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbi
            ],							            ],
            "Cmd": [						            "Cmd": [
                "/hello"					                "/hello"
            ],							            ],
            "Image": "hello-world",				            "Image": "hello-world",
            "Volumes": null,					            "Volumes": null,
            "WorkingDir": "",					            "WorkingDir": "",
            "Entrypoint": null,					            "Entrypoint": null,
            "OnBuild": null,					            "OnBuild": null,
            "Labels": {}				      |	            "Labels": {
							      >	                "com.docker.compose.config-hash": "0d3df12ac3
							      >	                "com.docker.compose.container-number": "1",
							      >	                "com.docker.compose.depends_on": "",
							      >	                "com.docker.compose.oneoff": "False",
							      >	                "com.docker.compose.project": "project",
							      >	                "com.docker.compose.project.config_files": "/
							      >	                "com.docker.compose.project.working_dir": "/p
							      >	                "com.docker.compose.service": "hello",
							      >	                "com.docker.compose.version": "2.9.0"
							      >	            }
        },							        },
        "NetworkSettings": {					        "NetworkSettings": {
            "Bridge": "",					            "Bridge": "",
            "SandboxID": "fd5bdbe77d43eb22ca1b839f1ed271c1600 |	            "SandboxID": "95adfc4317febd01bdab3ce2684942dab3f
            "HairpinMode": false,				            "HairpinMode": false,
            "LinkLocalIPv6Address": "",				            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,			            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {},					            "Ports": {},
            "SandboxKey": "/var/run/docker/netns/fd5bdbe77d43 |	            "SandboxKey": "/var/run/docker/netns/95adfc4317fe
            "SecondaryIPAddresses": null,			            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,			            "SecondaryIPv6Addresses": null,
            "EndpointID": "",					            "EndpointID": "",
            "Gateway": "",					            "Gateway": "",
            "GlobalIPv6Address": "",				            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,				            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "",					            "IPAddress": "",
            "IPPrefixLen": 0,					            "IPPrefixLen": 0,
            "IPv6Gateway": "",					            "IPv6Gateway": "",
            "MacAddress": "",					            "MacAddress": "",
            "Networks": {					            "Networks": {
                "bridge": {				      |	                "project_default": {
                    "IPAMConfig": null,				                    "IPAMConfig": null,
                    "Links": null,				                    "Links": null,
                    "Aliases": null,			      |	                    "Aliases": [
                    "NetworkID": "2db9171f1cfcd12584866608662 |	                        "project-hello-1",
							      >	                        "hello",
							      >	                        "9c39cf78136f"
							      >	                    ],
							      >	                    "NetworkID": "5b088a10bf7c9d7413e5c40c7f0
                    "EndpointID": "",				                    "EndpointID": "",
                    "Gateway": "",				                    "Gateway": "",
                    "IPAddress": "",				                    "IPAddress": "",
                    "IPPrefixLen": 0,				                    "IPPrefixLen": 0,
                    "IPv6Gateway": "",				                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",			                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,			                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "",				                    "MacAddress": "",
                    "DriverOpts": null				                    "DriverOpts": null
                }						                }
            }							            }
        }							        }
    }								    }
]								]
```

First let's compare the network settings. While a container started with `docker run` joins the share default bridge network. A container with `docker compose up` joins a dedicated network with multiple aliases. To replicate this behaviour you have to create a network and you have to specify the network-alias as shown:

1. `docker network create prject-default`
2. `docker run --network-alias="hello" --network-alias="project-hello-1" --network="project" hello-world`

Secondly let's take a look at the labels.

```
"Labels": {
    "com.docker.compose.config-hash": "0d3df12ac3c67c5e1b09211c5224d70e73795b9a6cf03b135cc902195436a7d7",
    "com.docker.compose.container-number": "1",
    "com.docker.compose.depends_on": "",
    "com.docker.compose.oneoff": "False",
    "com.docker.compose.project": "project",
    "com.docker.compose.project.config_files": "/project/compose.yaml",
    "com.docker.compose.project.working_dir": "/project",
    "com.docker.compose.service": "hello",
    "com.docker.compose.version": "2.9.0"
}
```

Compose uses this labels to differentiate between container started with compose. Each container is assigned a project name by the key `com.docker.compose.project`. By changing the project name you can spin up one compose.yaml multiple times. Compose keeps also track of the config's hash. This hash changes of the compose.yaml changes. To also replicate this behaviour you have also to add the following `--labels` to your `docker run` command.

```
docker run\
  --network-alias="hello"\
  --network-alias="project-hello-1"\
  --network="project"\
  --label "com.docker.compose.config-hash": "0d3df12ac3c67c5e1b09211c5224d70e73795b9a6cf03b135cc902195436a7d7"\
  --label "com.docker.compose.container-number": "1"\
  --label "com.docker.compose.depends_on": ""\
  --label "com.docker.compose.oneoff": "False"\
  --label "com.docker.compose.project": "project"\
  --label "com.docker.compose.project.config_files": "/project/compose.yaml"\
  --label "com.docker.compose.project.working_dir": "/project"\
  --label "com.docker.compose.service": "hello"\
  --label "com.docker.compose.version": "2.9.0"\
  hello-world
```

Also don't forget that compose cleans up created containers, networks and optionally volumes with `docker compose down [--volumes]`.

Running containers without compose is only encouraged if containers are run only once and all those features are not needed or if the setup is so complex that compose cannot provide any assistance.

## References

[Compose-Overview]: <https://docs.docker.com/compose/> "Docs Docker Compose overview"
[Compose-CLI]: <https://docs.docker.com/compose/reference/> "Docs Docker Compose CLI"
[Compose-File]: <https://docs.docker.com/compose/compose-file/> "Docs Docker Compose-file specifitaction"
