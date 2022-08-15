# RandomV

#### RandomV - get random link from youtube playlist.

## Install dependencies

```console
mix deps.get
```

## Run

Application uses secrets:

- playlist_id - id of default playlist
- api_key - youtube api key

Secrets are read from config/secrets.exs.

Copy example secrets file to config/secrets.exs

```console
cp config/secrets.example.exs config/secrets.exs
```

and substitute own values.

Run the app:

```console
mix run --no-halt
```

## Test

```console
mix test --no-start
```

, or

```console
iex -S mix
```

for interactive shell.

The **--no-start** flag instructs mix **not** to start the whole app (so that the http server is not started).

## Docs

#### [Openapi spec](./docs/openapi.yaml)

The service has one main endpoint - GET /api/v1/link. The endpoint, when requested, will return a link to random item from the specified playlist.

If **playlist_id** query parameter is not specified, default one will be used (the one, specified in config/secrets.exs).

There is also an option to redirect. If **redirect** query parameter is set, 302 HTTP status code will be returned, alongside with appropriate Location header set, else - **application/json** response body (etc. `{"link": <link>}`).
