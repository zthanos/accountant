defmodule AccountantWeb.Components.DateGridView do
  defstruct [
    :selected_date,
    :view_date,
    :month_name,
    :week_names,
    :current_month,
    :current_year,
    :popover_id,
    :anchor_id,
    :dates
  ]

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
  @case_week_start 1
  @offset_for_case 1

  def new(id, date) do
    date_grid = get_month_grid!(date, date)

    %__MODULE__{
      %__MODULE__{}
      | selected_date: date,
        view_date: date,
        month_name: date_grid.description,
        week_names: @week_days,
        current_month: date_grid.date.month,
        current_year: date_grid.date.year,
        popover_id: "popover-" <> id,
        anchor_id: "anchor-" <> id,
        dates: date_grid.dates
    }
  end

  def shift_month(%__MODULE__{} = data, step) do
    date = Timex.shift(data.view_date, months: step)
    date_grid = get_month_grid!(date, data.selected_date)

    %__MODULE__{
      data
      | view_date: date,
        month_name: date_grid.description,
        current_month: date_grid.date.month,
        current_year: date_grid.date.year,
        dates: date_grid.dates
    }
  end

  def select_date(%__MODULE__{} = data, date) do
    date_grid = get_month_grid!(date, date)

    %__MODULE__{
      data
      | selected_date: date,
        month_name: date_grid.description,
        current_month: date_grid.date.month,
        current_year: date_grid.date.year
    }
  end

  def update_selected_date(data, new_date) do
    %__MODULE__{data | selected_date: new_date}
  end

  def update_view_date(data, new_date) do
    %__MODULE__{data | view_date: new_date}
  end

  defp get_month_grid!(date, selected_date) do
    first_day_of_month = Date.beginning_of_month(date)
    first_day_of_week = Date.beginning_of_month(date) |> Date.day_of_week()

    prefix =
      case first_day_of_week do
        @case_week_start -> to_negative(length(@week_days))
        _ -> to_negative(first_day_of_week + @offset_for_case)
      end

    min_date = Timex.shift(first_day_of_month, days: prefix)
    max_date = Timex.shift(min_date, days: @max_display_days) |> dbg()

    # max_date = Timex.shift(last_day_of_month, days:  @max_display_days - days_in_month - prefix )
    dates =
      Timex.Interval.new(from: min_date, until: max_date)
      |> Timex.Interval.with_step(days: 1)
      |> Enum.map(fn x ->
        %{
          day: x,
          selected: Timex.compare(x, selected_date) == 0,
          current_month: x.month == date.month
        }
      end)

    %{
      :view_date => date,
      :date => selected_date,
      :description => get_month(date.month),
      :dates => dates
    }
  end

  defp to_negative(num), do: num * -1

  defp get_month(month) do
    Enum.at(@month_names, month - 1)
  end
end
