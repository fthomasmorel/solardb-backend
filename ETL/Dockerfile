FROM ruby
MAINTAINER FTM version: 1.0

RUN gem install parseconfig
RUN gem install mongo
RUN gem install json

RUN mkdir /var/solardb
COPY ./ /var/solardb/

ENTRYPOINT ruby /var/solardb/coordinator.rb
