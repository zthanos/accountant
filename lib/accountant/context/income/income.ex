defmodule Accountant.Context.Income.Income do
  @file_name "data/income.json"

  def get_income() do
    case File.read(@file_name) do
      {:ok, data} ->
        parsed = Jason.decode!(data)
        {:ok, parse_income(parsed)}

      {:error, error} ->
        {:error, error}
    end
  end

  def get_years(data) do
    data
    |> Enum.map(fn x -> x.transaction_date.year end)
    |> Enum.uniq()
    |> Enum.sort()
  end

  def get_totals(data) do
    data
    |> Enum.group_by(& &1.sales_category)
    |> Enum.map(fn {sales_category, category_data} ->
      net_amount = Enum.sum(Enum.map(category_data, & &1.net_amount.amount))
      total_gross_amount = Enum.sum(Enum.map(category_data, & &1.gross_amount.amount))
      vat_amount = Enum.sum(Enum.map(category_data, & &1.vat_amount.amount))

      %{
        category: sales_category,
        gross_amount: Money.parse!(total_gross_amount * 0.01),
        vat_amount: Money.parse!(vat_amount * 0.01),
        net_amount: Money.parse!(net_amount * 0.01)
      }
    end)
  end

  defp parse_income(data) do
    data
    |> Enum.map(fn row ->
      %{
        id: row["Id"],
        transaction_date: Timex.parse!(row["TransactionDate"], "{0D}/{0M}/{YY}"),
        sales_category: row["SalesCategory"],
        invoice_type: row["InvoiceType"],
        invoice_number: row["InvoiceNumber"],
        description: row["Description"],
        net_amount: Money.parse!(Decimal.new(row["NetAmount"])),
        vat_rate: row["VatRate"],
        vat_amount: Money.parse!(Decimal.new(row["VatAmount"])),
        gross_amount: Money.parse!(Decimal.new(row["GrossAmount"]))
      }
    end)
  end

  def create_transaction(attr \\ %{}) do
    {:ok, %{}}
  end

  def get_transaction(id) do
    {:ok, data} = get_income()
    transaction = Enum.find(data, fn x -> x.id == id end)
    transaction |> dbg()
    {:ok, transaction}
  end
end
