defmodule RaffleyWeb.AdminRaffleLive.Index do
  use RaffleyWeb, :live_view

  alias Raffley.Admin
  alias RaffleyWeb.RaffleyComponents

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Listing Raffles")
      |> stream(:raffles, Admin.list_raffles())

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="admin-index">
        <.header>
          <:actions>
            <.link navigate={~p"/admin/raffles/new"} class="button">
              New Raffle
            </.link>
          </:actions>
          {@page_title}
        </.header>
        <.table id="admin-raffles-table" rows={@streams.raffles}>
          <:col :let={{_dom_id, raffle}} label="Prize">
            <.link navigate={~p"/raffles/#{raffle}"}>
              {raffle.prize}
            </.link>
          </:col>

          <:col :let={{_dom_id, raffle}} label="Status">
            <RaffleyComponents.badge status={raffle.status} />
          </:col>

          <:col :let={{_dom_id, raffle}} label="Ticket Price">
            {raffle.ticket_price}
          </:col>
          <:action :let={{_dom_id, raffle}}>
            <.link navigate={~p"/admin/raffles/#{raffle}/edit"}>
              Edit
            </.link>
          </:action>
          <:action :let={{_dom_id, raffle}}>
            <.link phx-click="delete" phx-value-id={raffle.id} data-confirm="Are you sure?">
              Delete
            </.link>
          </:action>
        </.table>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    raffle = Admin.get_raffle!(id)
    {:ok, deleted} = Admin.delete_raffle(raffle)
    {:noreply, stream_delete(socket, :raffles, deleted)}
  end
end
