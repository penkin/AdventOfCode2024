defmodule AdventOfCode.Solutions.Y24.Day07 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n")
    |> Enum.reject(fn item -> item == "" end)
    |> Enum.map(fn item ->
      [total, numbers] = String.split(item, ": ")

      {
        String.to_integer(total),
        String.split(numbers, " ")
        |> Enum.map(&String.to_integer/1)
      }
    end)
  end

  def part_one(problem) do
    process(problem, false)
  end

  def part_two(problem) do
    process(problem, true)
  end

  defp process(input, can_concat) do
    input
    |> Enum.map(fn {total, [first | rest]} ->
      if check(total, first, rest, can_concat) do
        total
      else
        0
      end
    end)
    |> Enum.sum()
  end

  defp check(total, first, [second | rest], can_concat) do
    cond do
      check(total, first + second, rest, can_concat) -> true
      check(total, first * second, rest, can_concat) -> true
      true -> can_concat and check(total, concat(first, second), rest, can_concat)
    end
  end

  defp check(total, amount, [], _), do: amount == total

  defp concat(first, second) do
    String.to_integer("#{first}#{second}")
  end
end
