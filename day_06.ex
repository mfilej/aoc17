defmodule Day06 do
  @input File.read!("input/day_06.txt")

  def run do
    @input
    |> parse
    |> balance(seen: Map.new)
    |> IO.inspect
  end

  def parse(input) do
    input
    |> String.trim
    |> String.split("\t")
    |> Enum.map(&String.to_integer/1)
    # [0, 2, 7, 0]
    |> Enum.with_index
    |> Enum.into(Map.new, fn({number, index}) ->
      {index, number}
    end)
  end

  def balance(banks, seen: seen) do
    cycles = map_size(seen)
    if seen?(seen, banks) do
      seen_first_at = Map.fetch!(seen, banks)
      cycles - seen_first_at
    else
      new_seen = seen!(seen, banks, cycles)
      new_banks = redistribute(banks)
      balance(new_banks, seen: new_seen)
    end
  end

  def redistribute(banks) do
    {index, num_blocks} = bank_with_most_blocks(banks)
    banks = clear_bank(banks, index)
    Enum.reduce(1..num_blocks, banks, fn(offset, memory) ->
      inc_bank(memory, index + offset)
    end)
  end

  def bank_with_most_blocks(banks) do
    Enum.max_by(banks, fn({i, num}) -> {num, -i} end)
  end

  def inc_bank(banks, at) do
    index = Integer.mod(at, map_size(banks))
    {_, new_banks} =
      Map.get_and_update(banks, index, fn(value) ->
        {value, value + 1}
      end)
    new_banks
  end

  def clear_bank(banks, index) do
    Map.put(banks, index, 0)
  end

  def seen?(seen, banks) do
    Map.has_key?(seen, banks)
  end

  def seen!(seen, banks, at) do
    Map.put(seen, banks, at)
  end
end

Day06.run
