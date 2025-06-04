defmodule Jabol.Factory do
  @moduledoc """
  Factory module for creating test data
  """

  @doc """
  Builds a struct of the given type with default attributes
  merged with the provided attributes.
  """
  @spec build(module(), map()) :: struct()
  def build(schema, attrs \\ %{}) do
    defaults = get_defaults(schema)
    struct(schema, Map.merge(defaults, attrs))
  end

  @doc """
  Creates a test record through the repository
  """
  @spec create(module(), map()) :: {:ok, struct()} | {:error, term()}
  def create(schema, attrs \\ %{}) do
    # Fix: Pass the struct to Repo.insert/2 directly
    record = build(schema, attrs)
    Jabol.Repo.insert(schema, Map.from_struct(record))
  end

  @doc """
  Returns a map of default attributes for a given schema
  """
  @spec get_defaults(module()) :: map()
  def get_defaults(Jabol.Person) do
    %{
      name: "John Doe",
      gender: "male",
      age: 30
    }
  end

  # Generic defaults for any schema
  def get_defaults(_schema) do
    %{}
  end

  @doc """
  Builds a list of structs
  """
  @spec build_list(pos_integer(), module(), map()) :: [struct()]
  def build_list(count, schema, attrs \\ %{}) do
    Enum.map(1..count, fn _ -> build(schema, attrs) end)
  end
end
