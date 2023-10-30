defmodule Accountant.TransactionsTest do
  use Accountant.DataCase

  alias Accountant.Transactions

  describe "transactions" do
    alias Accountant.Transactions.Transaction

    import Accountant.TransactionsFixtures

    @invalid_attrs %{
      description: nil,
      gross_amount: nil,
      invoice_number: nil,
      invoice_type: nil,
      net_amount: nil,
      sales_category: nil,
      transaction_date: nil,
      vat_amount: nil,
      vat_rate: nil
    }

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{
        description: "some description",
        gross_amount: "some gross_amount",
        invoice_number: "some invoice_number",
        invoice_type: "some invoice_type",
        net_amount: "some net_amount",
        sales_category: "some sales_category",
        transaction_date: ~N[2023-10-27 17:54:00],
        vat_amount: "some vat_amount",
        vat_rate: "some vat_rate"
      }

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.description == "some description"
      assert transaction.gross_amount == "some gross_amount"
      assert transaction.invoice_number == "some invoice_number"
      assert transaction.invoice_type == "some invoice_type"
      assert transaction.net_amount == "some net_amount"
      assert transaction.sales_category == "some sales_category"
      assert transaction.transaction_date == ~N[2023-10-27 17:54:00]
      assert transaction.vat_amount == "some vat_amount"
      assert transaction.vat_rate == "some vat_rate"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()

      update_attrs = %{
        description: "some updated description",
        gross_amount: "some updated gross_amount",
        invoice_number: "some updated invoice_number",
        invoice_type: "some updated invoice_type",
        net_amount: "some updated net_amount",
        sales_category: "some updated sales_category",
        transaction_date: ~N[2023-10-28 17:54:00],
        vat_amount: "some updated vat_amount",
        vat_rate: "some updated vat_rate"
      }

      assert {:ok, %Transaction{} = transaction} =
               Transactions.update_transaction(transaction, update_attrs)

      assert transaction.description == "some updated description"
      assert transaction.gross_amount == "some updated gross_amount"
      assert transaction.invoice_number == "some updated invoice_number"
      assert transaction.invoice_type == "some updated invoice_type"
      assert transaction.net_amount == "some updated net_amount"
      assert transaction.sales_category == "some updated sales_category"
      assert transaction.transaction_date == ~N[2023-10-28 17:54:00]
      assert transaction.vat_amount == "some updated vat_amount"
      assert transaction.vat_rate == "some updated vat_rate"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_transaction(transaction, @invalid_attrs)

      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end
