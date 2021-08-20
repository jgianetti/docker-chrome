#
# https://github.com/jgianetti/docker-chrome/
#

FROM debian:buster-slim

ARG UID
ENV UID=${UID:-1000} \
    PULSE_COOKIE=/tmp/pulse_cookie

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        ca-certificates \
        wget \
        pulseaudio-utils \
    && wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome64.deb \
    && apt install -y ./chrome64.deb \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash --uid $UID developer


COPY ./entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

USER developer

ENTRYPOINT ["entrypoint.sh"]
CMD ["google-chrome", "--no-sandbox"]

# @todo: fix seccomp-chrome.json
# --no-sandbox is insecure but seccomp-chrome.json is not working right now
