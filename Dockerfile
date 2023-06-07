FROM ruby:3.1.2

RUN apt-get update -qq \
    && apt-get install -y ca-certificates build-essential tzdata shared-mime-info libmariadb-dev-compat libmariadb-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
