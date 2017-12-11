defmodule Day11 do
  @input File.read!("input/day_11.txt")

  defmodule Pos do
    defstruct x: 0, y: 0, z: 0, max: 0
  end

  def run do
    @input
    |> parse
    |> move(starting_position())
    |> IO.inspect
  end

  def starting_position, do: %Pos{}

  def parse(input) do
    input
    |> String.trim_trailing
    |> String.splitter(",")
    |> Enum.to_list
  end

  def move([], pos) do
    pos
  end
  def move(["n"  | rest], p) do
    find_max_and_move(rest, %{p | y: p.y + 1, z: p.z - 1})
  end
  def move(["ne" | rest], p) do
    find_max_and_move(rest, %{p | x: p.x + 1, z: p.z - 1})
  end
  def move(["se" | rest], p) do
    find_max_and_move(rest, %{p | x: p.x + 1, y: p.y - 1})
  end
  def move(["s"  | rest], p) do
    find_max_and_move(rest, %{p | y: p.y - 1, z: p.z + 1})
  end
  def move(["sw" | rest], p) do
    find_max_and_move(rest, %{p | x: p.x - 1, z: p.z + 1})
  end
  def move(["nw" | rest], p) do
    find_max_and_move(rest, %{p | x: p.x - 1, y: p.y + 1})
  end

  def find_max_and_move(moves, %{x: x, y: y, z: z, max: current_max} = p) do
    new_max = [x, y, z, current_max] |> Enum.map(&abs/1) |> Enum.max
    move(moves, %{p | max: new_max})
  end
end

Day11.run
