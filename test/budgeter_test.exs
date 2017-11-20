defmodule BudgeterTest do
  use ExUnit.Case
  doctest Budgeter

  test "greets the world" do
    assert Budgeter.hello() == :world
  end
end
