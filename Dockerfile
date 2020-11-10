FROM ruby:2.7.1

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client vim supervisor netcat
RUN yarn install --check-files

RUN mkdir /coder_alert
WORKDIR /coder_alert
COPY Gemfile /coder_alert/Gemfile
COPY Gemfile.lock /coder_alert/Gemfile.lock
RUN bundle install
COPY . /coder_alert

RUN rails webpacker:install
RUN rails action_text:install
RUN cp supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
ENV DATABASE_HOST=db
ENV RAILS_ENV=development
ENV DATABASE_USER=postgres
ENV DATABASE_PASSWORD=password


