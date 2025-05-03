defmodule RaffleyWeb.AdminRaffleLive.Form do
  use RaffleyWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "New Raffle")
      |> assign(:statuses, Raffley.Raffles.list_raffle_statuses())
      |> assign(:form, to_form(%{}, as: "raffle"))

    {:ok, socket}
  end

  # @impl true
  # def handle_params(params, _uri, socket) do
  # end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>

    <.form for={@form} id="new-raffle-form">
      <.input field={@form[:prize]} label="Prize" />
      <.input field={@form[:description]} type="textarea" label="Description" />
      <.input field={@form[:ticket_price]} type="number" label="Ticket price" />
      <.input
        field={@form[:status]}
        type="select"
        label="Status"
        prompt="Choose a status.."
        options={@statuses}
      />
      <.input field={@form[:image_path]} label="Image path" />

      <.button>
        Save Raffle!
      </.button>
    </.form>

    <.link navigate={~p"/admin/raffles"} class="button">
      Back
    </.link>
    """
  end
end
