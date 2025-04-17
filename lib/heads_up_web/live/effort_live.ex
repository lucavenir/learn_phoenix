defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :tick, :timer.seconds(2))
    end

    socket = assign(socket, responders: 0, minutes_per_responder: 10)
    {:ok, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, :timer.seconds(2))
    socket = update(socket, :responders, &(&1 + 3))
    {:noreply, socket}
  end

  @impl true
  def handle_event("add", %{"amount" => amount}, socket) do
    amount = String.to_integer(amount)
    socket = update(socket, :responders, fn responders -> responders + amount end)
    {:noreply, socket}
  end

  @impl true
  def handle_event("compute", %{"minutes" => minutes}, socket) do
    minutes = String.to_integer(minutes)
    socket = assign(socket, minutes_per_responder: minutes)
    {:noreply, socket}
  end
end
