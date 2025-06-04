defmodule Jabol.Schema do
  @moduledoc """
  Defines a Schema module for building database schemas.
  """

  defmacro __using__(_opts) do
    quote do
      import Jabol.Schema
      
      @primary_key {:id, :integer, []}
      @timestamps_opts [type: :naive_datetime]
      @foreign_key_type :integer
    end
  end

  @doc """
  Defines a schema with fields.
  """
  defmacro schema(source, do: block) do
    quote do
      @source unquote(source)
      @fields []
      
      def __schema__(:source), do: @source
      
      # Execute the schema block to collect fields
      unquote(block)
      
      # Define the struct with the collected fields - without duplicating timestamp fields
      field_map = Enum.map(@fields, fn {name, _type, opts} -> 
        default = Keyword.get(opts, :default, nil)
        {name, default}
      end)
      
      # Add primary key if not already defined in fields
      field_names = Enum.map(field_map, fn {name, _} -> name end)
      field_map = if :id in field_names, do: field_map, else: [{:id, nil} | field_map]
      
      defstruct field_map
    end
  end

  @doc """
  Defines a field in the schema.
  """
  defmacro field(name, type, opts \\ []) do
    quote do
      # Add the field to the list of fields
      @fields @fields ++ [{unquote(name), unquote(type), unquote(opts)}]
      
      # Define an accessor function for this field
      def __schema__(:field, unquote(name)), do: unquote(type)
    end
  end

  @doc """
  Defines timestamp fields (inserted_at and updated_at)
  """
  defmacro timestamps(opts \\ []) do
    quote do
      field(:inserted_at, :naive_datetime, unquote(opts))
      field(:updated_at, :naive_datetime, unquote(opts))
    end
  end
end
