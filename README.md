# PlugAndPlay

Set up a `Plug` application with less boilerplate.

`PlugAndPlay` is not a web framework – it's a small scaffold. You use `Plug` as you would normally, only *sooner*.

Later, if you need more control, you can easily replace `PlugAndPlay` piece by piece or wholesale.


## Setting up a Plug app, the easy way

Generate a new project with `--sup` (to get a supervisor tree and an application callback), e.g.

    mix new hello_world --sup

Open `mix.exs` and add `plug_and_play` to your list of dependencies:

```elixir
def deps do
  [
    {:plug_and_play, "~> 0.1.0"},
  ]
end
```

*(This saves you from manually adding Plug and the [Cowboy](https://github.com/ninenines/cowboy) web server to the deps list.)*

Make your main application (e.g. `lib/hello_world/application.ex`) look something like:

```elixir
defmodule HelloWorld.Application do
  use PlugAndPlay.Application, router: HelloWorld.Router
end
```

*(This saves you from manually setting up a Supervisor to run your app in the Cowboy web server on the right port.)*

Make your main application (e.g. `lib/hello_world.ex`) look something like:

```elixir
defmodule HelloWorld do
  defmodule Router do
    use PlugAndPlay.Router

    get "/" do
      send_resp conn, 200, "Hello world!"
    end
  end
end
```

*(This saves you from manually including some `Plug.Router` boilerplate.)*

Now you should be able to start the app in a terminal with:

    mix deps.get
    mix run --no-halt

It outputs the URL at which the server runs. Go there and marvel!


## Port number

If the environment variable `PORT` is set, that port number will be used.

This is the convention on e.g. [Heroku](https://heroku.com) and with [Dokku](http://dokku.viewdocs.io/dokku/), meaning things will Just Work™ if you deploy there.

The default is port 8080. To run on another port in development:

    PORT=8181 mix run --no-halt


## Credits and license

By [Henrik Nyh](https://henrik.nyh.se) 2017-02-25 under the MIT License.
