defmodule Accountant.Context.Transactions.IncomeTransactions do
  import Ecto.Query, warn: false

  alias Accountant.Repo

  alias Accountant.Context.Transactions.{TransactionsQuery, Transaction}

  def list_transactions(year) do
    TransactionsQuery.paginate(%{transaction_type: 0, year: year})
  end

  def get_transaction(id) do
    Repo.get!(Transaction, id)
  end
end
