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
  def version do
    Application.spec(:jabol, :vsn)
  end
end
