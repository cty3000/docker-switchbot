# docker-switchbot

## Reference

- https://github.com/yasuoza/switchbot-ble-go
- https://gist.github.com/mugifly/a29f34df7de8960d72245fcb124513c7

## Setup Bluetooth

https://gist.github.com/mugifly/a29f34df7de8960d72245fcb124513c7

```
$ sudo apt-get install libglib2.0-dev bluez-tools
$ sudo hciconfig hci0 down
$ sudo btmgmt le on
$ sudo hciconfig hci0 up
```

## Create docker image

    $ docker login ghcr.io

    $ docker build -t ghcr.io/cty3000/docker-switchbot:latest .

    $ docker run -dit --rm -p 80:8080 --name switchbot ghcr.io/cty3000/docker-switchbot:latest

    $ docker ps -a

    $ docker stop switchbot

    $ docker push switchbot ghcr.io/cty3000/docker-switchbot:latest
