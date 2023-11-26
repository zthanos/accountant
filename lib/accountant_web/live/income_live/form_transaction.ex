defmodule AccountantWeb.IncomeLive.FormTransaction do
  use AccountantWeb, :live_component
  alias AccountantWeb.IncomeLive.TransactionComposeForm
  import AccountantWeb.DateComponents

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="transaction-form"
        phx-change="validate"
        phx-submit="save"
        phx-target={@myself}
      >
        <div class="flex justify-between">
          <.locale_datetime_input
            field={@form[:transaction_date]}
            type="datetime-local"
            label="Ημερομηνία: "
          />
        </div>
        <div class="flex justify-between space-x-2">
          <.input field={@form[:sales_category]} type="text" label="Κατηγορία: " />
          <.input field={@form[:invoice_type]} type="text" label="Παραστατικό: " />
          <.input field={@form[:invoice_number]} type="text" label="Αριθμός: " />
        </div>
        <.input field={@form[:description]} type="text" label="Περιγραφή: " />
        <div class="flex justify-between space-x-2">
          <.input field={@form[:vat_rate]} type="text" label="Ποσοστό: : " />
          <.input field={@form[:net_amount]} type="text" label="Καθαρό: " />
          <.input field={@form[:vat_amount]} type="text" label="Φ.Π.Α.: " />
          <.input field={@form[:gross_amount]} type="text" label="Σύνολο: " />
        </div>
        <:actions>
          <.button phx-disable-with="Saving...">Αποθήκευση</.button>
        </:actions>
      </.simple_form>
      <input
        type="date"
        class="greeki-date-input"
        value="2004-16-11"
        id="greek-date"
        data-date=""
        data-date-format="DD/MM/YYYY"
        phx-hook="GreekDatesInput"
      />
    </div>
    """
  end

  # <input type="date" class="greek-date-input" id="greek-date" data-date="" data-date-format="DD/MM/YYYY"
  # phx-hook="GreekDatesInput"  />
  @impl true
  def update(%{transaction: transaction}, socket) do
    form =
      transaction
      |> TransactionComposeForm.changeset()
      |> to_form()

    {:ok, assign(socket, :form, form)}
  end

  @impl true
  def handle_event("validate", %{"transaction_compose_form" => params}, socket) do
    changeset =
      case validate_params(params) do
        {:ok, valid_params} -> TransactionComposeForm.changeset(valid_params)
        {:error, changeset} -> changeset
      end

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"transaction_compose_form" => params}, socket) do
    with {:ok, validated_params} <- validate_params(params),
         {:ok, _transaction} <-
           Accountant.Context.Income.Income.create_transaction(validated_params) do
      {:noreply, push_redirect(socket, to: ~p"/income/")}
    else
      {:error, changeset} ->
        form = to_form(changeset)
        {:noreply, assign(socket, :form, form)}
    end
  end

  def validate_params(params) do
    params
    |> TransactionComposeForm.changeset()
    |> TransactionComposeForm.validate()
    |> case do
      {:ok, valid_params} ->
        {:ok, TransactionComposeForm.to_attrs(valid_params)}

      {:error, _} = error ->
        error
    end
  end
end
