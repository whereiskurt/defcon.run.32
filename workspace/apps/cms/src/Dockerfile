FROM node:18-alpine
# Installing libvips-dev for sharp Compatibility
RUN apk update && apk add --no-cache curl build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY package.json package-lock.json ./
RUN npm config set fetch-retry-maxtimeout 600000 -g && npm install
RUN npm install pg

WORKDIR /opt/app
COPY . .
ENV PATH /opt/node_modules/.bin:$PATH
RUN chown -R node:node /opt/app
USER node
RUN npm run build
EXPOSE 8080
CMD ["npm", "run", "develop"]
