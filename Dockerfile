FROM ruby:onbuild
ARG CD_VERSION='2.38'
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update

# Required for chromedriver
RUN apt-get -y install libnss3-dev

# Install Chrome for Selenium
RUN apt-get -y --force-yes install google-chrome-stable

# Required for unzipping chromedriver
RUN apt-get -y install zip

ENV PATH="/usr/src/app/opt/google/chrome:${PATH}"

# Install chromedriver for Selenium
RUN curl https://chromedriver.storage.googleapis.com/${CD_VERSION}/chromedriver_linux64.zip -o /usr/local/bin/chromedriver_linux64.zip
RUN cd /usr/local/bin; unzip -o /usr/local/bin/chromedriver_linux64.zip
RUN rm /usr/local/bin/chromedriver_linux64.zip
RUN chmod +x /usr/local/bin/chromedriver

CMD rake TAGS=$TAGS
