## OpenResty with Moesif API Logging Example

Example Docker application using [Moesif OpenResty plugin](https://github.com/Moesif/lua-resty-moesif) to log API calls to [Moesif API analytics](https://www.moesif.com)

To learn more about configuration options, please refer to [Moesif OpenResty plugin](https://github.com/Moesif/lua-resty-moesif).

## How to run this example
1. Clone this repo and edit the `nginx.conf.d/main.conf` file to set your actual Moesif Application Id.

Your Moesif Application Id can be found in the [_Moesif Portal_](https://www.moesif.com/).
After signing up for a Moesif account, your Moesif Application Id will be displayed during the onboarding steps. 

You can always find your Moesif Application Id at any time by logging 
into the [_Moesif Portal_](https://www.moesif.com/), click on the top right menu,
and then clicking _API Keys_.

2. Build the docker image
```bash
docker build --no-cache -t nginx-docker-demo ./
```

3. Start the docker container:
```bash
docker-compose up -d
```

By default, The container is listening on port 8000. You should now be able to make a simple `GET` request: 

```bash
curl -X GET http://localhost:8000
```

4. The data should be captured in the corresponding Moesif account.

Congratulations! If everything was done correctly, Moesif should now be tracking all network requests that match the route you specified earlier. If you have any issues with set up, please reach out to support@moesif.com.

## JWT verification
The demo contains an [example JWT verification script](./nginx.conf.d/jwt_verification.lua) that allows you to authorize requests to the `/api` endpoint. To see how it works, follow these steps:

1. Specify your JWT secret in the [`main.conf` file](./nginx.conf.d/main.conf).
2. Include your JWT token in the `Authorization` header of your HTTP request:

```bash
curl -X POST -H "Content-Type: application/json" "Authorization: YOUR_JWT_TOKEN"  -d '{"name":"moesif"}' "http://localhost:8000/api?x=2&y=4" -H 'User-Id:123' -H "Company-Id:567"
```

The server sends a valid response back:

```json
{
  "message": "Hello World",
  "completed": true
}
```

Without a valid JWT token, the server sends a `401 Unauthorized` error response.