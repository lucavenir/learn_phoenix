defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents
  alias HeadsUp.Incidents.Incident
  alias HeadsUpWeb.Components.HeadsUpComponents

  @impl true
  def mount(_params, _session, socket) do
    statuses = Incidents.list_all_statuses()

    sort_by = [
      Name: "name",
      "Priority high to low": "priority_desc",
      "Priority low to high": "priority_asc"
    ]

    socket =
      socket
      |> assign(:statuses, statuses)
      |> assign(:sort_by, sort_by)
      |> assign(page_title: "Incidents")

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> stream(:incidents, Incidents.filter_incidents(params), reset: true)
      |> assign(:form, to_form(params))

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="incident-index">
        <.incident_form form={@form} statuses={@statuses} sort_by={@sort_by} />
        <div class="incidents" id="incidents" phx-update="stream">
          <div id="empty" class="no-results only:block hidden">
            No incidents found. Try changing the filters.
          </div>
          <.incident_card :for={{id, incident} <- @streams.incidents} incident={incident} id={id} />
        </div>
      </div>
    </Layouts.app>
    """
  end

  def incident_form(assigns) do
    ~H"""
    <.form for={@form} phx-submit="filter" phx-change="filter">
      <.input field={@form[:q]} placeholder="search..." autocomplete="off" phx-debounce="400" />
      <.input field={@form[:status]} type="select" prompt="status.." options={@statuses} />
      <.input field={@form[:sort_by]} type="select" prompt="sort by.." options={@sort_by} />

      <.link patch={~p"/incidents"}>
        Reset
      </.link>
    </.form>
    """
  end

  attr :incident, Incident, required: true
  attr :id, :string, required: true

  def incident_card(assigns) do
    ~H"""
    <.link navigate={~p"/incidents/#{@incident.id}"} id={@id}>
      <div class="card">
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

  @impl true
  def handle_event("filter", params, socket) do
    params =
      params
      |> Map.take(~w(q status sort_by))
      |> Map.reject(fn {_, v} -> v == "" end)

    socket = push_patch(socket, to: ~p"/incidents?#{params}")

    {:noreply, socket}
  end
end
