FROM ruby:3.1.2-alpine3.16

# Set environment variables
ENV BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_IGNORE_MESSAGES=1 \
    BUNDLE_GITHUB__HTTPS=1 \
    BUNDLE_FROZEN=1 \
    BUNDLE_PATH=/app/vendor/bundle \
    BUNDLE_BIN=/app/bin \
    BUNDLE_GEMFILE=/app/Gemfile \
    BUNDLE_WITHOUT=development:test \
    DEIS_BUILD_ARGS=1

WORKDIR /app

# Install dependencies and clean up
RUN apk add --update --virtual .build-deps \
    postgresql-client \
    build-base \
    libpq-dev \
    gcompat \
    git \
    tzdata \
    && rm -rf /var/cache/apk/* \
    && apk del .build-deps

# Install Bundler
RUN gem install bundler:2.4.19

# Copy Gemfile and Gemfile.lock separately to leverage Docker cache
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application
COPY . .

# Ensure entrypoint script is executable
COPY entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["sh", "/bin/entrypoint.sh"]
EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
