defmodule Day22 do
  @input File.read!("input/day_22.txt")

  def run(num_bursts) do
    start_grid =
      @input
      |> parse
      |> collect_nodes

    {final_grid, infections} =
      burst(num_bursts, start_grid, initial_state(), 0)

    # start_grid |> MapSet.size |> IO.inspect
    # final_grid |> MapSet.size |> IO.inspect

    MapSet.difference(final_grid, start_grid)
    |> MapSet.size

    infections
  end

  def burst(0, grid, _pos, infections) do
    IO.puts "done"
    {grid, infections}
  end
  def burst(num_bursts, grid, state, infections) do
    {new_state, new_grid, new_infections} =
      if infected?(grid, state) do
        {turn_right(state), uninfect!(grid, state), infections}
      else
        {turn_left(state),    infect!(grid, state), infections+1}
      end

    burst(num_bursts - 1, new_grid, step(new_state), new_infections)
  end

  def parse(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Enum.with_index()
  end

  def infected?(grid, state), do: MapSet.member?(grid, {state.x, state.y})
  def infect!(grid, state), do: MapSet.put(grid, {state.x, state.y})
  def uninfect!(grid, state) do
    unless MapSet.member?(grid, {state.x, state.y}) do
      raise "hell"
    end
    MapSet.delete(grid, {state.x, state.y})
  end

  def collect_nodes(lines) do
    lines
    |> Stream.flat_map(&collect_line(&1, length(lines)))
    |> Stream.reject(fn nil -> true; _ -> false end)
    |> Enum.into(MapSet.new)
    |> MapSet.delete(nil)
  end

  def collect_line({line, y}, num_lines) do
    nodes =
      line
      |> String.codepoints
      |> Enum.with_index

    num_nodes = length(nodes)

    nodes
    |> Enum.map(fn
      {".", _} -> nil;
      {"#", x} -> {center(x, num_nodes), center(y, num_lines)}
    end)
  end

  def center(current, total) do
    current - div(total, 2)
  end

  def initial_state() do
    %{x: 0, y: 0, dir: 0}
  end

  def step(%{dir:   0} = state), do: %{state | y: state.y - 1}
  def step(%{dir:  90} = state), do: %{state | x: state.x + 1}
  def step(%{dir: 180} = state), do: %{state | y: state.y + 1}
  def step(%{dir: 270} = state), do: %{state | x: state.x - 1}

  def turn_left(state),  do: turn(state, &(&1 - 90))
  def turn_right(state), do: turn(state, &(&1 + 90))

  defp turn(state, fun) do
    %{state | dir: Integer.mod(fun.(state.dir), 360)}
  end
end

Day22.run(10_000) |> IO.inspect
