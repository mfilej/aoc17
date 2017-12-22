defmodule Day22b do
  @input File.read!("input/day_22.txt")

  def run(num_bursts) do
    start_grid =
      @input
      |> parse
      |> collect_nodes

    {_final_grid, infections} =
      burst(num_bursts, start_grid, initial_state(), 0)

    infections
  end

  def burst(0, grid, _pos, infections) do
    IO.puts "done"
    {grid, infections}
  end
  def burst(num_bursts, grid, state, infections) do
    node_status = get(grid, state)
    new_node_status = next_node_status(node_status)
    new_grid = set(grid, state, new_node_status)
    new_state = next_dir(state, node_status)
    new_infections =
      if new_node_status == :in do
        infections + 1
      else
        infections
      end

    burst(num_bursts - 1, new_grid, step(new_state), new_infections)
  end

  def get(grid, state) do
    Map.get(grid, {state.x, state.y}, :cl)
  end

  def set(grid, state, node_status) do
    Map.put(grid, {state.x, state.y}, node_status)
  end

  def parse(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Enum.with_index()
  end

  def collect_nodes(lines) do
    lines
    |> Stream.flat_map(&collect_line(&1, length(lines)))
    |> Stream.reject(fn nil -> true; _ -> false end)
    |> Enum.into(Map.new)
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
      {"#", x} -> {{center(x, num_nodes), center(y, num_lines)}, :in}
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


  def next_dir(state, :cl), do: turn_left(state)
  def next_dir(state, :we), do: state
  def next_dir(state, :in), do: turn_right(state)
  def next_dir(state, :fl), do: reverse(state)

  def turn_left(state),  do: turn(state, &(&1 - 90))
  def turn_right(state), do: turn(state, &(&1 + 90))
  def reverse(state),    do: turn(state, &(&1 + 180))

  defp turn(state, fun) do
    %{state | dir: Integer.mod(fun.(state.dir), 360)}
  end

  def next_node_status(:cl), do: :we
  def next_node_status(:we), do: :in
  def next_node_status(:in), do: :fl
  def next_node_status(:fl), do: :cl
end

Day22b.run(10_000_000) |> IO.inspect
