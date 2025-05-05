defmodule RaffleyWeb.AdminRaffleLive.Form do
  use RaffleyWeb, :live_view

  alias Raffley.Admin
  alias Raffley.Raffles.Raffle

  @impl true
  def mount(_params, _session, socket) do
    changeset = Admin.change_raffle(%Raffle{})

    socket =
      socket
      |> assign(:page_title, "New Raffle")
      |> assign(:statuses, Raffley.Raffles.list_raffle_statuses())
      |> assign(:form, to_form(changeset))

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>

    <.form for={@form} id="new-raffle-form" phx-change="validate" phx-submit="save">
      <.input field={@form[:prize]} label="Prize" />
      <.input field={@form[:description]} type="textarea" label="Description" phx-debounce="blur" />
      <.input field={@form[:ticket_price]} type="number" label="Ticket price" />
      <.input
        field={@form[:status]}
        type="select"
        label="Status"
        prompt="Choose a status.."
        options={@statuses}
      />
      <.input field={@form[:image_path]} label="Image path" />

      <.button phx-disable-with="saving...">
        Save Raffle!
      </.button>
    </.form>

    <.link navigate={~p"/admin/raffles"} class="button">
      Back
    </.link>
    """
  end

  @impl true
  def handle_event("save", %{"raffle" => attrs}, socket) do
    IO.inspect(attrs)

    case Admin.create_raffle(attrs) do
      {:ok, _raffle} ->
        socket =
          socket
          |> put_flash(:info, "Raffle created successfully.")
          |> push_navigate(to: ~p"/admin/raffles")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)

        socket =
          socket
          |> assign(:form, to_form(changeset))

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("validate", %{"raffle" => attrs}, socket) do
    changeset = Admin.change_raffle(%Raffle{}, attrs)

    socket =
      socket
      |> assign(:form, to_form(changeset, action: :validate))

    {:noreply, socket}
  end
end
