defmodule RaffleyWeb.RuleController do
  alias Raffley.Rules

  use RaffleyWeb, :controller

  def index(conn, _params) do
    emojis =
      ~w(👋 🤠 😅)
      |> Enum.random()
      |> String.duplicate(5)

    rules = Rules.list_rules()

    render(conn, :index, emojis: emojis, rules: rules)
  end
end
