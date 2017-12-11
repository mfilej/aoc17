defmodule Day09 do
  @input File.read!("input/day_09.txt")

  defmodule Result do
    defstruct log: [], depth: 0, count: 0
  end

  def run do
    @input
    |> String.trim_trailing
    |> parse
  end

  def parse(input), do: parse(input, %Result{})
  def parse("", result) do
    groups_score = result.log |> Enum.sum
    garbage_score = result.count
    {groups_score, garbage_score}
  end
  def parse("{" <> rest, score) do
    parse(rest, %{score | depth: score.depth + 1})
  end
  def parse("}" <> rest, score) do
    parse(rest, %{score | depth: score.depth - 1, log: [score.depth | score.log]})
  end
  def parse("," <> rest, score) do
    parse(rest, score)
  end
  def parse("!" <> <<_::bytes-size(1)>> <> rest, score) do
    parse(rest, score)
  end
  def parse("<" <> rest, score) do
    {rest, score} = count_garbage(rest, score)
    parse(rest, score)
  end

  def count_garbage(">" <> rest, score) do
    {rest, score}
  end
  def count_garbage("!" <> <<_::bytes-size(1)>> <> rest, score) do
    count_garbage(rest, score)
  end
  def count_garbage(<<_::bytes-size(1)>> <> rest, score) do
    count_garbage(rest, %{score | count: score.count + 1})
  end
end

Day09.run |> IO.inspect
