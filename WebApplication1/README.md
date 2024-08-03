# File Upload Service
## Setup and Usage
This service is part of the following microservices stack amd should be setup in your local dev in the following order.
1. [Authentication Service](https://github.com/productionap/px-user-login-service)
2. [File Upload Service](https://github.com/productionap/px-file-upload-service)
3. [General Service](https://github.com/productionap/px-general-service)


### Setup
---
- Clone this repository.
- Install the correct ruby version from [Gemfile](https://github.com/productionap/px-general-service/blob/master/Gemfile)
- Install postgres
- Install [Redis](https://redis.io/docs/getting-started/installation/install-redis-on-mac-os/)
- Install [Postman](https://github.com/ddollar/foreman)
- Setup your rails app DB.
  - Copy `config/database.yml.sample` to `config/database.yml`
  - Run `bin/rails db:create db:migrate`
- (Optional) Populate your rails app DB.
  - Get a database dump **Seed Data** from your team to match the last known seed data
  - Run `psql px_user_login_service_development < path/to/NameOfSeedData.sql`


For development purposes File Upload Service is typically run on port 3002. This is the default port used when starting the service. To start:

- `bundle exec rails s -p 3002`

### Configuration
---
File Upload Service is using
[figaro](https://github.com/laserlemon/figaro) for all our configuration needs.
Request a `config/application.yml` file from your team which contain all of the default environment variables.

Make sure to change the devise jwt secret keys and it shoud be the same across the different microservices stack.
```
DEVISE_JWT_SECRET_KEY=change_me
```
Generate your own secret keys
```
rake secret
```

