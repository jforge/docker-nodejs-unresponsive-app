FROM node:argon@sha256:632f9021e36b39891f1442df6cbcfe399144f6bef4f5af4aaaf481db0734e73c

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
