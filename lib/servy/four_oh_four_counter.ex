defmodule Servy.FourOhFourCounter do
  @name __MODULE__

  # Client functions
  def start(initial_state \\ %{}) do
    pid = spawn(Servy.FourOhFourCounter, :counter_loop, [initial_state])
    Process.register(pid, @name)
    pid
  end

  def bump_count(path) do
    send(@name, {self(), :bump_count, path})

    receive do
      {:response, count} -> count
    end
  end

  def get_count(path) do
    send(@name, {self(), :get_count, path})

    receive do
      {:response, count} -> count
    end
  end

  def get_counts() do
    send(@name, {self(), :get_counts})

    receive do
      {:response, counts} -> counts
    end
  end

  # Server functions
  @spec counter_loop(any) :: :ok | <<>>
  def counter_loop(state) do
    receive do
      {sender, :bump_count, path} ->
        new_state = Map.update(state, path, 1, &(&1 + 1))
        send(sender, {:response, new_state[path]})
        counter_loop(new_state)

      {sender, :get_count, path} ->
        send(sender, {:response, Map.get(state, path, 0)})
        counter_loop(state)

      {sender, :get_counts} ->
        send(sender, {:response, state})
        counter_loop(state)

      unexpected ->
        IO.puts("Unexpected message: #{inspect(unexpected)}")
        counter_loop(state)
    end
  end
end
