defmodule Day08 do
  @input File.read!("input/day_08.txt")

  def run do
    {regs, max} =
      @input
      |> parse
      |> execute(regs: Map.new, max: 0)
      |> IO.inspect

    IO.puts "max final: #{find_largest_value(regs)}"
    IO.puts "max ever:  #{max}"
  end

  def parse(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [_, reg, op, by, expr] = Regex.run(~r/([^ ]+) (inc|dec) (-?\d+) if (.+)/, line)
    by = String.to_integer(by)
    {reg, op, by, expr}
  end

  def execute([], regs: regs, max: max), do: {regs, max}
  def execute([{reg, op, by, expr} | program], regs: regs, max: max) do
    new_regs =
      if expr?(expr, regs: regs) do
        val = read_reg(regs, reg)
        new_val = update_reg_val(val, op, by)
        write_reg(regs, reg, new_val)
      else
        regs
      end

    largest = find_largest_value(new_regs)
    new_max = if largest > max, do: largest, else: max
    execute(program, regs: new_regs, max: new_max)
  end

  def expr?(expr, regs: regs) do
    [reg, comp, compare_to] = String.split(expr, " ", parts: 3)
    val = read_reg(regs, reg)
    compare_to = String.to_integer(compare_to)
    compare(val, comp, compare_to)
  end

  def compare(value, ">",  compare_to), do: value >  compare_to
  def compare(value, "<",  compare_to), do: value <  compare_to
  def compare(value, "<=", compare_to), do: value <= compare_to
  def compare(value, ">=", compare_to), do: value >= compare_to
  def compare(value, "==", compare_to), do: value == compare_to
  def compare(value, "!=", compare_to), do: value != compare_to

  def update_reg_val(val, "inc", by), do: val + by
  def update_reg_val(val, "dec", by), do: val - by

  def find_largest_value(regs) do
    Map.values(regs) |> Enum.max
  end

  def read_reg(regs, reg) do
    Map.get(regs, reg, 0)
  end

  def write_reg(regs, reg, value) do
    Map.put(regs, reg, value)
  end
end

Day08.run
