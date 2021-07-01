defmodule UserApi do
  def query(id) do
    build_url(id)
    |> HTTPoison.get!()
    |> handle_response()
  end

  defp build_url(id) do
    "https://jsonplaceholder.typicode.com/users/#{id}"
  end

  defp handle_response(%HTTPoison.Response{status_code: 200, body: body}) do
    city =
      body
      |> to_json()
      |> get_in(["address", "city"])

    {:ok, city}
  end

  defp handle_response(%HTTPoison.Response{status_code: _, body: body}) do
    message =
      body
      |> to_json()
      |> Map.get("message")

    {:error, message}
  end

  defp(handle_response(%HTTPoison.Error{reason: reason}), do: {:error, reason})

  defp to_json(body) do
    body
    |> Jason.decode!()
  end
end
