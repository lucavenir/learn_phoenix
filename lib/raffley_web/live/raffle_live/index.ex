defmodule RaffleyWeb.RaffleLive.Index do
  use RaffleyWeb, :live_view

  alias Raffley.Raffles
  alias Raffley.Raffles.Raffle
  alias RaffleyWeb.RaffleyComponents

  @impl true
  def mount(_params, _session, socket) do
    socket = stream(socket, :raffles, Raffles.list_raffles())

    {:ok, socket}
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
        <div class="raffles" id="raffles" phx-update="stream">
          <.raffle_card :for={{id, raffle} <- @streams.raffles} id={id} raffle={raffle} />
        </div>
      </div>
    </Layouts.app>
    """
  end

  attr :raffle, Raffle, required: true
  attr :id, :string, required: true

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
end
