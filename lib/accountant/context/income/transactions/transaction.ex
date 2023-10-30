defmodule Accountant.Context.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :transaction_type, :integer
    field :transaction_date, :naive_datetime
    field :year, :integer
    field :description, :string
    field :invoice_type, :string
    field :invoice_number, :string
    field :sales_category, :string
    field :vat_rate, :decimal
    field :net_amount, :decimal
    field :vat_amount, :decimal
    field :gross_amount, :decimal

    timestamps(type: :utc_datetime)
  end

  @required_fields [
    :description,
    :transaction_date,
    :sales_category,
    :invoice_type,
    :invoice_number,
    :net_amount,
    :vat_rate,
    :vat_amount,
    :gross_amount
  ]
  defp all_fields do
    __MODULE__.__schema__(:fields)
  end

  def changeset(attrs \\ %{}) do
    changeset(%__MODULE__{}, attrs)
  end

  def changeset(schema, attrs) do
    schema
    |> cast(attrs, all_fields())
    |> validate_required(@required_fields)
  end


end
