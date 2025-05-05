defmodule HeadsUpWeb.AdminIncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Admin
  alias HeadsUpWeb.Components.HeadsUpComponents

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Incidents Admin panel")
      |> stream(:incidents, Admin.list_incidents())

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="admin-index">
        <.header>
          <:actions>
            <.link navigate={~p"/admin/incidents/new"} class="button">
              New Incident
            </.link>
          </:actions>
          {@page_title}
        </.header>

        <.table id="admin-incidents-table" rows={@streams.incidents}>
          <:col :let={{_dom_id, raffle}} label="Name">
            <.link navigate={~p"/incidents/#{raffle}"}>
              {raffle.name}
            </.link>
          </:col>

          <:col :let={{_dom_id, raffle}} label="Status">
            <HeadsUpComponents.badge status={raffle.status} />
          </:col>

          <:col :let={{_dom_id, raffle}} label="Priority">
            {raffle.priority}
          </:col>
        </.table>
      </div>
    </Layouts.app>
    """
  end
end
