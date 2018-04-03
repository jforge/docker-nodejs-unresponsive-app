FROM node:argon@sha256:669edabd1480de7fcb3139dddc6528c0c5cc6d4fa3dc277300220dd2af2aa247

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
