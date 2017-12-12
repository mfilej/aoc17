defmodule Day12 do
  @input File.read!("input/day_12.txt")

  def run(:a) do
    @input
    |> parse
    |> collect_programs("0", MapSet.new)
    |> MapSet.size
  end
  def run(:b) do
    pipes = @input |> parse

    Map.keys(pipes)
    |> Enum.map(fn(program) -> collect_programs(pipes, program, MapSet.new) end)
    |> Enum.uniq
    |> length
  end

  def collect_programs(pipes, program, group) do
    if MapSet.member?(group, program) do
      group
    else
      group = MapSet.put(group, program)
      Map.fetch!(pipes, program)
      |> Enum.reduce(group, fn(p, union) ->
        MapSet.union(union, collect_programs(pipes, p, union))
      end)
    end
  end

  def parse(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.into(Map.new)
  end

  def parse_line(line) do
    [from, to] = String.split(line, " <-> ")
    to = String.split(to, ", ")

    {from, to}
  end
end

Day12.run(:a) |> IO.inspect
Day12.run(:b) |> IO.inspect
