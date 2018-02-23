FROM node:argon@sha256:b902f8eb8843c5dd3777ed537cde359ad1f9874be2c6862cdd3e244e2743173d

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
