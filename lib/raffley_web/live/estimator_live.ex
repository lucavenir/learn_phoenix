defmodule RaffleyWeb.EstimatorLive do
  use RaffleyWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, tickets: 0, price: 30)
    {:ok, socket}
  end

  @impl true
  def handle_event("add", %{"qty" => quantity}, socket) do
    qty = String.to_integer(quantity)
    socket = update(socket, :tickets, &(&1 + qty))
    {:noreply, socket}
  end
end
