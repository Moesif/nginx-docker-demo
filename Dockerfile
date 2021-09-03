FROM nginx:1.15-alpine

RUN apk update && apk add git unzip wget lua-dev build-base luarocks

RUN luarocks-5.1 install --server=http://luarocks.org/manifests/moesif lua-resty-moesif

RUN apk add --no-cache nginx-mod-http-lua

# Delete default config
RUN rm -r /etc/nginx/conf.d && rm /etc/nginx/nginx.conf

# Create folder for PID file
RUN mkdir -p /run/nginx

# Add our nginx conf
COPY ./nginx.conf /etc/nginx/nginx.conf

# Add our moesif conf
COPY ./nginx.conf.d/ /etc/nginx/conf.d/

CMD ["nginx"]
