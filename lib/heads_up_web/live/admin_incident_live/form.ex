defmodule HeadsUpWeb.AdminIncidentLive.Form do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Admin
  alias HeadsUp.Incidents.Incident

  @impl true
  def mount(_params, _session, socket) do
    form = Admin.change_incident(%Incident{})

    socket =
      socket
      |> assign(:page_title, "Incident Form")
      |> assign(:statuses, Admin.list_statuses())
      |> assign(:incident, to_form(form))

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
      </.header>
      <.form for={@incident} phx-change="validate" phx-submit="save">
        <.input field={@incident[:name]} required type="text" label="Name" phx-debounce="blur" />
        <.input
          field={@incident[:description]}
          required
          type="textarea"
          label="Description"
          phx-debounce="blur"
        />
        <.input field={@incident[:priority]} required type="number" label="Priority" />
        <.input
          field={@incident[:status]}
          required
          type="select"
          label="Status"
          prompt="choose a status"
          options={@statuses}
        />
        <.input field={@incident[:image_path]} required label="Image Path" />

        <.link navigate={~p"/admin/incidents"} class="button">
          Back
        </.link>
        <.button phx-disable-with="Saving...">
          Save
        </.button>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def handle_event("save", %{"incident" => attrs}, socket) do
    case Admin.create_incident(attrs) do
      {:ok, _incident} ->
        socket =
          socket
          |> put_flash(:info, "Incident created successfully.")
          |> push_navigate(to: ~p"/admin/incidents")

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(:incident, to_form(changeset))

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("validate", %{"incident" => attrs}, socket) do
    changeset = Admin.change_incident(%Incident{}, attrs)

    socket =
      socket
      |> assign(:incident, to_form(changeset, action: :validate))

    {:noreply, socket}
  end
end
