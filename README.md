# Docker container for Google Chrome - Tested on Debian

[Google Chrome](https://www.google.com/chrome/) is a cross-platform web browser developed by Google.

## How to use

### Build

Container defaults UID=1000. You can override it at build stage.

```bash
docker build -t chrome --build-arg UID=$(id -u) .
```

### Simple start

```bash
docker run -it --rm \
    -e DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /etc/machine-id:/etc/machine-id \
    -v $XDG_RUNTIME_DIR/pulse:$XDG_RUNTIME_DIR/pulse \
    -v $HOME/.config/pulse/cookie:/tmp/pulse_cookie \
    -v $(pwd)/extensions:/home/developer/extensions \
    --ipc=host \
    --security-opt seccomp=./seccomp-chrome.json \
    chrome
```

### About the image

Based on debian, the container runs `google-chrome` as the user `developer` (default UID=1000).

### Extensions

If you would like to start the browser with extensions on it, download, unzip the files and mount them on `/home/developer/extensions`.

```bash
    -v $(pwd)/extensions:/home/developer/extensions
```

#### eg. Adding uBlock

Go to the [Author's site](https://github.com/gorhill/uBlock/tree/master/dist#install).
Download the zip. Unzip it on its own folder, ie: `./extensions/ublock0.chromium`

## Parameters explained

### X11 display

To be able to render to the host, the container needs access to the X11 socket.

```bash
    -e DISPLAY
    -v /tmp/.X11-unix:/tmp/.X11-unix
```

### Pulseaudio

To be able to send audio to the host, the container needs access to the machine_id, pulse process and pulse cookie.
The container sets PULSE_COOKIE to `/tmp/pulse_cookie`.

```bash
    -v /etc/machine-id:/etc/machine-id
    -v $XDG_RUNTIME_DIR/pulse:$XDG_RUNTIME_DIR/pulse
    -v $HOME/.config/pulse/cookie:/tmp/pulse_cookie
```

Mounting the pulse cookie at `$HOME` causes troubles with `$HOME/.config` ownership.
Either way, you can override it at runtime.

### security-opt

Google Chrome runs in sandboxed mode by default. This requires some kernel capabilities not enabled by default in `docker`.
The best solution to this is to enable those capabilities.
More info:

- [docker docs](https://docs.docker.com/engine/security/seccomp/)
- [seccomp profile for chrome](https://blog.jessfraz.com/post/how-to-use-new-docker-seccomp-profiles/)

As of today [I couldn't make it work](/Dockerfile#L31).
