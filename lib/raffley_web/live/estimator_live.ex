defmodule RaffleyWeb.EstimatorLive do
  use RaffleyWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :tick, :timer.seconds(2))
    end

    socket = assign(socket, tickets: 0, price: 30)
    {:ok, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, :timer.seconds(2))
    socket = update(socket, :tickets, &(&1 + 10))
    {:noreply, socket}
  end

  @impl true
  def handle_event("add", %{"qty" => quantity}, socket) do
    qty = String.to_integer(quantity)
    socket = update(socket, :tickets, &(&1 + qty))
    {:noreply, socket}
  end

  def handle_event("set-price", %{"price" => price}, socket) do
    price = String.to_integer(price)
    socket = assign(socket, price: price)
    {:noreply, socket}
  end
end
