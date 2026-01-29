defmodule Issues.Table do
  @values_sep " | "
  @divider_sep "-+-"
  @divider_sec "-"

  def format(issues_list, columns) do
    sizes = calculate_columns_sizes(issues_list, columns)

    [
      header(columns, sizes),
      divider(sizes)
      | body(issues_list, columns, sizes)
    ]
    |> Enum.join("\n")
  end

  defp header(columns, sizes), do: format_line(columns, sizes)

  defp divider(sizes) do
    sizes
    |> Enum.map_join(@divider_sep, &String.duplicate(@divider_sec, &1))
  end

  defp body(issues_list, columns, sizes) do
    issues_list
    |> Enum.map(&format_line(row_values(&1, columns), sizes))
  end

  defp format_line(values, sizes) do
    Enum.zip(values, sizes)
    |> Enum.map_join(@values_sep, fn {c, s} -> String.pad_trailing(c, s) end)
  end

  defp calculate_columns_sizes(issues_list, columns) do
    columns
    |> Enum.map(fn col ->
      all_values = [col | column_values(issues_list, col)]

      all_values
      |> Enum.map(&String.length/1)
      |> Enum.max()
    end)
  end

  defp row_values(issue, columns) do
    for col <- columns, do: to_string(issue[col])
  end

  defp column_values(issues_list, column) do
    for issue <- issues_list, do: to_string(issue[column])
  end
end
