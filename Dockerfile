FROM swift:5.5.2-xenial

ADD . /code
WORKDIR /code
RUN swift build
