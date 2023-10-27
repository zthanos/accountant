defmodule AccountantWeb.IncomeLive.Index do
  use AccountantWeb, :live_view
  alias AccountantWeb.IncomeLive.TransactionComposeForm
  alias Accountant.Context.Income.Income

  @impl true
  def mount(_params, _session, socket) do
    data =
      income_data_list()
      |> Income.get_years()

    selected_year = List.first(data)

    period_data = income_data_by_year(selected_year)
    totals = Income.get_totals(period_data)

    new_socket =
      socket
      |> assign(:selected_year, selected_year)
      |> assign(:pager, data)
      |> assign(:totals, totals)
      |> stream(:income_data, period_data)

    {:ok, new_socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Εισαγωγή κίνησης")
    |> assign(:transaction, %{id: "1"})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "´Εσοδα")
    |> assign(:transaction, %TransactionComposeForm{id: "1"})
  end

  defp apply_action(socket, :edit, %{"id" => transaction_id}) do

    {:ok, transaction} =  Income.get_transaction(transaction_id)
    socket
    |> assign(:page_title, "´Εσοδα")
    |> assign(:transaction, transaction)
  end

  @impl true
  def handle_event("delete", _params, socket) do
    new_socket = delete_all(socket, income_data_list())
    {:noreply, new_socket}
  end

  @impl true
  def handle_event("fetch-year", %{"year" => year}, socket) do
    items = income_data_by_year(String.to_integer(year))
    totals = Income.get_totals(items)

    new_socket =
      socket
      |> delete_all(income_data_list())
      |> insert_all(items)
      |> assign(:totals, totals)
      |> assign(:selected_year, String.to_integer(year))

    {:noreply, new_socket}
  end

  defp insert_all(socket, list) do
    Enum.reduce(list, socket, fn item, socket ->
      stream_insert(socket, :income_data, item)
    end)
  end

  defp delete_all(socket, []) do
    socket
  end

  defp delete_all(socket, list) do
    [head | tail] = list

    delete_all(stream_delete(socket, :income_data, head), tail)
  end

  defp income_data_list() do
    case Accountant.Context.Income.Income.get_income() do
      {:ok, data} ->
        data

      {:error, _reason} ->
        []
    end
  end

  def is_selected_year(year, selected_year) do
    if year == selected_year do
      "pager-button-selected"
    else
      "pager-button"
    end
  end

  defp income_data_by_year(year) do
    Enum.filter(income_data_list(), fn x -> x.transaction_date.year == year end)
  end
end
