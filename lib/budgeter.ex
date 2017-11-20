defmodule Budgeter do
  alias NimbleCSV.RFC4180, as: CSV
  import Number.Currency

  def list_transactions(sort_direction \\ :asc, currency \\ "$") do
    File.read!("lib/transactions.csv")
    |> parse
    |> filter
    |> normalize
    |> sort(sort_direction)
    |> print(currency)
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

  defp sort(rows, sort_direction) do
    Enum.sort(rows, &sort_by_amount(&1, &2, sort_direction))
  end

  defp sort_by_amount([_, _, prev_row_amt], [_, _, next_row_amt], sort_direction) do
    case sort_direction do
      :asc -> prev_row_amt < next_row_amt
      :desc -> prev_row_amt > next_row_amt
      _ -> raise ArgumentError, message: "Invalid argument for sorting"
    end
  end

  defp print(rows, currency) do
    IO.puts "\nHere are your transactions:"
    Enum.each(rows, &print_to_console(&1, currency))
  end

  defp print_to_console([date, desc, amount], currency) do
    IO.puts "\n#{date} - #{desc}: #{convert_to_currency(amount, currency)}"
  end

  defp to_float(amount) do
    String.to_float(amount)
    |> abs
  end

  defp convert_to_currency(amount, currency) do
    # "$" <> :erlang.float_to_binary(amount, decimals: 2)
    Number.Currency.number_to_currency(amount, unit: currency)
  end
end
