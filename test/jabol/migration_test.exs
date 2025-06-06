defmodule Jabol.MigrationTest do
  use ExUnit.Case

  defmodule TestMigration do
    use Jabol.Migration

    def up do
      create_table(:test_table) do
        add(:name, :string)
        add(:value, :integer)
      end

      create_index(:test_table, [:name])
    end

    def down do
      drop_table(:test_table)
    end
  end

  test "migration can be run up" do
    assert :ok = TestMigration.run(:up)
  end

  test "migration can be run down" do
    assert :ok = TestMigration.run(:down)
  end

  test "migration raises when direction not implemented" do
    defmodule InvalidMigration do
      use Jabol.Migration

      # Only implements up, not down
      def up do
        create_table(:test_table) do
          add(:name, :string)
        end
      end
    end

    assert_raise RuntimeError, fn ->
      InvalidMigration.run(:down)
    end
  end
end
