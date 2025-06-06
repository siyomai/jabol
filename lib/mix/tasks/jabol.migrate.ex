defmodule Mix.Tasks.Jabol.Migrate do
  @moduledoc """
  Runs Jabol migrations.

  ## Examples

      mix jabol.migrate
      mix jabol.migrate --version 20230101120000
      mix jabol.migrate --down

  ## Command line options

    * `--version`, `-v` - Run migrations up to a specific version
    * `--down`, `-d` - Run migrations downward instead of upward

  """
  use Mix.Task

  @shortdoc "Runs Jabol migrations"

  @impl Mix.Task
  def run(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        aliases: [v: :version, d: :down],
        switches: [version: :string, down: :boolean]
      )

    # Start necessary applications
    Mix.Task.run("app.start")

    # Load migration modules
    migrations = load_migrations()

    # Determine direction
    direction = if Keyword.get(opts, :down), do: :down, else: :up

    # Filter by version if specified
    migrations =
      case Keyword.get(opts, :version) do
        nil ->
          migrations

        version ->
          filter_migrations(migrations, version, direction)
      end

    # Run migrations
    Jabol.Migration.Runner.run_migrations(migrations, direction)
  end

  defp load_migrations do
    # Find all migration files
    Path.wildcard("priv/migrations/*.exs")
    |> Enum.sort()
    |> Enum.map(fn file ->
      # Load the migration module
      Code.require_file(file)

      # Extract the module name from the filename
      # Assuming format: "priv/migrations/YYYYMMDDHHMMSS_name.exs"
      filename = Path.basename(file, ".exs")
      [version, name] = String.split(filename, "_", parts: 2)

      # Convert the name to a module name (CamelCase)
      module_name =
        name
        |> String.split("_")
        |> Enum.map_join("", &String.capitalize/1)

      # Build the full module name
      module = Module.concat(["Jabol", "Migrations", module_name])

      {String.to_integer(version), module}
    end)
    |> Enum.sort_by(fn {version, _} -> version end)
    |> Enum.map(fn {_, module} -> module end)
  end

  defp filter_migrations(migrations, version, direction) do
    version = String.to_integer(version)

    migrations
    |> Enum.map(fn module ->
      name = Module.split(module) |> List.last()
      {extract_version(name), module}
    end)
    |> Enum.filter(fn {v, _} ->
      case direction do
        :up -> v <= version
        :down -> v >= version
      end
    end)
    |> Enum.map(fn {_, module} -> module end)
  end

  defp extract_version(module_name) do
    # Extract version from a module name (assuming it contains the version)
    # This is a placeholder - you might need a more robust implementation
    0
  end
end
