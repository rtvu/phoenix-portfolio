defmodule Portfolio.Quizzer.OpenTDB do
  use GenServer

  alias Portfolio.Quizzer.OpenTDB.CategoriesAPI

  @open_tdb_host_url "https://opentdb.com/"

  @retry_get_categories 10000

  @timeout_get_categories 5000

  defstruct categories: nil,
            category_to_id: nil,
            host_url: nil,
            initialized?: false,
            retry_get_categories: nil

  # Client Side

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, __MODULE__)

    state = %__MODULE__{
      host_url: Keyword.get(opts, :host_url, @open_tdb_host_url),
      retry_get_categories: Keyword.get(opts, :retry_get_categories, @retry_get_categories)
    }

    GenServer.start_link(__MODULE__, state, opts)
  end

  def get_categories(opts \\ []) do
    server = Keyword.get(opts, :server, __MODULE__)
    timeout = Keyword.get(opts, :timeout, @timeout_get_categories)

    GenServer.call(server, :get_categories, timeout)
  end

  # Server Side

  @impl true
  def init(%__MODULE__{} = state) do
    {:ok, state, {:continue, :get_categories}}
  end

  @impl true
  def handle_continue(:get_categories, %__MODULE__{} = state) do
    with {:ok, categories, category_to_id} <- CategoriesAPI.get_categories(state.host_url) do
      state = %{
        state
        | initialized?: true,
          categories: categories,
          category_to_id: category_to_id
      }

      {:noreply, state}
    else
      _ ->
        Process.send_after(self(), :get_categories, state.retry_get_categories)
        {:noreply, state}
    end
  end

  @impl true
  def handle_info(:get_categories, %__MODULE__{} = state) do
    {:noreply, state, {:continue, :get_categories}}
  end

  @impl true
  def handle_call(:get_categories, _from, %__MODULE__{} = state) do
    if state.initialized? do
      {:reply, {:ok, state.categories}, state}
    else
      {:reply, {:error, :not_initialized}, state}
    end
  end
end
