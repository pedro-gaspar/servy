defmodule Servy.Conv do
  defstruct method: "", path: "", resp_body: "", status: nil

  @http_codes %{
    200 => "OK",
    201 => "Created",
    401 => "Unauthorized",
    403 => "Forbidden",
    404 => "Not Found",
    500 => "Internal Server Error"
  }

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  defp status_reason(code) do
    @http_codes[code]
  end
end
