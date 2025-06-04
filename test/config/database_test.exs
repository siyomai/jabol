defmodule Jabol.Config.DatabaseTest do
  use ExUnit.Case
  
  alias Jabol.Config.Database
  
  setup do
    # Temporarily set configuration for testing
    orig_config = Application.get_env(:jabol, Jabol.Repo)
    
    test_config = [
      hostname: "test-host",
      username: "test-user",
      password: "test-pass",
      database: "test-db"
    ]
    
    Application.put_env(:jabol, Jabol.Repo, test_config)
    
    on_exit(fn ->
      # Restore original config
      Application.put_env(:jabol, Jabol.Repo, orig_config)
    end)
    
    %{config: test_config}
  end
  
  test "get_config returns database configuration", %{config: config} do
    result = Database.get_config()
    assert result == config
  end
  
  test "connection_string builds proper connection string", %{config: _config} do
    conn_str = Database.connection_string()
    assert conn_str == "postgres://test-user:test-pass@test-host/test-db"
  end
end
