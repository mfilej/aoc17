defmodule Day13 do
  @input File.read!("input/day_13.txt")

  defmodule Layer do
    defstruct [:depth, :range, :pos, :dir]

    def new([depth, range]) do
      %Layer{depth: depth, range: range, pos: 1, dir: :down}
    end

    def step(%Layer{dir: :down} = layer) do
      pos = layer.pos + 1
      dir =
        if pos == layer.range do
          :up
        else
          :down
        end
      %{layer | pos: pos, dir: dir}
    end
    def step(%Layer{dir: :up} = layer) do
      pos = layer.pos - 1
      dir =
        if pos == 1 do
          :down
        else
          :up
        end
      %{layer | pos: pos, dir: dir}
    end
  end

  def run(:a) do
    @input
    |> parse
    |> Enum.map(&Layer.new/1)
    |> trip(init_state())
  end
  def run(:b) do
    layers =
      @input
      |> parse
      |> Enum.map(&Layer.new/1)

    find_delay(layers, 0)
  end

  def find_delay(layers, delay) do
    result = trip(layers, init_state())
    if result.caught_at == [] do
      delay
    else
      IO.inspect(delay)
      find_delay(tick(layers), delay + 1)
    end
  end

  def trip([], state), do: state
  def trip([layer | rest], state) do
    state = check(layer, state)
    {layers, state} = ticks_until_next_layer(rest, state)
    trip(layers, state)
  end

  def ticks_until_next_layer([], state), do: {[], state}
  def ticks_until_next_layer([%Layer{depth: depth} | _] = layers, state) do
    if state.at == depth do
      {layers, state}
    else
      ticks_until_next_layer(tick(layers), %{state | at: state.at + 1})
    end
  end

  def check(%Layer{pos: 1, depth: d, range: r}, state) do
    %{state | caught_at: [d | state.caught_at], severity: state.severity + (d*r)}
  end
  def check(_layer, state) do
    state
  end

  def tick(layers) do
    layers |> Enum.map(&Layer.step/1)
  end

  def init_state do
    %{at: 0, caught_at: [], severity: 0}
  end

  def parse(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    Regex.run(~r/(\d+): (\d+)/, line)
    |> Enum.drop(1)
    |> Enum.map(&String.to_integer/1)
  end
end

Day13.run(:a) |> IO.inspect
Day13.run(:b) |> IO.inspect
