defmodule Blockchain.Block do
  @moduledoc """
  Structure et fonctions pour la gestion des blocs de la blockchain.
  """

  defstruct [:index, :timestamp, :transactions, :previous_hash, :hash, :nonce]

  @type t :: %__MODULE__{
    index: non_neg_integer(),
    timestamp: integer(),
    transactions: list(map()),
    previous_hash: String.t(),
    hash: String.t(),
    nonce: non_neg_integer()
  }

  @doc """
  Crée un nouveau bloc avec les paramètres donnés.
  """
  def new(index, transactions, previous_hash) do
    block = %__MODULE__{
      index: index,
      timestamp: System.system_time(:millisecond),
      transactions: transactions,
      previous_hash: previous_hash,
      nonce: 0
    }
    %{block | hash: calculate_hash(block)}
  end

  @doc """
  Calcule le hash du bloc en utilisant ses propriétés.
  """
  def calculate_hash(block) do
    block
    |> block_contents()
    |> hash_string()
  end

  defp block_contents(block) do
    "#{block.index}#{block.timestamp}#{inspect(block.transactions)}#{block.previous_hash}#{block.nonce}"
  end

  defp hash_string(string) do
    :crypto.hash(:sha256, string)
    |> Base.encode16()
    |> String.downcase()
  end

  @doc """
  Vérifie si un bloc est valide.
  """
  def valid?(block, previous_block) do
    cond do
      block.index != previous_block.index + 1 ->
        {:error, "Index invalide"}
      block.previous_hash != previous_block.hash ->
        {:error, "Hash précédent invalide"}
      calculate_hash(block) != block.hash ->
        {:error, "Hash invalide"}
      true ->
        {:ok, block}
    end
  end
end 