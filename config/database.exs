defmodule Jabol.Config.Database do
  @moduledoc """
  Database configuration helpers
  """

  @doc """
  Returns the database configuration based on the environment
  """
  def get_config do
    Application.get_env(:jabol, Jabol.Repo)
  end

  @doc """
  Returns the connection string for the database
  """
  def connection_string do
    config = get_config()

    "postgres://#{config[:username]}:#{config[:password]}@#{config[:hostname]}/#{config[:database]}"
  end
end
