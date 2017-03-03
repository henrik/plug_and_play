defmodule PlugAndPlay.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  doctest PlugAndPlay.Router

  defmodule TestRouter do
    use PlugAndPlay.Router

    get "/hello" do
      send_resp conn, 200, "Hello world!"
    end
  end

  test "sets up a valid router" do
    conn = conn(:get, "/hello")
      |> TestRouter.call(TestRouter.init([]))

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hello world!"
  end
end
