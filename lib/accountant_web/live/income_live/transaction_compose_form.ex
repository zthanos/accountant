defmodule AccountantWeb.IncomeLive.TransactionComposeForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :description, :string
    field :transaction_date, :naive_datetime
    field :sales_category, :string
    field :invoice_type, :string
    field :invoice_number, :string
    field :net_amount, Money.Ecto.Currency.Type
    field :vat_rate, Money.Ecto.Currency.Type
    field :vat_amount, Money.Ecto.Currency.Type
    field :gross_amount, Money.Ecto.Currency.Type
  end

  defp all_fields do
    __MODULE__.__schema__(:fields)
  end

  def changeset(attrs \\ %{}) do
    changeset(%__MODULE__{}, attrs)
  end

  def changeset(schema, attrs) do
    schema
    |> cast(attrs, all_fields())
  end

  def validate(changeset) do
    changeset
    |> validate_required([:description])
    |> apply_action(:new)
  end

  def to_attrs(schema) do
    Map.from_struct(schema)
  end
end
