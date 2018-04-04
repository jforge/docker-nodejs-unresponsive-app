FROM node:argon@sha256:e8b42f95aee37523cbc584d4d33f481132de11c3eed7b341c0cff3b0b234d93f

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
