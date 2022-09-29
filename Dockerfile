FROM ruby:latest
ARG CD_VERSION='105.0.5195.52'

RUN apt-get update
RUN apt-get -y upgrade
RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update

# Required for chromedriver
RUN apt-get -y install libnss3-dev ubuntu-dev-tools

# Install Chrome for Selenium
RUN apt-get -y --allow-unauthenticated install google-chrome-stable

# Required for unzipping chromedriver
RUN apt-get -y install zip

ENV PATH="/usr/src/app/opt/google/chrome:${PATH}"

# Install chromedriver for Selenium
RUN curl https://chromedriver.storage.googleapis.com/${CD_VERSION}/chromedriver_linux64.zip -o /usr/local/bin/chromedriver_linux64.zip
RUN cd /usr/local/bin; unzip -o /usr/local/bin/chromedriver_linux64.zip
RUN rm /usr/local/bin/chromedriver_linux64.zip
RUN chmod +x /usr/local/bin/chromedriver

RUN mkdir -p /usr/app
COPY . /usr/app
WORKDIR /usr/app

RUN gem install bundler

RUN bundle update --bundler

RUN bundle install

CMD rake TAGS=$TAGS
