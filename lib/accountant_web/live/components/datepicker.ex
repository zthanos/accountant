defmodule AccountantWeb.Components.Datepicker do
  use Phoenix.LiveComponent

  defmodule DatepickerStruct do
    use ExConstructor
    defstruct ~w[date prefix month suffix description]a
  end

  @max_display_days 6 * 7
  @month_names [
    "Ιανουάριος",
    "Φεβρουάριος",
    "Μάρτιος",
    "Απρίος",
    "Μαιος",
    "Ιούνιος",
    "Ιούλιος",
    "Αύγουστος",
    "Σεμπτέμβριος",
    "Οκτώβριος",
    "Νοέμβριος",
    "Δεκέμβριος"
  ]
  @week_days ["Δε", "Τρ", "Τε", "Πε", "Πα", "Σα", "Κυ"]

  @impl true
  def mount(socket) do
    # max_display_days = 35
    # Date.new!(2023, 10, 12, Calendar.ISO)
    date =
      Date.utc_today()

    date_grid = get_month_grid!(date)
    date_grid |> dbg()
    {:ok, apply_changes(socket, date_grid)}
  end

  @impl true
  def handle_event("prev_month", _assigns, socket) do
    date = Timex.shift(socket.assigns.selected_date, months: -1)
    date_grid = get_month_grid!(date)

    {:noreply, apply_changes(socket, date_grid)}
  end

  def handle_event("next_month", _params, socket) do
    date = Timex.shift(socket.assigns.selected_date, months: 1)
    date_grid = get_month_grid!(date)

    {:noreply, apply_changes(socket, date_grid)}
  end

  def handle_event("date_selected", %{"date" => date}, socket) do
    selected =
      Date.new!(
        socket.assigns.current_year,
        socket.assigns.current_month,
        String.to_integer(date),
        Calendar.ISO
      )

    selected |> dbg()

    date_grid = get_month_grid!(selected)

    {:noreply, apply_changes(socket, date_grid)}
  end

  defp apply_changes(socket, date_grid) do
    socket
    |> assign(:selected_date, date_grid.date)
    |> assign(:prefix, date_grid.prefix)
    |> assign(:month, date_grid.month)
    |> assign(:suffix, date_grid.suffix)
    |> assign(:month_name, date_grid.description)
    |> assign(:week_names, @week_days)
    |> assign(:current_month, date_grid.date.month)
    |> assign(:current_year, date_grid.date.year)
  end

  defp get_month_grid!(date) do
    previous_month = Timex.shift(date, months: -1)
    days_in_month = Date.days_in_month(date)
    first_day_of_month = Date.beginning_of_month(date)

    previous_month_days = Date.days_in_month(previous_month)
    first_day_of_week = Date.day_of_week(first_day_of_month)
    prefix_days = rem(first_day_of_week + 5, 7)
    suffix_days = @max_display_days - days_in_month - prefix_days - 1

    data = %{
      date: date,
      prefix: Range.new(previous_month_days - prefix_days, previous_month_days),
      month: Range.new(1, Date.days_in_month(date)),
      suffix: Range.new(1, suffix_days),
      description: get_month(date.month)
    }

    DatepickerStruct.new(data)
  end

  defp get_month(month) do
    Enum.at(@month_names, month - 1)
  end

  defp is_selected_date(selected_date, descr) do
    selected_date.day |> dbg()
    descr |> dbg()

    if selected_date == descr do
      "hover:bg-blue-300 text-xs text-blue-400"
    else
      "hover:bg-blue-300 text-xs text-blue-200"
    end
  end

  defp is_weekend(idx) do
    if idx > 0 and (Integer.mod(idx, 5) == 0 or Integer.mod(idx, 6) == 0) do
      "m-1 text-red-400"
    else
      "m-1"
    end
  end

  # defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
