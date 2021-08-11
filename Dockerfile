FROM jenkins/jenkins:lts-jdk11
USER root
RUN apt-get update && apt-get install -y apt-transport-https \
       ca-certificates curl gnupg2 \
       software-properties-common

RUN curl -fsSL https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian \
   $(lsb_release -cs) \
   stable"

# ["Cannot connect to the Docker daemon."](https://github.com/jenkinsci/docker/issues/196#issuecomment-252077192)
CMD DOCKER_GID=$(stat -c '%g' /var/run/docker.sock) && \
   groupadd -for -g ${DOCKER_GID} docker && \
   usermod -aG docker jenkins && \
   bash -c /usr/local/bin/jenkins.sh

# RUN apt-get update && apt-get install -y docker-ce-cli
# RUN bash -c "$(curl -fsSL https://gitee.com/hummerstudio/jenkins-update-center-changer/raw/master/jenkins-update-center-changer.sh)"
# USER jenkins
# RUN jenkins-plugin-cli --plugins "blueocean:1.24.7 docker-workflow:1.26"