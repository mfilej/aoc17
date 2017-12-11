ExUnit.start

defmodule Day09Test do
  Code.require_file "day_09.ex"

  use ExUnit.Case, async: true

  def score(input) do
    {score, _} = Day09.parse(input)
    score
  end

  def garbage(input) do
    {_, count} = Day09.parse(input)
    count
  end

  describe "scoring" do
    test "single group scores 1" do
      assert score("{}") == 1
    end

    test "groups nested three levels deep score 1+2+3" do
      assert score("{{{}}}") == 6
    end

    test "two groups a level deep score 1+2+2" do
      assert score("{{},{}}") == 5
    end

    test "multiple groups at three and four levels score 1+2+3+3+3+4" do
      assert score("{{{},{},{{}}}}") == 16
    end

    test "single group with garbage scores 1" do
      assert score("{<a>,<a>,<a>,<a>}") == 1
    end

    test "four groups two levels deep with garbage score 1+2+2+2+2" do
      assert score("{{<ab>},{<ab>},{<ab>},{<ab>}}") == 9
    end

    test "four groups two levels deep with negated negations score 1+2+2+2+2" do
      assert score("{{<!!>},{<!!>},{<!!>},{<!!>}}") == 9
    end

    test "group nested two levels deep with negated garbage-enders scores 1+2" do
      assert score("{{<a!>},{<a!>},{<a!>},{<ab>}}") == 3
    end
  end

  describe "garbage count" do
    test "empty garbage scores 0" do
      assert garbage("<>") == 0
    end

    test "random characters score 17" do
      assert garbage("<random characters>") == 17
    end

    test "three garbage characters score 3" do
      assert garbage("<<<<>") == 3
    end

    test "with 1 cancelled character scores 2" do
      assert garbage("<{!>}>") == 2
    end

    test "negated negation scores 0" do
      assert garbage("<!!>") == 0
    end

    test "two negations score 0" do
      assert garbage("<!!!>>") == 0
    end

    test "scores 10" do
      assert garbage("<{o\"i!a,<{i<a>") == 10
    end
  end
end
