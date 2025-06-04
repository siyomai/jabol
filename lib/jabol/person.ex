defmodule Jabol.Person do
  @moduledoc """
  Defines a Person schema with basic attributes for database storage
  """
  use Jabol.Schema

  schema "people" do
    field(:name, :string)
    field(:gender, :string)
    field(:age, :integer)

    timestamps()
  end
end
