defmodule Servy do
  def start(_type, _args) do
    Servy.Supervisor.start_link()
  end
end
