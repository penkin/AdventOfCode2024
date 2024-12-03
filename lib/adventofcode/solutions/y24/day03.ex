defmodule AdventOfCode.Solutions.Y24.Day03 do
  alias AoC.Input

  def parse(input, _part) do
    data = Input.read!(input)

    Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)|(don\'t\(\))|(do\(\))/, data, capture: :all)
    |> Enum.map(fn
      ["mul(" <> _, x, y] -> [String.to_integer(x), String.to_integer(y)]
      ["don't()", _, _, _] -> ["don't()"]
      ["do()", _, _, _, _] -> ["do()"]
    end)
  end

  def part_one(problem) do
    problem
    |> Enum.reject(fn item -> item == ["don't()"] end)
    |> Enum.reject(fn item -> item == ["do()"] end)
    |> Enum.reduce(0, fn [x, y], acc -> acc + x * y end)
  end

  def part_two(problem) do
    process(problem, 0, true)
  end

  defp process([], result, _), do: result

  defp process([item | rest], result, must_process) do
    case item do
      ["do()"] ->
        process(rest, result, true)

      ["don't()"] ->
        process(rest, result, false)

      [x, y] ->
        result =
          case must_process do
            true -> result + x * y
            _ -> result
          end

        process(rest, result, must_process)

      _ ->
        process(rest, result, must_process)
    end
  end
end
