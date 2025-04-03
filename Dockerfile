FROM ruby:3.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client build-essential

WORKDIR /app

COPY Gemfile* ./
RUN gem install bundler && bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
