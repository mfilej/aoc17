defmodule Day17 do
  @input 324
  @upto 2017

  def run do
    step(@input, @upto, initial_state())
  end

  def step(_, upto, %{buf: buf, pos: pos, inc: inc}) when inc > upto do
    Enum.slice(buf, pos, 2)
  end
  def step(num, upto, state) do
    pos = next_pos(num, state)
    state = insert_at(state, pos)
    step(num, upto, state)
  end

  def next_pos(step, %{buf: buf} = state) when step >= length(buf) do
    step = rem(length(buf), step)
    next_pos(step, state)
  end
  def next_pos(step, %{buf: buf, pos: pos}) when step + pos >= length(buf) do
    step - (length(buf) - pos)
  end
  def next_pos(step, %{pos: pos}) do
    step + pos
  end

  def insert_at(%{buf: buf, inc: inc}, index) do
    buf = List.insert_at(buf, index+1, inc)
    %{buf: buf, pos: index+1, inc: inc+1}
  end

  def initial_state do
    %{pos: 0, buf: [0], inc: 1}
  end
end

Day17.run |> IO.inspect
