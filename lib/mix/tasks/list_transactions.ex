defmodule Mix.Tasks.ListTransactions do
  use Mix.Task

  @shortdoc "Lists all transactions from CSV file"
  def run(_) do
    Budgeter.list_transactions
  end
end