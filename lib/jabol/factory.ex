defmodule Jabol.Factory do
  @moduledoc """
  Factory module for creating test data
  """
  
  @doc """
  Builds a struct of the given type with default attributes
  merged with the provided attributes.
  """
  def build(schema, attrs \\ %{}) do
    defaults = get_defaults(schema)
    struct(schema, Map.merge(defaults, attrs))
  end
  
  @doc """
  Creates a test record through the repository
  """
  def create(schema, attrs \\ %{}) do
    # Fix: Pass the struct to Repo.insert/2 directly
    record = build(schema, attrs)
    Jabol.Repo.insert(schema, Map.from_struct(record))
  end
  
  @doc """
  Returns a map of default attributes for a given schema
  """
  def get_defaults(Jabol.Person) do
    %{
      name: "John Doe",
      gender: "male",
      age: 30
    }
  end
  
  # Add more schema defaults as needed
  def get_defaults(_schema) do
    # Generic defaults for any schema
    %{}
  end
  
  @doc """
  Builds a list of structs
  """
  def build_list(count, schema, attrs \\ %{}) do
    Enum.map(1..count, fn _ -> build(schema, attrs) end)
  end
end
