defmodule Day20 do
  @input File.read!("input/day_20.txt")

  defmodule Pos do
    def new({x, y, z}) do
      %{x: x, y: y, z: z, sum: manhattan(x, y, z)}
    end

    def update(pos, by: by) do
      x = pos.x + by.x
      y = pos.y + by.y
      z = pos.z + by.z
      new({x, y, z})
    end

    def manhattan(x, y, z) do
      abs(x) + abs(y) + abs(z)
    end
  end

  defmodule Particle do
    defstruct [:p, :v, :a, :index]

    def new(index, p: p, v: v, a: a) do
      %__MODULE__{index: index, p: Pos.new(p), v: Pos.new(v), a: Pos.new(a)}
    end

    def tick(%Particle{p: p, v: v, a: a} = particle) do
      v = Pos.update(v, by: a)
      p = Pos.update(p, by: v)
      %{particle | v: v, p: p}
    end
  end

  def run(part) do
    @input |> parse |> Enum.to_list |> loop(part)
  end

  def loop(particles, :a) do
    IO.inspect find_closest(particles)
    particles
    |> Enum.map(particles, &Particle.tick/1)
    |> loop(:a)
  end
  def loop(particles, :b) do
    particles |> tick_boom() |> loop(:b)
  end

  def tick_boom(particles) do
    IO.puts(length(particles))
    particles
    |> remove_collisions
    |> Enum.map(&Particle.tick/1)
  end

  def remove_collisions(particles) do
    particles
    |> Enum.group_by(fn %Particle{p: pos} -> pos end)
    |> Enum.filter(fn {_k, val} -> length(val) == 1 end)
    |> Enum.map(fn {_, [particle]} -> particle end)
  end

  def find_closest(particles) do
    Enum.min_by(particles, fn {_i, %Particle{p: %{sum: sum}}} -> sum end)
  end

  def parse(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Stream.with_index
    |> Stream.map(&parse_line/1)
  end

  def parse_line({line, index}) do
    [_ | pva] = Regex.run(~r/p=<([^>]+)>, v=<([^>]+)>, a=<([^>]+)>/, line)
    [p, v, a] =
      Enum.map(pva, fn pos ->
        pos
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple
      end)
    Particle.new(index, p: p, v: v, a: a)
  end
end

Day20.run(:b)
