FROM python:3.7-slim-buster

WORKDIR /app
COPY . .

RUN sed -i "s#deb http://deb.debian.org/debian buster main#deb http://deb.debian.org/debian buster main contrib non-free#g" /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
      # Firefox dependencies
      libgtk-3-0 libdbus-glib-1-2 libx11-xcb1 libxt6 \
      # Firefox downlader dependencies
      bzip2 wget gcc g++ curl \
    # Install newesst firefox
    && wget -q -O - "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64"  | tar -xj -C /opt \
    && ln -s /opt/firefox/firefox /usr/bin/ \
    && cd InstaPy \
    && python setup.py install \
    && cd .. \
    && pip install -r requirements.txt \
    && webdrivermanager gecko \
    && apt-get purge -y --auto-remove gcc g++ bzip2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/requirements.txt
