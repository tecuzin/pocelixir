defmodule Blockchain.BlockTest do
  use ExUnit.Case
  alias Blockchain.Block

  describe "new/3" do
    test "crée un nouveau bloc valide" do
      transactions = [%{from: "Alice", to: "Bob", amount: 100}]
      previous_hash = "previous_hash"
      block = Block.new(1, transactions, previous_hash)

      assert block.index == 1
      assert block.transactions == transactions
      assert block.previous_hash == previous_hash
      assert is_binary(block.hash)
    end
  end

  describe "valid?/2" do
    test "valide un bloc correct" do
      previous_block = Block.new(0, [], "genesis")
      block = Block.new(1, [], previous_block.hash)

      assert {:ok, _} = Block.valid?(block, previous_block)
    end

    test "rejette un bloc avec un index invalide" do
      previous_block = Block.new(0, [], "genesis")
      block = Block.new(2, [], previous_block.hash)

      assert {:error, "Index invalide"} = Block.valid?(block, previous_block)
    end
  end
end 