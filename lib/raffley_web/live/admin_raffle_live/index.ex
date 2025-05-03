defmodule RaffleyWeb.AdminRaffleLive.Index do
  use RaffleyWeb, :live_view

  alias Raffley.Admin
  alias Raffley.Raffles
  alias Raffley.Raffles.Raffle

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
        </.table>
      </div>
    </Layouts.app>
    """
  end
end
