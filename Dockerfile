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
ENV CREDENTIALS=drUZJ58TRQx8C+0/u5YrHiaGeG80c3gUozY3SnW5sB3Ektiyeyc4Jd1d0vZLG3bWkWnGAit0dzRn6YNBskpkEZllxPY/P7JcBkToQTVumZ0vlYapkwTl9IBnV6p1epKdTwF10UX4SddA4tiMFxP+M12BoVScY9vhV7dc+SScM8R46D/BEN41T3FLpsMFtF9P2N7SMNSr+8REA2wmvOfGE4Uo0yMuq0EMCVYnFnuJ3eho0mzsGpTk7nBU+9Dxcot8XIVgnVYzDEY+x8oBLmSatKZ/1SYj0hkipGMlfrsNn3wlOa/h+VRCCSyYzoBV5oC9cLsv1kesFdKNK85HEbugY2MOMLRfxbFDZRdJV4BQAQBWJMLlP6t7lTwa35agTwMDf3LKUFNmIui0mN+yxKg8adGKCJTYxMImjuwiieD1dQTKLfQLLTF+GfKP8ZSvTK+HMxlFfGnpqN7dXzU2UFr4gm/T1xr3CZXFrDH+zF31NjmU9HtS81e6ND+GiRoO7wFfCWF7kLP4ufoZdefEEaIbJiahz4xNhIR7iXHY4ieTYdlMqsnT5f2kSP5VWmdBLbD6NFyxv998N2EC+ccFjppnFZJos2rxqxakZMosk5drK12R89U47DMXSOVJxWAXl7RvtmIEN1pdC0RdIR4BMO0/332RCXOdh0vzTCxBKQ1hokToq393X1t7IF9P4ROHMP881KPtNEb+WCd4vmHMhhIpifyP2jCpUST+jdYOLkgrMTvRrhKqPOmXarISD9Ny3xbjKeTcoNNl+gZPJ/lgBcX6DHqds5QMMtAiDuInAnoqnKYtFvi3k5sl418ScxfXiO8Gs8aZmaXJij7wf3+JxEH1OJEKKbOBd4kHH+rSnOieDHIhuqeMzQ==--5mXxDXgICSGtMSFS--WB36E+ntC0wwuxF0Nqocnw==

