defmodule Accountant.Context.Transactions.TransactionsQuery do
  import Ecto.Query, warn: false

  alias Accountant.Context.Income.Transactions
  alias Accountant.Context.Transactions.Transaction
  alias Accountant.Repo

  defmodule Options do
    defstruct id: nil,
              transaction_type: 0,
              year: nil,
              limit: 40,
              offset: 0

    use ExConstructor
  end

  def paginate(params) do
    options = Options.new(params)
    query = query(options)
    transactions = query |> entries(options) |> Repo.all()
    total_count = query |> count() |> Repo.aggregate(:count, :id)
    # res = aggregate_sales(query)
    # res |> dbg()
    totals =
      Repo.all(
        from p in query,
          group_by: p.sales_category,
          select: %{
            sales_category: p.sales_category,
            net_total: sum(p.net_amount),
            vat_total: sum(p.vat_amount),
            gross_total: sum(p.gross_amount)
          }
      )

    {transactions, total_count, totals}
  end

  defp aggregate_sales(query) do
    # Group the transactions by criteria (e.g., date, category, etc.)
    query =
      query
      # Modify the grouping criteria as needed
      |> group_by([t], t.sales_category)

    # Calculate aggregate sums for net_amount and gross_amount
    query =
      query
      |> select([t], %{net_amount_sum: sum(t.net_amount), gross_amount_sum: sum(t.gross_amount)})

    # Execute the query
    [{agg_results, _}] = Repo.aggregate(query, :sum, [:net_amount_sum, :gross_amount_sum])

    # Extract the aggregate sums
    net_amount_sum = Map.get(agg_results, :net_amount_sum, 0)
    gross_amount_sum = Map.get(agg_results, :gross_amount_sum, 0)

    {net_amount_sum, gross_amount_sum}
  end

  defp query(options) do
    from(a in Transaction)
    |> filter_by_transaction_type(options)
    |> filter_by_year(options)
  end

  defp entries(query, %Options{limit: limit, offset: offset}) do
    query |> limit(^limit) |> offset(^offset)
  end

  defp count(query) do
    query |> select([:id])
  end

  defp filter_by_year(query, %Options{year: nil}), do: query

  defp filter_by_year(query, %Options{year: year}) do
    query |> where(year: ^year)
  end

  defp filter_by_transaction_type(query, %Options{transaction_type: nil}), do: query

  defp filter_by_transaction_type(query, %Options{transaction_type: transaction_type}) do
    query |> where(transaction_type: ^transaction_type)
  end
end
