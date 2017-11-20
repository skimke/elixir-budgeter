defmodule Budgeter do
  alias NimbleCSV.RFC4180, as: CSV

  def list_transactions do
    File.read!("lib/transactions.csv")
    |> parse
    |> filter
    |> normalize
    |> sort
    |> print
  end

  defp parse(string) do
    CSV.parse_string(string)
  end

  defp filter(rows) do
    Enum.map(rows, &Enum.drop(&1, 1))
    # Enum.map(rows, fn(row) -> Enum.drop(row, 1) end)
  end

  defp normalize(rows) do
    Enum.map(rows, &parse_row(&1))
  end

  defp parse_row([date, desc, amount]) do
    [date, desc, to_float(amount)]
  end

  defp sort(rows) do
    Enum.sort(rows, &sort_asc_by_amount(&1, &2))
  end

  defp sort_asc_by_amount([_, _, prev_row_amt], [_, _, next_row_amt]) do
    prev_row_amt < next_row_amt
  end

  defp print(rows) do
    IO.puts "\nHere are your transactions:"
    Enum.each(rows, &print_to_console(&1))
  end

  defp print_to_console([date, desc, amount]) do
    IO.puts "\n#{date} - #{desc}: $#{convert_to_dollar(amount)}"
  end

  defp to_float(amount) do
    String.to_float(amount)
    |> abs
  end

  defp convert_to_dollar(amount) do
    :erlang.float_to_binary(amount, decimals: 2)
  end
end
