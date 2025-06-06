defmodule Jabol.Migration do
  @moduledoc """
  Migration system for Jabol database schemas.

  This module provides functionality for database migrations similar to Ecto.Migration
  but simplified for the Jabol system.
  """

  defmacro __using__(_opts) do
    quote do
      import Jabol.Migration
      @primary_key false
      @before_compile Jabol.Migration
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run(direction) when direction in [:up, :down] do
        if function_exported?(__MODULE__, direction, 0) do
          apply(__MODULE__, direction, [])
        else
          raise "#{__MODULE__} does not implement #{direction}/0"
        end
      end
    end
  end

  @doc """
  Creates a new table with the given name and columns.
  """
  defmacro create_table(table_name, do: block) do
    quote do
      table = %{name: unquote(table_name), columns: []}
      unquote(block)

      Jabol.Migration.Runner.create_table(table)
    end
  end

  @doc """
  Adds a column to the current table.
  """
  defmacro add(column_name, type, opts \\ []) do
    quote do
      column = %{name: unquote(column_name), type: unquote(type), options: unquote(opts)}
      Jabol.Migration.Runner.add_column(column)
    end
  end

  @doc """
  Alters an existing table.
  """
  defmacro alter_table(table_name, do: block) do
    quote do
      table = %{name: unquote(table_name), columns: []}
      unquote(block)

      Jabol.Migration.Runner.alter_table(table)
    end
  end

  @doc """
  Drops a table from the database.
  """
  defmacro drop_table(table_name) do
    quote do
      Jabol.Migration.Runner.drop_table(unquote(table_name))
    end
  end

  @doc """
  Creates a database index.
  """
  defmacro create_index(table_name, columns, opts \\ []) do
    quote do
      Jabol.Migration.Runner.create_index(
        unquote(table_name),
        unquote(columns),
        unquote(opts)
      )
    end
  end

  @doc """
  Drops a database index.
  """
  defmacro drop_index(table_name, columns, opts \\ []) do
    quote do
      Jabol.Migration.Runner.drop_index(
        unquote(table_name),
        unquote(columns),
        unquote(opts)
      )
    end
  end
end
