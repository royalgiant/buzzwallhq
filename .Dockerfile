# # Use an official Ruby runtime as a parent image
# FROM ruby:3.0.0

# # Set the working directory to /app
# WORKDIR /app

# # Copy the current directory contents into the container at /app
# COPY . /app

# # Install libvips dependencies
# RUN apt-get update && \
#     apt-get install -y libvips libvips-dev && \
#     apt-get install libglib2.0-dev && \
#     apt-get install redis-server && \
#     rm -rf /var/lib/apt/lists/*

# # Install any needed packages specified in the Gemfile
# RUN gem install bundler && bundle install

# # Run database setup commands
# RUN bin/dev
# RUN rails db:create
# RUN rails db:migrate
# RUN rails assets:precompile

# # Make port 3001 available to the world outside this container
# EXPOSE 3025

# # Define environment variable for Rails
# ENV RAILS_ENV=development

# # Run the application
# CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3025"]
