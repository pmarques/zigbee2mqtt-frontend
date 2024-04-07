FROM node:21.7.2-alpine3.19 as build

WORKDIR /app
COPY package.json /app/
RUN npm install

COPY . /app/
RUN npm run build

FROM busybox:1.36.1-musl@sha256:08bcd7c42cebb116a4942df70c508d2a7ff05d610c129ecde04a1a6cfd0cab9f

# Create a non-root user to own the files and run our server
RUN adduser -D static
USER static

WORKDIR /home/static

COPY --from=build /app/dist .

EXPOSE 3000/udp
EXPOSE 3000/tcp

# Run BusyBox httpd
CMD ["busybox", "httpd", "-f", "-v", "-p", "3000"]
