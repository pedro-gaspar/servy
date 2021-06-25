defmodule Recurse do
  def triple([head | tail]) do
    [head * 3 | triple(tail)]
  end

  def triple([]), do: []

  def my_map(items, fun), do: my_map(items, fun, [])

  def my_map([head | tail], fun, mapped_items) do
    my_map(tail, fun, [fun.(head) | mapped_items])
  end

  def my_map([], _, mapped_items) do
    mapped_items
    |> Enum.reverse()
  end
end

IO.inspect(Recurse.triple([1, 2, 3, 4, 5]))

nums = [1, 2, 3, 4, 5]

IO.inspect(Recurse.my_map(nums, &(&1 * 2)))

IO.inspect(Recurse.my_map(nums, &(&1 * 4)))

IO.inspect(Recurse.my_map(nums, &(&1 * 5)))
