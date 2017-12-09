defmodule Day07 do
  @input File.read!("input/day_07.txt")

  defmodule Node do
    defstruct [:name, :weight, :descendants]
  end

  def run(:a) do
    @input
    |> parse
    |> find_root
    |> IO.inspect
  end

  def run(:b) do
    nodes = parse(@input)
    root_name = find_root(nodes)
    build_tree(nodes, root_name)
    |> find_imbalance
    |> IO.inspect
  end

  def parse(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Stream.map(&parse_line/1)
    |> Enum.into(%{})
  end

  def parse_line(line) do
    matches = Regex.named_captures(~r/(?<name>[^ ]+) \((?<weight>\d+)\)( -> (?<programs>.+))?/, line)
    weight = String.to_integer(matches["weight"])
    programs =
      matches["programs"]
      |> String.split(", ")
      |> Enum.reject(fn "" -> true; _ -> false end)
    {matches["name"], {weight, programs}}
  end

  def find_root(nodes) do
    parents =
      Stream.map(nodes, fn({name, _}) -> name end)
      |> Enum.into(MapSet.new)
    descendants =
      Enum.flat_map(nodes, fn({_, {_, programs}}) -> programs end)
      |> Enum.into(MapSet.new)

    [root_name] = MapSet.difference(parents, descendants) |> Enum.to_list
    root_name
  end

  # def build_tree(nodes, "vfjnsd" = node_name) do
  #   {weight, programs} = Map.fetch!(nodes, node_name)
  #                        |> IO.inspect

  # end
  def build_tree(nodes, node_name) do
    {weight, programs} = Map.fetch!(nodes, node_name)
    descendants = Enum.map(programs, fn(program_name) -> build_tree(nodes, program_name) end)
    %Node{name: node_name, weight: weight, descendants: descendants}
  end

  def find_imbalance(%Node{weight: weight, descendants: []}) do
    weight
  end
  def find_imbalance(%Node{name: name, weight: weight, descendants: descendants}) do
    weights = Enum.map(descendants, &find_imbalance/1)
    case Enum.uniq(weights) do
      [_w] -> weight + Enum.sum(weights)
      imba -> output_imbalance(descendants, weights)
    end
  end

  def output_imbalance(nodes, subtree_weights) do
  end
end

Day07.run(:b)
