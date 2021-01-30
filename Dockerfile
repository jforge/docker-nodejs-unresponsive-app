FROM node:argon@sha256:fab73fccce5abc3fade13a99179884a306aa6c5292a2fc11833ee25ca15c1f85

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
