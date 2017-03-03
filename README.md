# PlugAndPlay 🔌►

[![Build Status](https://secure.travis-ci.org/henrik/plug_and_play.svg?branch=master "Build Status")](https://travis-ci.org/henrik/plug_and_play)

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
    {:plug_and_play, "~> 0.7.0"},
  ]
end
```

*(This makes `PlugAndPlay` conveniences available and saves you from manually adding Plug and the [Cowboy](https://github.com/ninenines/cowboy) web server to the deps list.)*

Make your root module (e.g. `lib/hello_world.ex`) look something like:

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

Make your application module (e.g. `lib/hello_world/application.ex`) look something like:

```elixir
defmodule HelloWorld.Application do
  use PlugAndPlay.Application, router: HelloWorld.Router
end
```

*(This saves you from manually setting up a Supervisor to run your app in the Cowboy web server on the right port.)*

Now you should be able to start the app in a terminal with:

    mix deps.get
    mix server

*(This saves you from typing `mix run --no-halt`.)*

It outputs the URL at which the server runs - usually <http://0.0.0.0:8080>. Go there and marvel!


## Custom port number

The default port is 8080.

If the environment variable `PORT` is set, that port number will be used. This is the convention on e.g. [Heroku](https://heroku.com) and with [Dokku](http://dokku.viewdocs.io/dokku/), meaning things will Just Work™ if you deploy there.

Or you can assign a port explicitly, e.g. from application config.

Assuming you have config like this in `config/config.exs`:

```elixir
config :hello_world, port: 1234
```

You could do this in `lib/hello_world/application.ex`:


```elixir
defmodule HelloWorld.Application do
  use PlugAndPlay.Application,
    router: HelloWorld.Router,
    port: Application.get_env(:hello_world, :port)
end
```

If you set up your own supervision tree, you can also [specify the port there](#custom-supervision).


## Custom plug pipeline

If you need additional plugs, skip `use PlugAndPlay.Router` and simply write out the code instead:

```elixir
use Plug.Router

plug :match
plug :my_custom_plug
plug :dispatch
```

You can still use the rest of the `PlugAndPlay` conveniences, of course, even if you skip `PlugAndPlay.Router`.


## Custom supervision

By default, `PlugAndPlay` defines a supervision tree for you so you don't have to. If that's all you need, ignore this section.

If you want more control, you can define your own supervision tree with `PlugAndPlay.Supervisor` as one of its children.

Make your main application (e.g. `lib/hello_world/application.ex`) look something like:

```elixir
defmodule HelloWorld.Application do
  use Application

  def start(_type, _args) do
    children = [
      PlugAndPlay.Supervisor.child_spec(HelloWorld.Router),
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
```

You can specify the desired port as a second argument to `child_spec`.

You can specify multiple instances as long as they have different routers and ports:

```elixir
children = [
  PlugAndPlay.Supervisor.child_spec(HelloWorld.RouterOne, 1111),
  PlugAndPlay.Supervisor.child_spec(HelloWorld.RouterTwo, 2222),
]
```


## Credits and license

By [Henrik Nyh](https://henrik.nyh.se) 2017-02-25 under the MIT License.
