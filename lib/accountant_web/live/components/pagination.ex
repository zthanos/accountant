defmodule AccountantWeb.Components.Pagination do
  use Phoenix.LiveComponent

  @impl true
  def mount(socket) do
    # visible_pages = socket.assigns.pages
    {:ok,
     socket
     |> assign(:selected_idx, 0)
     |> assign(:visible_idx, 0)
     |> assign(:visible_btns, 4)
     |> assign(:pages, [])
     |> assign(:visible_pages, [])}
  end

  defp apply_changes(socket, visible_idx, selected_idx, visible_btns, pages) do
    visible_pages =
      Enum.slice(
        Enum.with_index(pages),
        visible_idx,
        socket.assigns.visible_btns
      )

    notify_parent({:load_page, selected_idx})

    socket
    |> assign(:selected_idx, selected_idx)
    |> assign(:visible_btns, visible_btns)
    |> assign(:pages, pages)
    |> assign(:visible_pages, visible_pages)
    |> assign(:visible_idx, visible_idx)
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     apply_changes(
       socket,
       socket.assigns.visible_idx,
       socket.assigns.selected_idx,
       socket.assigns.visible_btns,
       assigns.pages
     )}
  end

  @impl true
  def handle_event("select_page", %{"page" => selected_page}, socket) do
    {:noreply,
     apply_changes(
       socket,
       socket.assigns.visible_idx,
       String.to_integer(selected_page),
       socket.assigns.visible_btns,
       socket.assigns.pages
     )}
  end

  @impl true
  def handle_event("select_prev", _assigns, socket) do
    new_idx =
      case socket.assigns.visible_idx - 1 do
        x when x < 0 -> 0
        x -> x
      end

    {:noreply,
     apply_changes(
       socket,
       new_idx,
       socket.assigns.selected_idx,
       socket.assigns.visible_btns,
       socket.assigns.pages
     )}
  end

  def handle_event("select_next", _assigns, socket) do
    last_idx = Enum.count(socket.assigns.pages)

    new_idx =
      case socket.assigns.visible_idx + 1 do
        x when x > last_idx -> last_idx
        x -> x
      end

    {:noreply,
     apply_changes(
       socket,
       new_idx,
       socket.assigns.selected_idx,
       socket.assigns.visible_btns,
       socket.assigns.pages
     )}
  end

  defp is_selected_page(page, selected_page) do
    if page == selected_page do
      "pager-button-selected"
    else
      "pager-button"
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
