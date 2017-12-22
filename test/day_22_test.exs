ExUnit.start

defmodule Day22Test do
  Code.require_file "day_22.ex"
  use ExUnit.Case

  test "turn_left" do
    assert Day22.turn_left(%{dir:   0}).dir == 270
    assert Day22.turn_left(%{dir:  90}).dir == 0
    assert Day22.turn_left(%{dir: 180}).dir == 90
    assert Day22.turn_left(%{dir: 270}).dir == 180
  end

  test "turn_right" do
    assert Day22.turn_right(%{dir:   0}).dir == 90
    assert Day22.turn_right(%{dir:  90}).dir == 180
    assert Day22.turn_right(%{dir: 180}).dir == 270
    assert Day22.turn_right(%{dir: 270}).dir == 0
  end
end
