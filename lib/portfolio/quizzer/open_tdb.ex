defmodule Portfolio.Quizzer.OpenTDB do
  use GenServer

  @open_tdb_host_url "https://opentdb.com/"

  defstruct host_url: @open_tdb_host_url

  # Client Side

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, __MODULE__)

    state = %__MODULE__{host_url: Keyword.get(opts, :host_url, @open_tdb_host_url)}

    GenServer.start_link(__MODULE__, state, opts)
  end

  # Server Side

  @impl true
  def init(%__MODULE__{} = state) do
    {:ok, state}
  end
end
