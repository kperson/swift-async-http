FROM swift:5.5.2-xenial

ENV ECHO_IS_RUNNING=1
ENV TESTING_HOST=host.docker.internal
ADD . /code
WORKDIR /code
RUN swift test
