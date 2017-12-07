defmodule Day03 do
  @input 312_051

  def run(:a) do
    start = {{0, 0}, :> }
    check(start, step: 1, address: 1)
  end

  def move({{x, y}, :>}, step: step, address: address) do
    check({{x + step, y}, :A}, step: step, address: (address + step))
  end
  def move({{x, y}, :A}, step: step, address: address) do
    check({{x, y + step}, :<}, step: step + 1, address: (address + step))
  end
  def move({{x, y}, :<}, step: step, address: address) do
    check({{x - step, y}, :V}, step: step, address: (address + step))
  end
  def move({{x, y}, :V}, step: step, address: address) do
    check({{x, y - step}, :>}, step: step + 1, address: (address + step))
  end

  def check({{x, y}, dir}, step: step, address: address)
  when address + step >= @input do
    IO.inspect({{{x, y}, dir}, {:step, step}, {:add, address}, {:in, @input}})
  end
  def check(state, args) do
    move(state, args)
  end
end

Day03.run(:a)
