FROM nginx:1.15-alpine

RUN apk update && apk add git unzip wget zlib-dev lua-dev build-base perl-dev

RUN wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz \
    && tar -xzvf luarocks-3.11.1.tar.gz \
    && cd luarocks-3.11.1 \
    && ./configure \
    && make build \
    && make install

# Install LuaJIT 2.1 from source
RUN wget https://github.com/openresty/luajit2/archive/refs/tags/v2.1.0-beta3.tar.gz && \
    tar -xzvf v2.1.0-beta3.tar.gz && \
    cd luajit2-2.1.0-beta3 && \
    make && make install && \
    ln -sf /usr/local/bin/luajit /usr/bin/luajit

# Update LuaRocks to use LuaJIT 2.1
RUN luarocks path --bin

# Install Lua modules (including resty.core)
RUN luarocks install --server=http://luarocks.org/manifests/moesif lua-resty-moesif && \
    luarocks install lua-resty-core && \
    luarocks install lua-resty-jwt

# Configure Nginx to use LuaJIT 2.1
RUN sed -i 's/load_module modules/#load_module modules/' /etc/nginx/nginx.conf && \
    echo 'load_module /usr/lib/nginx/modules/ngx_http_lua_module.so;' >> /etc/nginx/nginx.conf

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
