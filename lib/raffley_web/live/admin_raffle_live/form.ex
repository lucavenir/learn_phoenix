defmodule RaffleyWeb.AdminRaffleLive.Form do
  use RaffleyWeb, :live_view

  alias Raffley.Admin
  alias Raffley.Raffles.Raffle

  @impl true
  def mount(params, _session, socket) do
    socket = apply_action(socket, socket.assigns.live_action, params)

    {:ok, socket}
  end

  defp apply_action(socket, :new, _params) do
    raffle = %Raffle{}
    changeset = Admin.change_raffle(raffle)

    socket
    |> assign(:page_title, "New Raffle")
    |> assign(:statuses, Raffley.Raffles.list_raffle_statuses())
    |> assign(:form, to_form(changeset))
    |> assign(:raffle, raffle)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    raffle = Admin.get_raffle!(id)
    changeset = Admin.change_raffle(raffle)

    socket
    |> assign(:page_title, "Edit Raffle")
    |> assign(:statuses, Raffley.Raffles.list_raffle_statuses())
    |> assign(:form, to_form(changeset))
    |> assign(:raffle, raffle)
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
  def handle_event("validate", %{"raffle" => attrs}, socket) do
    changeset = Admin.change_raffle(socket.assigns.raffle, attrs)

    socket =
      socket
      |> assign(:form, to_form(changeset, action: :validate))

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"raffle" => attrs}, socket) do
    save_raffle(socket, socket.assigns.live_action, attrs)
  end

  defp save_raffle(socket, :new, attrs) do
    case Admin.create_raffle(attrs) do
      {:ok, _raffle} ->
        socket =
          socket
          |> put_flash(:info, "Raffle created successfully.")
          |> push_navigate(to: ~p"/admin/raffles")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> assign(:form, to_form(changeset))

        {:noreply, socket}
    end
  end

  defp save_raffle(socket, :edit, attrs) do
    case Admin.update_raffle(socket.assigns.raffle, attrs) do
      {:ok, _raffle} ->
        socket =
          socket
          |> put_flash(:info, "Raffle updated successfully.")
          |> push_navigate(to: ~p"/admin/raffles")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> assign(:form, to_form(changeset))

        {:noreply, socket}
    end
  end
end
