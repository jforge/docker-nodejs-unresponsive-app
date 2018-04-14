FROM node:argon@sha256:db9cbb9420b52d591e36eb66a019995f5d2c3a05b5087918ea1ab0ba3949b74d

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
