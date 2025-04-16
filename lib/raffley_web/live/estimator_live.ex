defmodule RaffleyWeb.EstimatorLive do
  use RaffleyWeb, :live_view

  # mount
  def mount(_params, _session, socket) do
    socket = assign(socket, tickets: 0, price: 30)
    IO.inspect(socket)
    {:ok, socket}
  end

  # handle_event
end
