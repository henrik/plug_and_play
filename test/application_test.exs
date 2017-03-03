defmodule PlugAndPlay.ApplicationTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  doctest PlugAndPlay.Application

  defmodule TestRouter do
    use PlugAndPlay.Router

    get "/hello" do
      send_resp conn, 200, "Hello world!"
    end
  end

  defmodule TestApplication do
    use PlugAndPlay.Application,
      router: TestRouter,
      port: 8383
  end

  test "starts an app with the given router and port" do
    capture_io fn ->
      {:ok, _pid} = TestApplication.start(:_type, [])
    end

    assert http_get("http://0.0.0.0:8383/hello") == "Hello world!"
  end

  defp http_get(url) do
    :inets.start
    {:ok, {{_, 200, _}, _headers, body}} = url |> to_charlist |> :httpc.request
    body |> to_string
  end
end
