## Docker Image About SSH

According to related search or investigation, supporting SSHD in docker container have been finished in below two ways:

* `use SSH X11 Forwarding`: use `Dockerfile-sshserver-centos74` or `Dockerfile-sshserver-ubuntu1604` to build a useful docker image.

* `use host-pc related X11-unix and DISPLAY env`: use `docker` related arguments to map **X11-unix** and **DISPLAY** setting.

For examples:
```
$ docker run -ti --rm --network host -v /tmp/.X11-unix/:/tmp/.X11-unix/ \
             --env QT_QPA_PLATFORM=offscreen --env DISPLAY=$DISPLAY:unix \
             centos:7.4.1708 /bin/bash
```

More info can refer to: https://github.com/jessfraz/dockerfiles     :+1:
