FROM node:argon@sha256:6a1a9552d597bf34b7b314a0c9eb42e1c6e50fe1fd466f63953661f2fc95e64c

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
