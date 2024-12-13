defmodule AdventOfCode.Solutions.Y24.Day06 do
  alias AoC.Input

  def parse(input, _part) do
    grid =
      Input.read!(input)
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    size = grid_size(grid)
    objects = find_objects(grid)
    guard = find_guard(grid)

    {grid, size, objects, guard}
  end

  def part_one({grid, size, objects, guard}) do
    move(size, grid, objects, guard, :up, MapSet.new())
    |> Enum.count()
  end

  def part_two({grid, size, objects, guard}) do
    move(size, grid, objects, guard, :up, MapSet.new())
    |> Enum.map(fn coord ->
      check_loop(size, grid, MapSet.put(objects, coord), guard, :up, MapSet.new())
    end)
    |> Enum.count(fn val -> val == true end)
  end

  defp grid_size(grid) do
    {length(grid) - 1, length(Enum.at(grid, 0)) - 1}
  end

  defp find_guard(grid) do
    grid
    |> Enum.with_index(fn items, y ->
      Enum.with_index(items, fn char, x ->
        cond do
          char == "^" -> {x, y}
          true -> nil
        end
      end)
    end)
    |> Enum.flat_map(fn item -> item end)
    |> Enum.reject(fn item -> item == nil end)
    |> Enum.at(0)
  end

  defp find_objects(grid) do
    grid
    |> Enum.with_index(fn items, y ->
      Enum.with_index(items, fn char, x ->
        cond do
          char == "#" -> {x, y}
          true -> nil
        end
      end)
    end)
    |> Enum.flat_map(fn item -> item end)
    |> Enum.reject(fn item -> item == nil end)
    |> MapSet.new()
  end

  defp move(size, grid, objects, guard, direction, moves) do
    [can_move, can_turn, guard] = check_move(size, objects, guard, direction)

    cond do
      can_move ->
        move(size, grid, objects, guard, direction, MapSet.put(moves, guard))

      !can_move and can_turn ->
        move(size, grid, objects, guard, turn(direction), MapSet.put(moves, guard))

      !can_move and !can_turn ->
        MapSet.put(moves, guard)
    end
  end

  defp check_move({max_x, max_y}, objects, guard, direction) do
    {x, y} = next_position(guard, direction)

    cond do
      # Left the grid
      x < 0 or x > max_x or y < 0 or y > max_y ->
        [false, false, guard]

      # Hit an object
      MapSet.member?(objects, {x, y}) ->
        [false, true, guard]

      # Can move
      true ->
        [true, false, {x, y}]
    end
  end

  defp check_loop(size, grid, objects, guard, direction, moves) do
    [can_move, can_turn, guard] = check_move(size, objects, guard, direction)

    if !can_move and !can_turn do
      false
    else
      if !can_move and can_turn do
        check_loop(
          size,
          grid,
          objects,
          guard,
          turn(direction),
          MapSet.put(moves, {guard, direction})
        )
      else
        if MapSet.member?(moves, {guard, direction}) do
          true
        else
          check_loop(size, grid, objects, guard, direction, MapSet.put(moves, {guard, direction}))
        end
      end
    end
  end

  defp next_position({x, y}, direction) do
    case direction do
      :up -> {x, y - 1}
      :down -> {x, y + 1}
      :left -> {x - 1, y}
      :right -> {x + 1, y}
    end
  end

  defp turn(direction) do
    case direction do
      :up -> :right
      :right -> :down
      :down -> :left
      :left -> :up
    end
  end
end
