FROM ruby:3.0.0
ENV http_proxy=http://172.17.0.1:3129
RUN mkdir -p /opt/application
ADD . /opt/application/
WORKDIR /opt/application
RUN bundle install
EXPOSE 4567

CMD ["bundle", "exec", "rackup","--host", "0.0.0.0", "-p", "4567"]