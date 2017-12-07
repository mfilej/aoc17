defmodule Day05 do
  @input File.read!("input/day_05.txt")
  @part :b

  def run do
    @input
    |> parse
    |> execute(0, jumps: 0)
    |> IO.inspect
  end

  def execute(program, pc, jumps: jumps) do
    if Map.has_key?(program, pc) do
      {jump_by, new_program} = take_instruction_at(program, pc)
      new_pc = pc + jump_by
      IO.inspect(jumps)
      execute(new_program, new_pc, jumps: jumps + 1)
    else
      jumps
    end
  end

  def take_instruction_at(program, pc) do
    Map.get_and_update(program, pc, fn(offset) ->
      {offset, new_offset(offset, @part)}
    end)
  end

  def new_offset(offset, :b) when offset > 2 do
    offset - 1
  end
  def new_offset(offset, _part) do
    offset + 1
  end

  def parse(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Stream.map(&String.to_integer/1)
    |> Stream.with_index
    |> Enum.into(Map.new, fn({number, index}) ->
      {index, number}
    end)
  end
end

Day05.run
