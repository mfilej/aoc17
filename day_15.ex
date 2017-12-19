defmodule Day15 do
  @start_a 618
  @start_b 814
  @multi_a 16_807
  @multi_b 48_271
  @factor_filter_a 4
  @factor_filter_b 8
  @divisor 2147483647
  @bitmask 0xFFFF

  def run(:a, steps) do
    start_values = {
      @start_a,
      @start_b
    }
    generators = {
      &rem(&1 * @multi_a, @divisor),
      &rem(&1 * @multi_b, @divisor),
    }
    duel(steps, 0, start_values, generators)
  end
  def run(:b, steps) do
    start_values = {
      @start_a,
      @start_b
    }
    generators = {
      &generate(&1, @multi_a, @factor_filter_a),
      &generate(&1, @multi_b, @factor_filter_b),
    }
    duel(steps, 0, start_values, generators)
  end

  def duel(0, count, _, _) do
    count
  end
  def duel(steps, count, {a, b}, {gen_a, gen_b}) do
    a = gen_a.(a)
    b = gen_b.(b)

    duel(steps - 1, update_count(count, {a, b}), {a, b}, {gen_a, gen_b})
  end

  def update_count(count, {a, b}) do
    import Bitwise

    if band(a, @bitmask) == band(b, @bitmask) do
      count + 1
    else
      count
    end
  end

  def generate(num, multi, factor_filter) do
    num = rem(num * multi, @divisor)
    if rem(num, factor_filter) != 0 do
      generate(num, multi, factor_filter)
    else
      num
    end
  end

end

IO.puts "Part 1:"
Day15.run(:a, 40_000_000) |> IO.inspect
IO.puts "Part 2:"
Day15.run(:b,  5_000_000) |> IO.inspect
