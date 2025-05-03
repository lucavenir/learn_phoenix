defmodule RaffleyWeb.RaffleLive.Show do
  use RaffleyWeb, :live_view

  alias RaffleyWeb.RaffleyComponents
  alias RaffleyWeb.Layouts
  alias Raffley.Raffles

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    raffle = Raffles.get_raffle!(id)

    socket =
      socket
      |> assign(:raffle, raffle)
      |> assign(:page_title, raffle.prize)
      |> assign_async(:featured, fn ->
        {:ok, %{featured_raffles: Raffles.featured_raffles(raffle)}}
      end)

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="raffle-show">
        <div class="raffle">
          <img src={@raffle.image_path} alt={@raffle.prize} />
          <section>
            <RaffleyComponents.badge status={@raffle.status} />
            <header>
              <h2>{@raffle.prize}</h2>
              <div class="price">
                € {@raffle.ticket_price} per ticket
              </div>
            </header>
            <div class="description">
              {@raffle.description}
            </div>
          </section>
        </div>

        <div class="activity">
          <div class="left"></div>
          <div class="right">
            <.featured_raffles raffles={@featured} />
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  def featured_raffles(assigns) do
    ~H"""
    <section>
      <h4>Featured Raffles</h4>
      <.async_result :let={result} assign={@raffles}>
        <:loading>
          <div class="loading">
            <div class="snipper"></div>
          </div>
        </:loading>
        <:failed :let={{:error, reason}}>
          <div class="failed">
            Yikes..! This happened: {reason}
          </div>
        </:failed>

        <ul class="raffles">
          <li :for={raffle <- result}>
            <.link navigate={~p"/raffles/#{raffle}"}>
              <img src={raffle.image_path} alt={raffle.prize} />
              {raffle.prize}
            </.link>
          </li>
        </ul>
      </.async_result>
    </section>
    """
  end
end
