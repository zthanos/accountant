defmodule Accountant.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :transaction_type, :integer
      add :transaction_date, :naive_datetime
      add :year, :integer
      add :description, :string
      add :sales_category, :string
      add :invoice_type, :string
      add :invoice_number, :string
      add :vat_rate, :decimal
      add :net_amount, :decimal
      add :vat_amount, :decimal
      add :gross_amount, :decimal

      timestamps(type: :utc_datetime)
    end

    create index(:transactions, [:transaction_type])
  end
end
