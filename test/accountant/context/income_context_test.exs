defmodule Accountant.Context.IncomeContextTest do
  use ExUnit.Case
  alias Accountant.Context.Income.Income

  describe "context tests" do
    @tag :cntx
    test "parse income json" do
      res = Income.get_income()
      res |> dbg()

      assert 0 == 0
    end
  end
end
