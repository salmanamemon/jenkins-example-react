FROM node:16.16.0-buster AS build
WORKDIR /build

COPY package.json package.json
COPY package-lock.json package-lock.json
RUN npm ci

COPY public/ public
COPY src/ src
RUN npm run build

FROM httpd:alpine
WORKDIR /Applications/AMPPS/www
COPY --from=build /build/build/ .
RUN chown -R www-data:www-data /Applications/AMPPS/www \
    && sed -i "s/Listen 80/Listen \${PORT}/g" /Applications/AMPPS/apache/conf/httpd.conf