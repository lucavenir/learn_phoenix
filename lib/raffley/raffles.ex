defmodule Raffley.Raffles do
  alias Raffley.Repo
  alias Raffley.Raffles.Raffle

  import Ecto.Query

  def list_raffles() do
    Repo.all(Raffle)
  end

  def filter_raffles() do
    Raffle
    |> where(status: :closed)
    |> where([r], ilike(r.prize, "%gourmet%"))
    |> order_by(:prize)
    |> Repo.all()
  end

  def get_raffle!(id) do
    Repo.get!(Raffle, id)
  end

  def featured_raffles(%Raffle{} = raffle) do
    Raffle
    |> where([r], r.id != ^raffle.id)
  end

  def list_raffle_statuses() do
    Ecto.Enum.values(Raffle, :status)
  end
end
