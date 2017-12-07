defmodule Day03b do
  @input 312_051

  defmodule Position do
    defstruct [:x, :y]
  end

  defmodule Grid do
    defstruct map: Map.new

    def init(start_pos, value) do
      %Grid{} |> put(start_pos, value)
    end

    def compute(grid, at: pos) do
      value = sum_adj(grid, pos)
      new_grid = put(grid, pos, value)
      {new_grid, value}
    end

    def put(%Grid{map: map} = grid, %Position{x: x, y: y}, value) do
      %{grid | map: Map.put(map, {x, y}, value)}
    end

    defp sum_adj(%Grid{map: map}, %Position{x: x, y: y}) do
      [
        Map.get(map, {x - 1, y - 1}, 0),
        Map.get(map, {x    , y - 1}, 0),
        Map.get(map, {x + 1, y - 1}, 0),
        Map.get(map, {x - 1, y    }, 0),

        Map.get(map, {x + 1, y    }, 0),
        Map.get(map, {x - 1, y + 1}, 0),
        Map.get(map, {x    , y + 1}, 0),
        Map.get(map, {x + 1, y + 1}, 0),
      ] |> Enum.sum
    end
  end

  defmodule Momentum do
    defstruct [:dir, :step, :to_go]

    def tick(%Momentum{to_go: to_go} = momentum) when to_go > 1 do
      %{momentum | to_go: momentum.to_go - 1}
    end
    def tick(%Momentum{dir: :>, step: step} = m) do
      %{m | dir: :A, to_go: step}
    end
    def tick(%Momentum{dir: :A, step: step} = m) do
      %{m | dir: :<, to_go: step + 1, step: step + 1}
    end
    def tick(%Momentum{dir: :<, step: step} = m) do
      %{m | dir: :V, to_go: step}
    end
    def tick(%Momentum{dir: :V, step: step} = m) do
      %{m | dir: :>, to_go: step + 1, step: step + 1}
    end
  end

  def run do
    start_pos = %Position{x: 0, y: 0}
    start_mom = %Momentum{dir: :>, step: 1, to_go: 1}
    grid = Grid.init(start_pos, 1)
    move(grid, start_pos, start_mom)
    |> IO.inspect
  end

  def move(grid, pos, momentum) do
    new_pos = step(pos, momentum)
    {new_grid, value} = Grid.compute(grid, at: new_pos)

    if value <= @input do
      new_momentum = Momentum.tick(momentum)
      move(new_grid, new_pos, new_momentum)
    else
      {pos, value}
    end
  end

  def step(pos, %Momentum{dir: :>}) do
    %{pos | x: pos.x + 1}
  end
  def step(pos, %Momentum{dir: :A}) do
    %{pos | y: pos.y + 1}
  end
  def step(pos, %Momentum{dir: :<}) do
    %{pos | x: pos.x - 1}
  end
  def step(pos, %Momentum{dir: :V}) do
    %{pos | y: pos.y - 1}
  end
end

Day03b.run
