FROM swift:5.5.2-xenial

ENV ECHO_IS_RUNNING=1
ADD . /code
WORKDIR /code
RUN swift build
