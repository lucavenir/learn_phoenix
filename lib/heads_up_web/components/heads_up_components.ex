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

  slot :inner_block, required: true
  slot :taglines

  def headline(assigns) do
    assigns = assign_new(assigns, :emoji, fn -> "🗣️" end)

    ~H"""
    <div class="headline">
      <h1>
        {render_slot(@inner_block)}
      </h1>
      <div :for={tagline <- @taglines} class="tagline">
        {render_slot(tagline, @emoji)}
      </div>
    </div>
    """
  end
end
