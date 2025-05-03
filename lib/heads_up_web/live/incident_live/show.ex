defmodule HeadsUpWeb.IncidentLive.Show do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents
  alias HeadsUpWeb.Components.HeadsUpComponents

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    incident = Incidents.get_incident!(id)

    socket =
      socket
      |> assign(:page_title, "Incident #{incident.name} Details")
      |> assign(:incident, incident)
      |> assign(:urgent, Incidents.urgent_incidents(incident))

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="incident-show">
        <div class="incident">
          <img src={@incident.image_path} />
          <section>
            <HeadsUpComponents.badge status={@incident.status} />
            <header>
              <h2>{@incident.name}</h2>
              <div class="priority">
                {@incident.priority}
              </div>
            </header>
            <div class="description">
              {@incident.description}
            </div>
          </section>
        </div>
        <div class="activity">
          <div class="left"></div>
          <div class="right">
            <.urgent_incidents incidents={@urgent} />
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  attr :incidents, :list, required: true

  def urgent_incidents(assigns) do
    ~H"""
    <section>
      <h4>Urgent Incidents</h4>
      <ul class="incidents">
        <li :for={incident <- @incidents}>
          <img src={incident.image_path} /> {incident.name}
        </li>
      </ul>
    </section>
    """
  end
end
