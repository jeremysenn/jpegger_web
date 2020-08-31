FROM ruby:2.6.3

# Change to the application's directory
WORKDIR /application

# Copy application code
COPY . /application

EXPOSE 3001
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3001"]
# CMD ["rails", "server", "-b", "ssl://0.0.0.0?key=localhost.key&cert=localhost.crt"]

# Install FreeTDS
RUN apt-get update
RUN apt-get install -y freetds-dev freetds-bin tdsodbc

RUN apt-get install -y build-essential libpq-dev nodejs

RUN apt-get install vim -y

# Install ImageMagick
RUN apt-get install -y imagemagick ghostscript

# Install gems
RUN bundle install

# ENTRYPOINT [ "/bin/bash" ]
