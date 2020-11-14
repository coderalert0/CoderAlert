# for development environment

FROM ruby:2.7

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client vim netcat
RUN yarn install --check-files

RUN mkdir /coder_alert
WORKDIR /coder_alert
COPY Gemfile /coder_alert/Gemfile
COPY Gemfile.lock /coder_alert/Gemfile.lock
RUN bundle install
COPY . /coder_alert

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000