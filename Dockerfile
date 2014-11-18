FROM clojure:latest
MAINTAINER Daniel Canas <daniel_76@yahoo.com>
ENV REFRESHED_AT 2014-11-14

WORKDIR /opt/bifrost
RUN apt-get -qq update \
    && apt-get -yqq install git \
    && git clone -q https://github.com/uswitch/bifrost.git /opt/bifrost \
    && lein deps

RUN mv "$(lein uberjar | sed -n 's/^Created \(.*standalone\.jar\)/\1/p')" bifrost-standalone.jar

VOLUME ["/opt/bifrost/etc"]

CMD ["java", "-jar", "bifrost-standalone.jar", "--config", "/opt/bifrost/etc/config.edn"]
