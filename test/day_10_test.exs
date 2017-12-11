ExUnit.start

defmodule Day10Test do
  Code.require_file "day_10.ex"

  use ExUnit.Case, async: true

  alias Day10.Ring

  test "slice" do
    assert Ring.slice(Ring.new(5, 0), 2) == [0, 1]
    assert Ring.slice(Ring.new(5, 3), 3) == [3, 4, 0]
    assert Ring.slice(Ring.new(5, 4), 3) == [4, 0, 1]
  end

  test "replace" do
    assert Ring.replace(Ring.new(5, 0), [9, 9]).list == [9, 9, 2, 3, 4]
    assert Ring.replace(Ring.new(5, 1), [9, 9]).list == [0, 9, 9, 3, 4]
    assert Ring.replace(Ring.new(5, 2), [9, 9]).list == [0, 1, 9, 9, 4]
    assert Ring.replace(Ring.new(5, 3), [9, 9]).list == [0, 1, 2, 9, 9]
    assert Ring.replace(Ring.new(5, 4), [9, 9]).list == [9, 1, 2, 3, 9]
    assert Ring.replace(Ring.new(5, 8), [9, 9]).list == [0, 1, 2, 9, 9]
  end

  test "step-by-step" do
    ring = Day10.tie([3], Ring.new(5))
    assert ring.list == [2, 1, 0, 3, 4]
    assert ring.pos  == 3
    assert ring.skip == 1

    ring = Day10.tie([4], ring)
    assert ring.list == [4, 3, 0, 1, 2]
    assert ring.pos  == 3
    assert ring.skip == 2

    ring = Day10.tie([1], ring)
    assert ring.list == [4, 3, 0, 1, 2]
    assert ring.pos  == 1
    assert ring.skip == 3

    ring = Day10.tie([5], ring)
    assert ring.list == [3, 4, 2, 1, 0]
    assert ring.pos  == 4
    assert ring.skip == 4

    ring = Day10.tie([], ring)
    assert ring.list == [3, 4, 2, 1, 0]
    assert ring.pos  == 4
    assert ring.skip == 4
  end

  test "test example" do
    assert Day10.run(:a, [3, 4, 1, 5], 5) == {3, 4, 12}
  end
end
