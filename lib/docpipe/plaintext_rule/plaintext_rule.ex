defmodule Docpipe.PlaintextRule do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plaintext_rules" do
    field :phase, Ecto.Enum, values: [:pre, :post]
    field :type, Ecto.Enum, values: [:string, :regex]
    field :pattern, :string
    field :replacement, :string
  end

  @doc false
  def changeset(plaintext_rule, attrs) do
    plaintext_rule
    |> cast(attrs, [:phase, :type, :pattern, :replacement])
  end
end
