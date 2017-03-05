defmodule PlugAndPlay.ApplicationTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureIO

  doctest PlugAndPlay.Application

  defmodule TestRouter do
    use PlugAndPlay.Router

    get "/hello" do
      send_resp conn, 200, "Hello world!"
    end
  end

  defmodule TestApplicationOnExplicitPort do
    use PlugAndPlay.Application,
      router: TestRouter,
      port: 8383
  end

  defmodule TestApplicationOnImplicitPort do
    use PlugAndPlay.Application,
      router: TestRouter
  end

  test "starts an app with the given router and port" do
    start_app TestApplicationOnExplicitPort

    assert http_get("http://0.0.0.0:8383/hello") == "Hello world!"
  end

  test "does not require an explicit port to be specified" do
    start_app TestApplicationOnImplicitPort

    assert http_get("http://0.0.0.0:8080/hello") == "Hello world!"
  end

  defp start_app(module) do
    capture_io fn ->
      {:ok, _pid} = module.start(:_type, [])
    end
  end

  defp http_get(url) do
    :inets.start
    {:ok, {{_, 200, _}, _headers, body}} = url |> to_charlist |> :httpc.request
    body |> to_string
  end
end
