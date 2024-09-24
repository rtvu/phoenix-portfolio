defmodule Portfolio.Quizzer.OpenTDB.CategoriesAPI do
  @all_categories "All Categories"
  @path "api_category.php"

  def all_categories() do
    @all_categories
  end

  def path() do
    @path
  end

  def get_categories(host_url) do
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.get(host_url <> @path),
         {:ok, %{"trivia_categories" => trivia_categories}} <- Poison.decode(body) do
      category_to_id =
        Enum.reduce(trivia_categories, %{}, fn %{"id" => id, "name" => name}, accumulator ->
          Map.put(accumulator, name, id)
        end)

      categories = [@all_categories] ++ Map.keys(category_to_id)

      {:ok, categories, category_to_id}
    else
      _ ->
        {:error, :failed_get_categories}
    end
  end
end
