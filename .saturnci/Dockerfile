# Use the Ruby 3.1.2 image from Docker Hub
# as the base image (https://hub.docker.com/_/ruby)
FROM ruby:3.1.2

# Use a directory called /code in which to store
# this application's files. (The directory name
# is arbitrary and could have been anything.)
WORKDIR /code

# Copy all the application's files into the /code
# directory.
COPY . /code

RUN mkdir -p /code/vendor/bundle
RUN bundle config set path '/code/vendor/bundle' && bundle install

# Install Yarn.
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# Run yarn install to install JavaScript dependencies.
RUN yarn install --check-files

# Set "rails server -b 0.0.0.0" as the command to
# run when this container starts.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
