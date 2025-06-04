defmodule Jabol.Config.Database do
  @moduledoc """
  Database configuration helpers
  """

  @doc """
  Returns the database configuration based on the environment
  """
  @spec get_config() :: keyword()
  def get_config do
    Application.get_env(:jabol, Jabol.Repo, [])
  end

  @doc """
  Returns the connection string for the database
  """
  @spec connection_string() :: String.t()
  def connection_string do
    config = get_config()
    username = Keyword.get(config, :username, "")
    password = Keyword.get(config, :password, "")
    hostname = Keyword.get(config, :hostname, "")
    database = Keyword.get(config, :database, "")

    "postgres://#{username}:#{password}@#{hostname}/#{database}"
  end
end
