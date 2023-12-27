defmodule AccountantWeb.Components.Datepicker do
  use Phoenix.LiveComponent
  alias AccountantWeb.Components.DateGridView

  defmodule DatepickerStruct do
    use ExConstructor
    defstruct ~w[date prefix month suffix description]a
  end

  @impl true
  def update(assigns, socket) do
    date_grid = DateGridView.new(assigns.id, Date.utc_today())
    {:ok, socket |> assign(:data, date_grid)}
  end

  @impl true
  def handle_event("prev_month", _assigns, socket) do
    date_grid = DateGridView.shift_month(socket.assigns.data, -1)
    {:noreply, socket |> assign(:data, date_grid)}
  end

  def handle_event("next_month", _params, socket) do
    date_grid = DateGridView.shift_month(socket.assigns.data, 1)
    {:noreply, socket |> assign(:data, date_grid)}
  end

  def handle_event("date_selected", %{"date" => date}, socket) do
    date_grid = DateGridView.select_date(socket.assigns.data, NaiveDateTime.from_iso8601!(date))
    {:noreply, socket |> assign(:data, date_grid)}
  end

  def handle_event("current_date_selected", _params, socket) do
    date_grid = DateGridView.select_date(socket.assigns.data, NaiveDateTime.utc_now(:second))
    {:noreply, socket |> assign(:data, date_grid)}
  end

  defp format_date(date) do
    cond do
      date.selected -> "hover:bg-blue-300 text-xs text-blue-700 border border-solid"
      date.current_month -> "hover:bg-blue-300 text-xs text-blue-200"
      true -> "hover:bg-blue-300 text-xs m-1 text-gray-400"
    end
  end

  defp is_weekend(idx) do
    if idx > 0 and (Integer.mod(idx, 5) == 0 or Integer.mod(idx, 6) == 0) do
      "m-1 text-red-400"
    else
      "m-1"
    end
  end
end
