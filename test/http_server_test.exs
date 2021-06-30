defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer

  setup_all do
    pid = spawn(fn -> HttpServer.start(4000) end)

    on_exit(fn -> Process.exit(pid, :normal) end)
  end

  test "Concurrently get 5 bears responses from http server" do
    {:ok, response} = HTTPoison.get("http://localhost:4000/wildthings")
    assert response.status_code == 200
    assert response.body == "Bears, Lions, Tigers"
  end

  test "Get bears response from http server" do
    caller = self()

    for _ <- 1..5 do
      spawn(fn ->
        {:ok, response} = HTTPoison.get("http://localhost:4000/wildthings")
        send(caller, {:ok, response})
      end)
    end

    for _ <- 1..5 do
      receive do
        {:ok, response} ->
          assert response.status_code == 200
          assert response.body == "Bears, Lions, Tigers"
      end
    end
  end
end
