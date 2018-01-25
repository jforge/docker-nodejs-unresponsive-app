FROM node:argon@sha256:a590ca5d509c175dee906e1ea4b14529c14e2c63dda95050c3173bdd01394a72

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
