# Hasbihal

Hasbihal is a phoenix (elixir) project that built for be a robust realtime chat app example.

### Working demo

Visit [https://hasbihal.herokuapp.com](https://hasbihal.herokuapp.com)

### Installation

#### Via docker-compose

```
git clone git@github.com:hasbihal/backend.git hasbihal && cd hasbihal

# make runnable the script file
chmod u+x ./run.sh

# build a docker image
docker build -t hasbihal .

# copy example .env file
cp .env.example .env.docker

# P.S. 1: remove `exports` from .env.docker, because docker-compose env_file option wants to the dotenv syntax
# P.S. 2: generate a secret key by `mix phx.gen.secret | pbcopy` and paste in your .env file as `SECRET_KEY_BASE`

# finally run hasbihal app with `docker-compose up`
docker-compose up
```

#### Or manually

**Install Elixir for macOS**

```
brew update && brew install elixir
```

**Please visit [https://elixir-lang.org/install.html#unix-and-unix-like](https://elixir-lang.org/install.html#unix-and-unix-like) for another *nix systems**

**Install Hex**

```
mix local.hex
```

**Install Phoenix**

```
mix archive.install hex phx_new 1.4.0 --force
```

**Clone repository**

```
git clone git@github.com:hasbihal/backend.git hasbihal && cd hasbihal

# copy example .env file
cp .env.example .env.docker

# P.S.: generate a secret key by `mix phx.gen.secret | pbcopy` and paste in your .env file as `SECRET_KEY_BASE`

# get dependencies
mix deps.get

# create & migrate database
mix ecto.create && mix ecto.migrate

# database setup
source .env && mix ecto.create && mix ecto.migrate
```

**Serve hasbihal**

```
source .env && mix phx.server
```

Visit [localhost:8080](http://localhost:8080)

Cheers :beers: