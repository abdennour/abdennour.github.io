FROM ruby:2.2.9

WORKDIR /app

COPY ./Gemfile .
COPY ./Gemfile.lock .
RUN bundle update
COPY . .

CMD ["bundle", "exec", "jekyll", "serve"]

EXPOSE 4000