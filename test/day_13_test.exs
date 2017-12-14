ExUnit.start

defmodule Day13Test do
  Code.require_file "day_13.ex"
  use ExUnit.Case
  alias Day13.Layer

  test "Layer.step" do
    layer = Layer.new([0, 3])
    assert layer.pos == 1

    layer = Layer.step(layer)
    assert layer.pos == 2

    layer = Layer.step(layer)
    assert layer.pos == 3

    layer = Layer.step(layer)
    assert layer.pos == 2

    layer = Layer.step(layer)
    assert layer.pos == 1

    layer = Layer.step(layer)
    assert layer.pos == 2
  end

  test "example" do
    layers = [
      Layer.new([0, 3]),
      Layer.new([1, 2]),
      Layer.new([4, 4]),
      Layer.new([6, 4]),
    ]
    state = Day13.init_state
    Day13.trip(layers, state)
    |> IO.inspect
  end
end
