FROM node:argon@sha256:36adaf7ae6d88589009b54b1fef7a660768db5ec8248e82944604c07455d46ba

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
