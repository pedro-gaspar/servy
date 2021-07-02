defmodule Servy.Plugins do
  require Logger
  alias Servy.FourOhFourCounter
  alias Servy.Conv

  @doc "Logs 404 requests."
  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env() != :test do
      IO.puts("Warning #{path} is on the loose!")
      FourOhFourCounter.bump_count(path)
    end

    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path_captures(%Conv{} = conv, %{"thing" => thing, "id" => id}) do
    %{conv | path: "/#{thing}/#{id}"}
  end

  def rewrite_path_captures(%Conv{} = conv, nil), do: conv

  def log(%Conv{} = conv) do
    if Mix.env() == :dev do
      Logger.info(IO.inspect(conv))
    end

    conv
  end

  def emojify(%Conv{status: 200, resp_body: resp_body} = conv) do
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
