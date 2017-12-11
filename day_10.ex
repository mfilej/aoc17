defmodule Day10 do
  defmodule Ring do
    defstruct [:size, :list, :pos, :skip]

    def new(size, pos \\ 0) do
      list = Enum.to_list(0..(size - 1))
      %Ring{list: list, size: size, pos: pos, skip: 0}
    end

    def slice(%Ring{size: size, pos: pos} = ring, amount) when pos < size do
      result = Enum.slice(ring.list, ring.pos, amount)
      length = length(result)
      if length < amount do
        rest = Enum.slice(ring.list, 0, amount - length)
        result ++ rest
      else
        result
      end
    end

    def replace(%Ring{} = ring, []) do
      ring
    end
    def replace(%Ring{size: size, pos: pos} = ring, sublist) when pos >= size do
      replace(%{ring | pos: pos - size}, sublist)
    end
    def replace(%Ring{} = ring, [h | rest]) do
      new_list = List.replace_at(ring.list, ring.pos, h)
      new_ring = %{ring | list: new_list, pos: ring.pos + 1}
      replace(new_ring, rest)
    end
  end

  def run(:a, lengths, upto) do
    ring = Ring.new(upto)
    ring = tie(lengths, ring)

    [a, b | _] = ring.list
    {a, b, a * b}
  end
  def run(:b, lengths, upto) do
    lengths
    |> Enum.join(",")
    |> to_charlist()

    |> Enum.concat([17, 31, 73, 47, 23])
    |> sparse_hash(upto)
    |> dense_hash
    |> knot_hash
  end

  def sparse_hash(lengths, upto) do
    ring =
      Enum.reduce(1..64, Ring.new(upto), fn(_, ring) -> tie(lengths, ring) end)
    ring.list
  end

  def dense_hash(list) do
    import Bitwise

    list
    |> Stream.chunk_every(16)
    |> Stream.map(fn(block) -> Enum.reduce(block, 0, &(&1 ^^^ &2)) end)
  end

  def knot_hash(blocks) do
    blocks
    |> Stream.map(&to_hex/1)
    |> Enum.join
  end

  def to_hex(number) do
    number
    |> Integer.to_string(16)
    |> String.pad_leading(2, "0")
    |> String.downcase
  end

  def tie([], ring) do
    ring
  end
  def tie([len | lengths], ring) do
    sublist = Ring.slice(ring, len)
    sublist = Enum.reverse(sublist)
    ring = Ring.replace(ring, sublist)
    pos = rem(ring.pos + ring.skip, ring.size)
    ring = %{ring | pos: pos, skip: ring.skip + 1}

    tie(lengths, ring)
  end
end

input = [94, 84, 0, 79, 2, 27, 81, 1, 123, 93, 218, 23, 103, 255, 254, 243]
Day10.run(:a, input, 256) |> IO.inspect
Day10.run(:b, input, 256) |> IO.inspect
