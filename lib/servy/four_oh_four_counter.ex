defmodule Servy.FourOhFourCounter do
  @name __MODULE__

  alias Servy.GenericServer

  # Client interface functions
  def start(initial_state \\ %{}) do
    GenericServer.start(__MODULE__, initial_state, @name)
  end

  def bump_count(path) do
    GenericServer.call(@name, {:bump_count, path})
  end

  def get_count(path) do
    GenericServer.call(@name, {:get_count, path})
  end

  def get_counts() do
    GenericServer.call(@name, :get_counts)
  end

  def clear() do
    GenericServer.cast(@name, :clear)
  end

  # Server callbacks
  def handle_call({:bump_count, path}, state) do
    new_state = Map.update(state, path, 1, &(&1 + 1))
    {new_state[path], new_state}
  end

  def handle_call({:get_count, path}, state) do
    {Map.get(state, path, 0), state}
  end

  def handle_call(:get_counts, state) do
    {state, state}
  end

  def handle_cast(:clear, _state) do
    %{}
  end
end
