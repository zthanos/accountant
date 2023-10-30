defmodule Accountant.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Accountant.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        transaction_type: 1,
        transaction_date: ~N[2023-10-27 17:54:00],
        year: 2005,
        sales_category: "some sales_category",
        description: "some description",
        invoice_number: "some invoice_number",
        invoice_type: "some invoice_type",
        vat_rate: 18.0,
        net_amount: Money.new(100),
        vat_amount: Money.new(18),
        gross_amount: Money.new(118)
      })
      |> Accountant.Transactions.create_transaction()

    transaction
  end
end
