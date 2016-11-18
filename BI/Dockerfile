FROM ruby
MAINTAINER FTM version: 1.0

RUN gem install sinatra-cross_origin
RUN gem install parseconfig
RUN gem install bson_ext
RUN gem install sinatra
RUN gem install mongo
RUN gem install json

RUN mkdir /var/solardb
COPY ./ /var/solardb/

ENTRYPOINT ruby /var/solardb/server.rb
