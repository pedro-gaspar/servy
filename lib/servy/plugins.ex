defmodule Servy.Plugins do
  require Logger

  @doc "Logs 404 requests."
  def track(%{status: 404, path: path} = conv) do
    IO.puts("Warning #{path} is on the loose!")
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    %{conv | path: "/#{thing}/#{id}"}
  end

  def rewrite_path_captures(conv, nil), do: conv

  def log(conv) do
    Logger.info(IO.inspect(conv))
    conv
  end

  def emojify(%{status: 200, resp_body: resp_body} = conv) do
    emojies = String.duplicate("🎉", 5)

    body = """
    #{emojies}
    #{resp_body}
    #{emojies}
    """

    %{conv | resp_body: body}
  end

  def emojify(conv), do: conv
end
