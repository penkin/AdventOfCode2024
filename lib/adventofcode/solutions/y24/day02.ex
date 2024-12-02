defmodule AdventOfCode.Solutions.Y24.Day02 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn floor ->
      floor
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def part_one(problem) do
    problem
    |> Enum.count(&check_safe/1)
  end

  def part_two(problem) do
      problem
    |> Enum.count(&make_safe/1)
  end

  defp check_safe(floor) do
    case floor do
      [] -> true
      [_] -> true
      [a, b | rest] when a > b -> check_safe_down([a, b | rest])
      [a, b | rest] when a < b -> check_safe_up([a, b | rest])
      _ -> false
    end
  end

  defp check_safe_up(floor) do
    case floor do
      [_] -> true
      [a, b | rest] when (b - a) in 1..3 -> check_safe_up([b | rest])
      _ -> false
    end
  end

  defp check_safe_down(floor) do
    case floor do
      [_] -> true
      [a, b | rest] when (a - b) in 1..3 ->
        check_safe_down([b | rest]) 
      _ -> false
    end
  end

  defp make_safe(floor) do
    if check_safe(floor) do
      true
    else
      floor
        |>Enum.with_index()
        |>Enum.any?(fn {_, index} -> 
          floor
          |>List.delete_at(index)
          |>check_safe()
        end)
    end
  end

end
