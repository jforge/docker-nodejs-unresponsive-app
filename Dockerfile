FROM node:argon@sha256:16444b84395dd780e6ddfb145655f1b044f57cfcb9a6225ad2ba879eab7a850e

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
