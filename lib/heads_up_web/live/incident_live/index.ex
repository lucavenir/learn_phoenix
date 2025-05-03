defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents
  alias HeadsUp.Incidents.Incident
  alias HeadsUpWeb.Components.HeadsUpComponents

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> stream(:incidents, Incidents.filter_incidents())
      |> assign(page_title: "Incidents")

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="incident-index">
        <div class="incidents" id="incidents" phx-update="stream">
          <.incident_card :for={{id, incident} <- @streams.incidents} id={id} incident={incident} />
        </div>
      </div>
    </Layouts.app>
    """
  end

  attr :incident, Incident, required: true
  attr :id, :string, required: true

  def incident_card(assigns) do
    ~H"""
    <.link navigate={~p"/incidents/#{@incident.id}"}>
      <div class="card" id={@id}>
        <img src={@incident.image_path} />
        <h2>{@incident.name}</h2>
        <div class="details">
          <HeadsUpComponents.badge status={@incident.status} />
          <div class="priority">
            {@incident.priority}
          </div>
        </div>
      </div>
    </.link>
    """
  end
end
