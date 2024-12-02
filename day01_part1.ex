defmodule Day1 do
  def start() do
    {list_left, list_right} =
      File.read!("day01_data.txt")
      |> String.split("\n")
      |> Enum.filter(fn line -> line != "" end)
      |> Enum.map(fn line -> String.split(line, ~r/\s+/) end)
      |> Enum.reduce({[], []}, fn line, {left, right} ->
        {[String.to_integer(Enum.at(line, 0)) | left],
         [String.to_integer(Enum.at(line, 1)) | right]}
      end)
      |> then(fn {left, right} -> {Enum.sort(left), Enum.sort(right)} end)

    total =
      Enum.zip(list_left, list_right)
      |> Enum.map(fn {left, right} -> abs(right - left) end)
      |> Enum.sum()

    IO.inspect(total)
  end
end
