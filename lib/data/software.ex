defmodule Import.Software do
  defstruct name: nil, categories: [], twitter: nil
  alias __MODULE__

  def new(name, categories, twitter \\ nil) do
    %Software{name: name, categories: categories, twitter: twitter}
  end

  def to_string(%Software{name: name, categories: categories, twitter: twitter}) do
    str = "Name: #{name}; Categories: #{Enum.join(categories, ", ")}"

    case is_nil(twitter) do
      true -> str
      false -> str <> "; Twitter: #{twitter}"
    end
  end
end
