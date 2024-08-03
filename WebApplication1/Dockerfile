FROM ruby:3.1.2-alpine3.16

# ENV BUNDLE_SILENCE_ROOT_WARNING=1 BUNDLE_IGNORE_MESSAGES=1 BUNDLE_GITHUB__HTTPS=1 BUNDLE_FROZEN=1 BUNDLE_PATH=/app/vendor/bundle BUNDLE_BIN=/app/bin BUNDLE_GEMFILE=/app/Gemfile BUNDLE_WITHOUT=development:test DEIS_BUILD_ARGS=1

WORKDIR /app
COPY . /app/

# ENV BUNLDE_PART /gems

RUN apk add --update --virtual \
    postgresql-client \
    build-base \
    libpq-dev \
    gcompat \
    git \
    tzdata \
    && rm -rf /var/cache/apk/*

WORKDIR /app
COPY . /app/

ENV BUNLDE_PART /gems
RUN bundle install

COPY entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh
ENTRYPOINT ["sh", "entrypoint.sh"]
EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]