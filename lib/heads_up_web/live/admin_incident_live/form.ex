defmodule HeadsUpWeb.AdminIncidentLive.Form do
  use HeadsUpWeb, :live_component

  alias HeadsUp.Admin

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(:page_title, "Incident Form")
      |> assign(:statuses, Admin.list_statuses())
      |> assign(:incident, to_form(%{}))

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
      </.header>
      <.form for={@incident} phx-submit="save">
        <.input field={@incident[:name]} type="text" label="Name" />
        <.input field={@incident[:description]} type="textarea" label="Description" />
        <.input field={@incident[:priority]} type="number" label="Priority" />
        <.input
          field={@incident[:status]}
          type="select"
          label="Status"
          prompt="choose a status"
          options={@statuses}
        />
        <.input field={@incident[:image_path]} label="Image Path" />

        <.link navigate={~p"/admin/incidents"} class="button">
          Back
        </.link>
        <.button>
          Save
        </.button>
      </.form>
    </Layouts.app>
    """
  end
end
