defmodule AdventOfCode.Solutions.Y24.Day05 do
  alias AoC.Input

  def parse(input, _part) do
    [rules, pages] =
      Input.read!(input)
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    rules =
      rules
      |> Enum.map(fn rule ->
        String.split(rule, "|", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)

    pages =
      pages
      |> Enum.map(fn page ->
        String.split(page, ",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    {rules, pages}
  end

  def part_one(problem) do
    {rules, pages} = problem

    pages
    |> Enum.filter(&can_update?(&1, rules))
    |> Enum.map(&Enum.at(&1, div(length(&1), 2)))
    |> Enum.sum()
  end

  def part_two(problem) do
    {rules, pages} = problem

    pages
    |> Enum.reject(&can_update?(&1, rules))
    |> Enum.map(fn list -> Enum.sort(list, &({&1, &2} in rules)) end)
    |> Enum.map(&Enum.at(&1, div(length(&1), 2)))
    |> Enum.sum()
  end

  defp can_update?([_], _) do
    true
  end

  defp can_update?([item | tail], rules) do
    Enum.all?(tail, fn next -> {item, next} in rules end) and can_update?(tail, rules)
  end
end
