defmodule Cards do

  @moduledoc """
    Provides methos for creating and handling a deck of cards
  """

  @doc """
  Returns a list of strings represent a list of cards
  """
  def create_deck do
    values = ["As", "2", "3", "4", "5"]
    suits = ["Spades", "Clubs", "Hearts", "Diament"]

    # el for es un map o list comprehensions devuelve una nueva lista
    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end

  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
    Determines whether a deck contains a given card

  ## Examples
      iex> deck = Cards.create_deck
      iex> deck = Cards.contains?(deck, "As of Spades")
      true

  """
  def contains?(deck, card) do
    Enum.member?(deck,card)
  end

  def find_card(deck, card) do
    Enum.find_value(deck, card)
  end

  @doc """
    Divides a deck into a hand and the remainder of the deck.
    the `hand_size` argument indicates how many cards should be in the hand.

  ## Examples

        iex> deck = Cards.create_deck
        iex> {hand, deck} = Cards.deal(deck, 1)
        iex> hand
        ["As of Spades"]
  """
  def deal(deck, hand_size) do
    # asignacion de variables
    # ya que el split devuelve una tupla  {}
    # la reasignacion de variables se hace con posiciones (parecido a python)
    # hand obtiene la primera posicion de la tupla, rest_of_deck obtiene la segunda posicion
    Enum.split(deck, hand_size)
  end

  def save(deck, file) do
    binary = :erlang.term_to_binary(deck)
    File.write(file, binary)
  end

  def load_deck(file_name) do
    {status, binary} = File.read(file_name)
    # evitar el uso de sentencias if en elixir, usar el case
    case status do
      # cuando es un solo parametro, al pasarle el nombre sin parentesis
      :ok -> :erlang.binary_to_term binary
      :error -> "That file does not exist"
    end
  end

  def load(file_name) do
    # Pattern Matching
    # al saber que la funcion read nos devuelve una tupla de status y el binario
    # elixir sabe que el primer valor de la tupla seran los estados
    # el segundo valor sera el binario que se esta pasando
    case File.read(file_name) do
      # el read devolver una tupla en el case se aplica de esta manera
      # donde recivimos una tupla donde indicamos un valor forzozamente sea :ok o :error
      # y en el segundo elemento es una variable donde asignamos la segunda posicion
      {:ok, binary} -> :erlang.binary_to_term binary
      # para indicar a elixir que hay una variables que no queremos usar para eviar warnings al compilar o algun error
      # ya que elixir si devuelve una tupla de dos elementos tenemos que indicar dos elementos en la asignacion de variables
      # al poner el _variableName le indicamos a elixir que ignore ese valor o variables
      {:error, _reason } -> "That file does not exist"
    end
  end

  # Pipe Operator
  def create_hand(hand_size) do
    # al usar Pipe el resultado de una funcion se pasa a otra de manera automatica
    Cards.create_deck
    |> Cards.shuffle
    # lo que devuelve la funcion se le asinga siempre como primer argumento de la siguiente funcion
    |> Cards.deal(hand_size)
  end

end


# list son los array
# tuple representados con {}
