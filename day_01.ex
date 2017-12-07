defmodule Day1 do
  @input File.read!("input/day_01.txt")
  @n String.length(@input)

  def run(:a) do
    last_chr = String.at(@input, -1)
    sum_repeating_digits(last_chr <> @input, 0, 0)
    |> IO.inspect
  end
  def run(:b) do
    sum_opposite_digits()
    |> IO.inspect
  end

  def sum_repeating_digits(
    <<first::bytes-size(1)>> <> <<first::bytes-size(1)>> <> rest,
    sum, seq
  ) do
    new_seq = seq + 1
    sum_repeating_digits(first <> rest, sum, new_seq)
  end
  def sum_repeating_digits(
    <<first::bytes-size(1)>> <> <<next::bytes-size(1)>> <> rest,
    sum, seq
  ) do
    val = String.to_integer(first)
    new_sum = sum + seq * val
    sum_repeating_digits(next <> rest, new_sum, 0)
  end
  def sum_repeating_digits(<<_::bytes-size(1)>>, sum, 0) do
    sum
  end

  def sum_opposite_digits do
    String.codepoints(@input)
    |> Enum.with_index
    |> Enum.reduce(0, fn({digit, i}, sum) ->
      opposite_digit = String.at(@input, opposite_index(i))
      val =
        if digit == opposite_digit do
          String.to_integer(digit)
        else
          0
        end

      sum + val
    end)
  end

  defp opposite_index(i) do
    offset = div(@n, 2)
    Integer.mod(i + offset, @n)
  end
end

Day1.run(:b)
