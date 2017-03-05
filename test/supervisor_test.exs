defmodule PlugAndPlay.SupervisorTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureIO

  doctest PlugAndPlay.Application

  defmodule TestRouter do
    use PlugAndPlay.Router

    get "/", do: conn
  end

  test "starts a supervisor with the given router and port and says so" do
    output = capture_io fn ->
      {:ok, pid} = PlugAndPlay.Supervisor.start_link(TestRouter, 8383)
      :ok = Supervisor.stop(pid)
    end

    assert output == "PlugAndPlay started server: http://0.0.0.0:8383\n"
  end

  test "falls back to the PORT environment variable if no port is given" do
    System.put_env("PORT", "8484")

    output = capture_io fn ->
      {:ok, pid} = PlugAndPlay.Supervisor.start_link(TestRouter)
      :ok = Supervisor.stop(pid)
    end

    assert output == "PlugAndPlay started server: http://0.0.0.0:8484\n"
  end

  test "falls back to the default port of 8080 if not passed in nor set in environment" do
    System.delete_env("PORT")

    output = capture_io fn ->
      {:ok, pid} = PlugAndPlay.Supervisor.start_link(TestRouter)
      :ok = Supervisor.stop(pid)
    end

    assert output == "PlugAndPlay started server: http://0.0.0.0:8080\n"
  end
end
