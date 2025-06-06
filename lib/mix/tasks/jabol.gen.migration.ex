defmodule Mix.Tasks.Jabol.Gen.Migration do
  @moduledoc """
  Generates a new migration file.

  ## Examples

      mix jabol.gen.migration create_users
      mix jabol.gen.migration add_email_to_users

  """
  use Mix.Task

  @shortdoc "Generates a new migration file"

  @impl Mix.Task
  def run(args) do
    case args do
      [name] ->
        timestamp = generate_timestamp()
        path = Path.join("priv/migrations", "#{timestamp}_#{name}.exs")

        # Create migrations directory if it doesn't exist
        File.mkdir_p!("priv/migrations")

        # Generate the migration file
        contents = migration_template(name)

        case File.write(path, contents) do
          :ok ->
            Mix.shell().info("Created #{path}")

          {:error, reason} ->
            Mix.shell().error("Failed to create migration: #{reason}")
        end

      _ ->
        Mix.shell().error("Expected a migration name, e.g: mix jabol.gen.migration create_users")
    end
  end

  defp generate_timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: "0#{i}"
  defp pad(i), do: "#{i}"

  defp migration_template(name) do
    module_name =
      name
      |> String.split("_")
      |> Enum.map_join("", &String.capitalize/1)

    """
    defmodule Jabol.Migrations.#{module_name} do
      use Jabol.Migration
      
      def up do
        # Add your migration code here
        create_table(:table_name) do
          add :column_name, :string
          add :another_column, :integer
          
          # Uncomment to add timestamps
          # add :inserted_at, :naive_datetime
          # add :updated_at, :naive_datetime
        end
        
        # Uncomment to create an index
        # create_index(:table_name, [:column_name])
      end
      
      def down do
        # Add code to revert the migration here
        drop_table(:table_name)
      end
    end
    """
  end
end
