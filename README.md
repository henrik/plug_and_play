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

*(This makes `PlugAndPlay` conveniences available and saves you from manually adding Plug and the [Cowboy](https://github.com/ninenines/cowboy) web server to the deps list.)*

Make your main application (e.g. `lib/hello_world/application.ex`) look something like:

```elixir
defmodule HelloWorld.Application do
  use PlugAndPlay.Application, router: HelloWorld.Router
end
```

*(This saves you from manually setting up a Supervisor to run your app in the Cowboy web server on the right port. It will use `PORT` if that environment variable is set (it is automatically on Heroku) or else fall back to 8080.)*

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


## Credits and license

By [Henrik Nyh](https://henrik.nyh.se) 2017-02-25 under the MIT License.
