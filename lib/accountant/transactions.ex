defmodule Accountant.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Accountant.Repo

  alias Accountant.Context.Transactions.Transaction

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def create_income_transaction(attrs \\ %{}) do
    vat_amount = Money.to_string(Map.get(attrs, :vat_amount), delimeter: ".", separator: "")
    net_amount = Money.to_string(Map.get(attrs, :net_amount), delimeter: ".", separator: "")
    gross_amount = Money.to_string(Map.get(attrs, :gross_amount), delimeter: ".", separator: "")

    updated_attrs =
      attrs
      |> Map.update(:transaction_type, 0, &(&1 || 0))
      |> Map.update(:year, Map.get(attrs, :transaction_date).year, &(&1 || nil))
      |> Map.update(
        :net_amount,
        net_amount,
        &(Decimal.new(Money.to_string(&1, delimeter: ".", separator: "")) || nil)
      )
      |> Map.update(
        :vat_amount,
        Decimal.new(vat_amount),
        &(Decimal.new(Money.to_string(&1, delimeter: ".", separator: "")) || nil)
      )
      |> Map.update(
        :gross_amount,
        Decimal.new(gross_amount),
        &(Decimal.new(Money.to_string(&1, delimeter: ".", separator: "")) || nil)
      )

    case %Transaction{}
         |> Transaction.changeset(updated_attrs)
         |> Repo.insert() do
      {:ok, transaction} -> {:ok, transaction}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end

  def import() do
    {:ok, data} = Accountant.Context.Income.Income.get_income()

    for row <- data do
      create_income_transaction(row)
    end
  end
end
