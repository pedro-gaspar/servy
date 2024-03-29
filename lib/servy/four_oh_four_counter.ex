defmodule Servy.FourOhFourCounter do
  @name __MODULE__

  use GenServer

  # Client interface functions
  def start_link(initial_state \\ %{}) do
    GenServer.start_link(__MODULE__, initial_state, name: @name)
  end

  def bump_count(path) do
    GenServer.call(@name, {:bump_count, path})
  end

  def get_count(path) do
    GenServer.call(@name, {:get_count, path})
  end

  def get_counts() do
    GenServer.call(@name, :get_counts)
  end

  def clear() do
    GenServer.cast(@name, :clear)
  end

  def init(state) do
    {:ok, state}
  end

  # Server callbacks
  def handle_call({:bump_count, path}, _from, state) do
    new_state = Map.update(state, path, 1, &(&1 + 1))
    {:reply, new_state[path], new_state}
  end

  def handle_call({:get_count, path}, _from, state) do
    {:reply, Map.get(state, path, 0), state}
  end

  def handle_call(:get_counts, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:clear, _state) do
    [:noreply, %{}]
  end
end
