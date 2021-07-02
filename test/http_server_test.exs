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
    [
      "http://localhost:4000/wildthings",
      "http://localhost:4000/bears",
      "http://localhost:4000/bears/1",
      "http://localhost:4000/wildlife",
      "http://localhost:4000/api/bears"
    ]
    |> Enum.map(&Task.async(fn -> get_wildthings(&1) end))
    |> Enum.map(&Task.await/1)
    |> Enum.map(fn {:ok, response} ->
      assert response.status_code == 200
    end)
  end

  defp get_wildthings(url), do: HTTPoison.get(url)
end
