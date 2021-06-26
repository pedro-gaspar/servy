defmodule Servy.BearController do
  alias Servy.Bear
  alias Servy.BearView
  alias Servy.Wildthings

  @templates_path Path.expand("templates", File.cwd!())

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_asc_by_name/2)

    %{conv | status: 200, resp_body: BearView.index(bears)}
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    %{conv | status: 200, resp_body: BearView.show(bear)}
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{conv | status: 201, resp_body: "Create a #{type} bear named #{name}!"}
  end

  def delete(conv, %{"id" => _id}) do
    %{conv | status: 403, resp_body: "Deleting a bear is forbidden!"}
  end
end
