defmodule Raffley.Raffles do
  alias Raffley.Repo
  alias Raffley.Raffles.Raffle

  import Ecto.Query

  def list_raffles() do
    Repo.all(Raffle)
  end

  def filter_raffles(%{"status" => status, "q" => q, "sort_by" => _sort_by}) do
    Raffle
    |> where(status: ^status)
    |> where([r], ilike(r.prize, ^"%#{q}%"))
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
