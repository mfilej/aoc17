defmodule Day19 do
  @input File.read!("input/day_19.txt")

  def run do
    start = initial_state(@input)
    @input
    |> parse
    |> route(start)
    |> IO.inspect
  end

  def route(tubes, state) do
    next_pipe = get(tubes, state)
    state = next_state(tubes, state, next_pipe)
    route(tubes, state)
  end

  def next_state(tubes, state, next_pipe) do
    case action(state, next_pipe) do
      :cont -> step(state)
      :turn -> turn(tubes, state)
      :skip -> step(state)
      {:collect, letter} -> collect_letter(state, letter) |> step()
    end
    |> inc_steps
  end

  def inc_steps(state) do
    %{state | steps: state.steps + 1}
  end

  def step(%{dir: :V, y: y} = state), do: %{state | y: y + 1}
  def step(%{dir: :A, y: y} = state), do: %{state | y: y - 1}
  def step(%{dir: :>, x: x} = state), do: %{state | x: x + 1}
  def step(%{dir: :<, x: x} = state), do: %{state | x: x - 1}

  def turn(tubes, %{x: x, y: y, dir: dir} = cross) do
    [next_state] = [
      %{cross | y: y - 1, dir: :A },
      %{cross | x: x + 1, dir: :> },
      %{cross | y: y + 1, dir: :V },
      %{cross | x: x - 1, dir: :< },
    ]
    |> Enum.filter(&reject_current_dir(dir, &1.dir))
    |> Enum.filter(&peek(tubes, &1))
    next_state
  end

  def reject_current_dir(:A, :V), do: false
  def reject_current_dir(:>, :<), do: false
  def reject_current_dir(:V, :A), do: false
  def reject_current_dir(:<, :>), do: false
  def reject_current_dir(_c, _n), do: true

  def action(%{dir: :V}, "|"), do: :cont
  def action(%{dir: :A}, "|"), do: :cont
  def action(%{dir: :>}, "-"), do: :cont
  def action(%{dir: :<}, "-"), do: :cont
  def action(%{dir: :V}, "-"), do: :skip
  def action(%{dir: :A}, "-"), do: :skip
  def action(%{dir: :>}, "|"), do: :skip
  def action(%{dir: :<}, "|"), do: :skip
  def action(%{dir: __}, "+"), do: :turn
  def action(_, letter), do: {:collect, letter}

  def get(tubes, state) do
    Map.get(tubes, {state.x, state.y}, :fin)
  end

  def peek(tubes, state) do
    Map.get(tubes, {state.x, state.y})
  end

  def collect_letter(state, letter) do
    %{state | letters: [letter | state.letters]}
  end

  def initial_state(input) do
    [front | _] = String.split(input, "|", parts: 2)
    x = String.length(front) + 1
    %{x: x, y: 1, dir: :V, letters: [], steps: 0}
  end

  def parse(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Stream.with_index
    |> Stream.flat_map(&parse_line/1)
    |> Enum.into(%{})
  end

  def parse_line({line, y}) do
    line
    |> String.codepoints
    |> Enum.with_index
    |> Enum.filter(fn {" ", _} -> nil; tup -> tup end)
    |> Enum.map(fn {char, x} -> {{x+1, y+1}, char} end)
  end
end

Day19.run
