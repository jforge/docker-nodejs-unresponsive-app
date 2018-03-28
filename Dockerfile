FROM node:argon@sha256:c1a846ead65bc9e8c5d9945031c259b48bad304463ad81635c5acbbbe047216d

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
