# PlugAndPlay

Set up a `Plug` application with less boilerplate.

`PlugAndPlay` is not a web framework – it's a small scaffold. You use `Plug` as you would normally, only *sooner*.

Later, if you need more control, you can easily replace `PlugAndPlay` piece by piece or wholesale.


## Setting up a Plug app, the easy way

Generate a new project with `--sup`, e.g.

    mix new hello_world --sup

Open `mix.exs` and add `plug_and_play` to your list of dependencies:

```elixir
def deps do
  [
    {:plug_and_play, "~> 0.5.0"},
  ]
end
```

*(This makes `PlugAndPlay` conveniences available and saves you from manually adding Plug and the [Cowboy](https://github.com/ninenines/cowboy) web server to the deps list.)*

Make your main application (e.g. `lib/hello_world/application.ex`) look something like:

```elixir
defmodule HelloWorld.Application do
  use PlugAndPlay.Application, mod: HelloWorld
end
```

The `mod` will be used to determine your router (assumed to be `HelloWorld.Router`) and any configuration (assumed to be for `:hello_world`).

*(This saves you from manually setting up a Supervisor to run your app in the Cowboy web server on the right port.)*

Make your main application (e.g. `lib/hello_world.ex`) look something like:

```elixir
defmodule HelloWorld do
  defmodule Router do
    use PlugAndPlay.Router

    get "/" do
      send_resp conn, 200, "Hello world!"
    end

    match _ do
      send_resp conn, 404, "404!"
    end
  end
end
```

*(This saves you from manually including some `Plug.Router` boilerplate.)*

Now you should be able to start the app in a terminal with:

    mix deps.get
    mix server

*(This saves you from typing `mix run --no-halt`.)*

It outputs the URL at which the server runs - usually <http://0.0.0.0:8080>. Go there and marvel!


## Port number

The default port is 8080.

If the environment variable `PORT` is set, that port number will be used. This is the convention on e.g. [Heroku](https://heroku.com) and with [Dokku](http://dokku.viewdocs.io/dokku/), meaning things will Just Work™ if you deploy there.

Or you can configure a port in your application (typically in `config/config.exs`):

```elixir
config :hello_world, port: 1234
```

Application configuration wins over an environment variable if both are set.


## Custom supervision

By default, `PlugAndPlay` defines a supervision tree for you so you don't have to. If that's all you need, ignore this section.

If you want more control, you can define your own supervision tree with `PlugAndPlay.Supervisor` as one of its children.

Make your main application (e.g. `lib/hello_world/application.ex`) look something like:

```elixir
defmodule HelloWorld.Application do
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      supervisor(PlugAndPlay.Supervisor, [HelloWorld]),
      # Add whatever you like here.
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
```


## Credits and license

By [Henrik Nyh](https://henrik.nyh.se) 2017-02-25 under the MIT License.
