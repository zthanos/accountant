defmodule AccountantWeb.DateComponents do
  use Phoenix.Component
  import AccountantWeb.CoreComponents
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "date",
    values: ~w(date datetime-local)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:current_date]"

  attr :errors, :list, default: []

  attr :date_format, :string, default: "DD/MM/YYYY"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  slot :inner_block

  def locale_datetime_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> locale_datetime_input()
  end

  def locale_datetime_input(assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <input
        type={@type}
        name={@name}
        id={@id}
        data-date={Phoenix.HTML.Form.normalize_value(@type, @value)}
        data-date-format={@date_format}
        phx-hook="GreekDatesInput"
        phx-debounce="blur"
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "greek-date-input mt-3 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6",
          "phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400",
          @errors == [] && "border-zinc-300 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      />
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end
end
