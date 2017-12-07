defmodule Day03 do
  @input File.read!("input/day_04.txt")
  @row_sep "\n"
  @col_sep " "

  def run(part) do
    @input
    |> parse
    |> to_sorted_lists(part)
    |> count_unique
    |> IO.puts
  end

  def parse(input) do
    input
    |> String.splitter(@row_sep, trim: true)
    |> Enum.map(fn(line) ->
      line
      |> String.split(@col_sep)
    end)
  end

  def to_sorted_lists(passphrases, :a), do: passphrases
  def to_sorted_lists(passphrases, :b) do
    passphrases
    |> Enum.map(fn(passphrase) ->
      passphrase
      |> Enum.map(fn(word) ->
        word
        |> String.graphemes
        |> Enum.sort
      end)
    end)
  end

  def count_unique(list) do
    list
    |> Enum.count(fn(words) ->
      Enum.count(Enum.uniq(words)) == Enum.count(words)
    end)
  end
end

Day03.run(:b)
