defmodule Servy.FileHandler do
  alias Servy.Conv

  @pages_path Path.expand("pages", File.cwd!())

  def handle_pages_file(conv, file) do
    cond do
      File.exists?(pages_file_path(file, ".md")) -> read_pages_file(conv, :md, file)
      File.exists?(pages_file_path(file, ".html")) -> read_pages_file(conv, :html, file)
    end
  end

  def pages_file_path(file, extension) do
    @pages_path
    |> Path.join(file <> extension)
  end

  defp read_pages_file(conv, :html, file) do
    file
    |> pages_file_path(".html")
    |> File.read()
    |> handle_file(conv)
  end

  defp read_pages_file(conv, :md, file) do
    file
    |> pages_file_path(".md")
    |> File.read()
    |> handle_file(conv)
    |> markdown_to_html
  end

  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | status: 404, resp_body: "File not found!"}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end

  defp markdown_to_html(%Conv{status: 200} = conv) do
    %{conv | resp_body: Earmark.as_html!(conv.resp_body)}
  end

  defp markdown_to_html(%Conv{} = conv), do: conv
end
