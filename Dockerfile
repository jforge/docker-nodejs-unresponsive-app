FROM node:argon@sha256:92bc49b2e3c19c5ef38149bf789ecc1f4386211a2dca6650c59c5164244d4c92

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
