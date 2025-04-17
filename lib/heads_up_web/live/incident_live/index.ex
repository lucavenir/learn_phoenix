defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :incidents, Incidents.list_incidents())
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="incident-index">
      <div class="incidents">
        <.incident_card :for={incident <- @incidents} incident={incident} />
      </div>
    </div>
    """
  end

  attr :incident, HeadsUp.Incident, required: true

  def incident_card(assigns) do
    ~H"""
    <div class="card">
      <img src={@incident.image_path} />
      <h2>{@incident.name}</h2>
      <div class="details">
        <.badge status={@incident.status} />
        <div class="priority">
          {@incident.priority}
        </div>
      </div>
    </div>
    """
  end

  attr :status, :atom, default: :pending, values: [:pending, :resolved, :canceled]

  def badge(assigns) do
    ~H"""
    <div class="badge">
      {@status}
    </div>
    """
  end
end
