defmodule Jabol do
  @moduledoc """
  Jabol is a lightweight schema and data persistence library for Elixir applications.

  This module serves as the main entry point for the library's documentation.

  ## Features

  - Schema definition system with field types
  - Simple repository pattern for database operations
  - Factory system for easy test data generation
  - Minimal configuration with sensible defaults

  For detailed usage examples, see the README.md file.
  """

  @doc """
  Returns the version of the Jabol library.
  """
  @spec version() :: String.t()
  def version do
    Application.spec(:jabol, :vsn) || "0.1.0"
  end

  @doc """
  Hello world function, retained for compatibility.

  Returns `:world`.
  """
  @spec hello() :: :world
  def hello do
    :world
  end
end
