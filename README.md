# bifrost-docker

Docker file for [bifrost](https://github.com/uswitch/bifrost). A Kafka to S3 archiver without the Hadoop dependencies.

## Create docker image
    docker build -t <user>/bifrost .

## Run container
The image allows `/opt/bifrost/etc` to be mounted from an external volume. So you can take the example config file, add your AWS credentials and zookeeper info, drop it into your current directory and run the container.

    docker run --rm -it -v $PWD/config.edn:/opt/bifrost/etc/config.edn <user>/bifrost

### Config.edn

```clojure
{:consumer-properties {"zookeeper.connect"  "zk:2181"
                       "group.id"           "bifrost"
                       "auto.offset.reset"  "smallest" ; we explicitly commit offsets once files have
                                                       ; been uploaded to s3 so no need for auto commit
                       "auto.commit.enable" "false"}
 :topic-blacklist     #{"sometopic"} ; topics from :topic-blacklist will not be backed up
 :topic-whitelist     nil ; if :topic-whitelist is defined, only topics
                          ; from the whitelist will be backed up. The
                          ; value should be a set of strings.
 :rotation-interval   300000 ; milliseconds
 :credentials         {:access-key "akey"
                       :secret-key "very-secret"
                       :endpoint "s3.amazonaws.com"}
 :uploaders-n         4 ; max-number of concurrent threads uploading to S3
 :bucket              "recsci-kafka"
 :riemann-host        nil ; if :riemann-host is set, metrics will be pushed to that host
 }
```
