defmodule HeadsUp.Incidents.Incident do
  use Ecto.Schema
  import Ecto.Changeset

  @statuses [:pending, :resolved, :canceled]
  @string_statuses @statuses |> Enum.map(&Atom.to_string/1)

  defguard is_status(args) when args in @string_statuses or args in @statuses

  schema "incidents" do
    field :name, :string
    field :description, :string
    field :priority, :integer
    field :status, Ecto.Enum, values: @statuses, default: :pending
    field :image_path, :string, default: "/images/placeholder.jpg"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(incident, attrs) do
    incident
    |> cast(attrs, [:name, :description, :priority, :status, :image_path])
    |> validate_required([:name, :description, :priority, :status, :image_path])
    |> validate_inclusion(:priority, 1..3)
    |> validate_length(:name, min: 3)
    |> validate_length(:description, min: 10)
  end
end
