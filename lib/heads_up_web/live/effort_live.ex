defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, responders: 0, minutes_per_responder: 10)
    {:ok, socket}
  end
end
