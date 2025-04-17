defmodule HeadsUpWeb.Components.HeadsUpComponents do
  use Phoenix.Component
  use HeadsUpWeb, :verified_routes

  attr :status, :atom, default: :pending, values: [:pending, :resolved, :canceled]

  def badge(assigns) do
    ~H"""
    <div class={[
      "badge",
      @status == :resolved && "text-lime-600 border-lime-600",
      @status == :pending && "text-amber-600 border-amber-600",
      @status == :canceled && "text-gray-600 border-gray-600"
    ]}>
      {@status}
    </div>
    """
  end
end
