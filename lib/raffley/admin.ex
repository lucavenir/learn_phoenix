defmodule Raffley.Admin do
  alias Raffley.Repo
  alias Raffley.Raffles.Raffle

  import Ecto.Query

  def list_raffles() do
    Raffle
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end
end
