defmodule AdventOfCode.Solutions.Y24.Day04 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.reject(fn item -> item == [] end)
  end

  def part_one(problem) do
    pattern = ["X", "M", "A", "S"]

    directions = [
      # right
      {0, 1},
      # left
      {0, -1},
      # down
      {1, 0},
      # up
      {-1, 0},
      # diagonal down-right
      {1, 1},
      # diagonal up-left
      {-1, -1},
      # diagonal down-left
      {1, -1},
      # diagonal up-right
      {-1, 1}
    ]

    for y <- 0..(length(problem) - 1),
        x <- 0..(length(Enum.at(problem, 0)) - 1),
        reduce: [] do
      acc ->
        case check_pattern(pattern, directions, problem, x, y) do
          [] -> acc
          patterns -> patterns ++ acc
        end
    end
    |> length
  end

  def part_two(problem) do
    for y <- 0..(length(problem) - 1),
        x <- 0..(length(Enum.at(problem, 0)) - 1),
        reduce: 0 do
      acc ->
        case match_x_pattern(problem, x, y) do
          true -> acc + 1
          _ -> acc
        end
    end
  end

  defp check_pattern(pattern, directions, grid, x, y) do
    directions
    |> Enum.flat_map(fn {dx, dy} ->
      if check_pattern_in_direction(pattern, grid, x, y, dx, dy) do
        [{x, y, dx, dy}]
      else
        []
      end
    end)
  end

  defp check_pattern_in_direction(pattern, grid, x, y, dx, dy) do
    Enum.with_index(pattern)
    |> Enum.all?(fn {char, index} ->
      next_x = x + index * dx
      next_y = y + index * dy

      cond do
        next_x < 0 or next_y < 0 -> false
        next_y >= length(grid) -> false
        next_x >= length(Enum.at(grid, 0)) -> false
        true -> Enum.at(grid, next_y) |> Enum.at(next_x) == to_string(char)
      end
    end)
  end

  defp match_x_pattern(grid, x, y) do
    char = to_string(Enum.at(Enum.at(grid, y), x))
    left_x = x - 1
    right_x = x + 1
    top_y = y - 1
    bottom_y = y + 1

    cond do
      "A" != char ->
        false

      left_x < 0 or top_y < 0 ->
        false

      right_x >= length(Enum.at(grid, 0)) ->
        false

      bottom_y >= length(grid) ->
        false

      true ->
        top_left = Enum.at(Enum.at(grid, top_y), left_x)
        top_right = Enum.at(Enum.at(grid, top_y), right_x)
        bottom_left = Enum.at(Enum.at(grid, bottom_y), left_x)
        bottom_right = Enum.at(Enum.at(grid, bottom_y), right_x)

        ((top_left == "M" and bottom_right == "S") or
           (top_left == "S" and bottom_right == "M")) and
          ((top_right == "M" and bottom_left == "S") or
             (top_right == "S" and bottom_left == "M"))
    end
  end
end
