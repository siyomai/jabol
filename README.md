# Jabol

[![Build Status](https://github.com/siyomai/jabol/actions/workflows/ci.yml/badge.svg)](https://github.com/siyomai/jabol/actions/workflows/ci.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/jabol.svg)](https://hex.pm/packages/jabol)
[![Docs](https://img.shields.io/badge/hex-docs-blue.svg)](https://hexdocs.pm/jabol)

Jabol is a lightweight schema and data persistence library for Elixir applications. It provides a simple API for defining schemas, managing database connections, and performing CRUD operations.

## Features

- Schema definition system with field types and validations
- Simple repository pattern for database operations
- Factory system for easy test data generation
- Minimal configuration with sensible defaults

## Installation

Add `jabol` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:jabol, "~> 0.1.0"}
  ]
end
```

## Documentation

Complete documentation is available on [HexDocs](https://hexdocs.pm/jabol).

You can also generate documentation locally with:

```shell
mix docs
```

## Usage

### Configuration

Set up your database configuration in `config.exs`:

```elixir
config :jabol, Jabol.Repo,
  database: "your_database",
  hostname: "localhost",
  username: "postgres",
  password: "postgres"
```

### Defining Schemas

```elixir
defmodule MyApp.User do
  use Jabol.Schema
  
  schema "users" do
    field :name, :string
    field :email, :string
    field :age, :integer
    
    timestamps()
  end
end
```

### Database Operations

```elixir
# Insert a record
{:ok, user} = Jabol.Repo.insert(MyApp.User, %{name: "John", email: "john@example.com", age: 30})

# Get a record by ID
user = Jabol.Repo.get(MyApp.User, 1)

# Update a record
{:ok, updated_user} = Jabol.Repo.update(user, %{age: 31})

# Delete a record
{:ok, deleted_user} = Jabol.Repo.delete(user)
```

### Factory for Testing

```elixir
# Define defaults in your test helper
defmodule Jabol.Factory do
  def get_defaults(MyApp.User) do
    %{
      name: "Test User",
      email: "test@example.com",
      age: 25
    }
  end
end

# In your tests
test "user creation" do
  user = Jabol.Factory.build(MyApp.User, %{name: "Custom Name"})
  assert user.name == "Custom Name"
  assert user.email == "test@example.com"  # Default value
end
```

### Migrations

Generate a new migration:

```bash
mix jabol.gen.migration create_users
```

This creates a migration file in `priv/migrations` with a timestamp prefix.

Run migrations:

```bash
mix jabol.migrate
```

Roll back migrations:

```bash
mix jabol.migrate --down
```

Run migrations up to a specific version:

```bash
mix jabol.migrate --version 20230101120000
```

Example migration:

```elixir
defmodule Jabol.Migrations.CreateUsers do
  use Jabol.Migration
  
  def up do
    create_table(:users) do
      add :name, :string
      add :email, :string
      add :age, :integer
      
      add :inserted_at, :naive_datetime
      add :updated_at, :naive_datetime
    end
    
    create_index(:users, [:email], unique: true)
  end
  
  def down do
    drop_table(:users)
  end
end
```

## Development

To contribute to Jabol:

1. Clone the repository
2. Install dependencies with `mix deps.get`
3. Run tests with `mix test`

## License

This project is licensed under the MIT License - see the LICENSE file for details.