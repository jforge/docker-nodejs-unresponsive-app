FROM node:argon@sha256:41d0ad2557ea2a9e57e1a458c1d659e92f601586e07dcffef74c9cef542f6f6e

# create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# install app dependencies
COPY package.json /usr/src/app
RUN npm install

# bundle app source
COPY . /usr/src/app

EXPOSE 8095
CMD [ "npm", "start" ]
