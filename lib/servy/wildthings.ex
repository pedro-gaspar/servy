defmodule Servy.Wildthings do
  alias Servy.Bear
  require Logger

  @db_path Path.expand("db", File.cwd!())

  defp read_json(source) do
    case File.read(source) do
      {:ok, contents} ->
        contents

      {:error, reason} ->
        Logger.error("Error reading #{source}: #{reason}")
        "[]"
    end
  end

  def list_bears do
    @db_path
    |> Path.join("bears.json")
    |> read_json
    |> Jason.decode!(keys: :atoms)
    |> Map.get(:bears)
    |> Enum.map(&struct(Bear, &1))
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn b -> b.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer() |> get_bear
  end
end
