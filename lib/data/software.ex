defmodule Import.Software do
  defstruct name: nil, categories: [], twitter: nil
  alias __MODULE__

  def new(name, categories, twitter \\ nil) do
    %Software{name: name, categories: categories, twitter: twitter}
  end
end
