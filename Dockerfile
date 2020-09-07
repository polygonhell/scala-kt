FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y bash curl gnupg apt-utils openjdk-11-jdk openjdk-11-jre

RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add

RUN apt-get update
RUN apt-get install -y bash sbt

# Pick Id's valid for openshift
RUN groupadd -g 1000620001 user
RUN useradd -l -r -u 1000620001 -g user -m -d /home/user user
# RUN mkdir -p /home/user & chown user /home/user & chgrp user /home/user
RUN mkdir /project ; chown user /project ; chgrp user /project

# useful utilities for debugging
RUN apt-get install -y vim


USER user
WORKDIR /home/user
# Run SBT once to download the binaries - then delete the directories that creates
RUN touch build.sbt
RUN sbt compile
RUN rm build.sbt ; rm -rf target ; rm -rf project


ENTRYPOINT [ "bash" ]