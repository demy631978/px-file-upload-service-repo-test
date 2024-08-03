FROM ruby:3.1.2-alpine3.16

# Set environment variables
ENV BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_IGNORE_MESSAGES=1 \
    BUNDLE_GITHUB__HTTPS=1 \
    BUNDLE_FROZEN=1 \
    BUNDLE_PATH=/app/vendor/bundle \
    BUNDLE_BIN=/app/bin \
    BUNDLE_GEMFILE=/app/Gemfile \
    BUNDLE_WITHOUT=development:test

# Set working directory
WORKDIR /app

# Install dependencies
RUN apk add --update --virtual \
    postgresql-client \
    build-base \
    libpq-dev \
    gcompat \
    git \
    tzdata \
    && rm -rf /var/cache/apk/*

# Copy application code
COPY . /app/

# Install Ruby gems
RUN bundle install

# Set entrypoint
COPY entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh
ENTRYPOINT ["sh", "entrypoint.sh"]

# Expose port
EXPOSE 3000

# Define default command
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
