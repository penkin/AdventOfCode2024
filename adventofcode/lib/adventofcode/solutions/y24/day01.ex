defmodule AdventOfCode.Solutions.Y24.Day01 do
  alias AoC.Input

  def parse(input, _part) do
    {left, right} =
      Input.read!(input)
      |> String.split("\n")
      |> Enum.filter(fn line -> line != "" end)
      |> Enum.map(fn item -> String.split(item, ~r/\s+/) end)
      |> Enum.reduce({[], []}, fn item, {left, right} ->
        {[String.to_integer(Enum.at(item, 0)) | left],
         [String.to_integer(Enum.at(item, 1)) | right]}
      end)
      |> then(fn {left, right} -> {Enum.sort(left), Enum.sort(right)} end)

    Enum.zip(left, right)
  end

  def part_one(problem) do
    problem
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def part_two(problem) do
    problem
    |> Enum.unzip()
    |> then(fn {left, right} -> {left, Enum.frequencies(right)} end)
    |> then(fn {left, frequencies} ->
      left
      |> Enum.map(fn x -> x * Map.get(frequencies, x, 0) end)
      |> Enum.sum()
    end)
  end
end
