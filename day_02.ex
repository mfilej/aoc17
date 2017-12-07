defmodule Day2 do
  @input File.read!("input/day_02.txt")
  @row_sep "\n"
  @col_sep "\t"

  def run(part) do
    @input
    |> parse
    |> checksum(part)
    |> IO.inspect
  end

  def parse(input) do
    input
    |> String.splitter(@row_sep, trim: true)
    |> Enum.map(fn(line) ->
      line
      |> String.split(@col_sep)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def checksum(table, :a) do
    Enum.reduce(table, 0, fn(row, sum) ->
      {min, max} = Enum.min_max(row)
      sum + max - min
    end)
  end

  def checksum(table, :b) do
    Enum.reduce(table, 0, fn(row, sum) ->
      {dividend, divisor} = find_evenly_divisible_pair(row)
      sum + div(dividend, divisor)
    end)
  end

  def find_evenly_divisible_pair(list) do
    cartesian(list)
    |> Enum.find(fn({i, j}) ->
      i != j && rem(i, j) == 0
    end)
    |> IO.inspect
  end

  def cartesian(list) do
    for i <- list, j <- list, do: {i, j}
  end
end

Day2.run(:b)
