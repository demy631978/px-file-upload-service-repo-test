FROM ruby:3.1.2-alpine3.16

# Set environment variables
ENV NODE_ENV=development \
    BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_IGNORE_MESSAGES=1 \
    BUNDLE_GITHUB__HTTPS=1 \
    BUNDLE_FROZEN=1 \
    BUNDLE_PATH=/app/vendor/bundle \
    BUNDLE_BIN=/app/bin \
    BUNDLE_GEMFILE=/app/Gemfile \
    BUNDLE_WITHOUT=development:test \
    DEIS_BUILD_ARGS=1

# Set working directory
WORKDIR /app

# Copy application code
COPY . /app/

# Install dependencies
RUN apk update && apk add --no-cache \
    build-base \
    postgresql-dev \
    gcompat \
    git \
    tzdata \
    && rm -rf /var/cache/apk/*

# Install Ruby gems
RUN bundle install

# Set up entrypoint
COPY entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh

# Expose port
EXPOSE 3000

# Set entrypoint and default command
ENTRYPOINT ["sh", "/bin/entrypoint.sh"]
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
