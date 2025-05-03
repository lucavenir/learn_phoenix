defmodule RaffleyWeb.RaffleLive.Index do
  use RaffleyWeb, :live_view

  alias Raffley.Raffles
  alias Raffley.Raffles.Raffle
  alias RaffleyWeb.RaffleyComponents

  @impl true
  def mount(_params, _session, socket) do
    statuses = Raffles.list_raffle_statuses()

    sorting = [
      Prize: "prize",
      "Price: Hight to Low": "ticket_price_desc",
      "Price: Low to High": "ticket_price_asc"
    ]

    socket =
      socket
      |> assign(:statuses, statuses)
      |> assign(:sorting, sorting)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> stream(:raffles, Raffles.filter_raffles(params), reset: true)
      |> assign(:form, to_form(params))

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="raffle-index">
        <RaffleyComponents.banner :if={false}>
          <.icon name="hero-sparkles-solid" /> Mistery Raffle Coming Soon!!
          <:details :let={vibe}>
            To be revealed on the 30th of February 2029 {vibe}
          </:details>
          <:details>
            Any guesses?
          </:details>
        </RaffleyComponents.banner>

        <.raffley_form form={@form} statuses={@statuses} sorting={@sorting} />

        <div class="raffles" id="raffles" phx-update="stream">
          <div id="raffles-empty" class="no-results only:block hidden">
            No raffles found. Try changing the filters.
          </div>
          <.raffle_card :for={{id, raffle} <- @streams.raffles} id={id} raffle={raffle} />
        </div>
      </div>
    </Layouts.app>
    """
  end

  def raffley_form(assigns) do
    ~H"""
    <.form for={@form} id="raffley_filter_form" phx-change="filter">
      <.input field={@form[:q]} placeholder="search..." autocomplete="off" phx-debounce="400" />
      <.input type="select" field={@form[:status]} prompt="status" options={@statuses} />
      <.input type="select" field={@form[:sort_by]} prompt="sort" options={@sorting} />

      <.link patch={~p"/raffles"}>
        Reset
      </.link>
    </.form>
    """
  end

  attr(:raffle, Raffle, required: true)
  attr(:id, :string, required: true)

  def raffle_card(assigns) do
    ~H"""
    <.link navigate={~p"/raffles/#{@raffle}"} id={@id}>
      <div class="card">
        <img src={@raffle.image_path} alt="an image of the prize" />
        <h2>{@raffle.prize}</h2>
        <div class="details">
          <div class="price">
            € {@raffle.ticket_price} per ticket
          </div>
          <RaffleyComponents.badge status={@raffle.status} />
        </div>
      </div>
    </.link>
    """
  end

  @impl true
  def handle_event("filter", params, socket) do
    params =
      params
      |> Map.take([~w(q status sort_by)])
      |> Map.reject(fn {_, v} -> v == "" end)

    socket = push_patch(socket, to: ~p"/raffles?#{params}")

    {:noreply, socket}
  end
end
