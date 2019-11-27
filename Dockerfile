FROM ruby:2.6

RUN gem install bundler

ENV APP_HOME /project
WORKDIR $APP_HOME
RUN cd $APP_HOME

COPY Gemfile* $APP_HOME/
RUN bundle install --with=$buildwith --without=$buildwithout

EXPOSE 4000
