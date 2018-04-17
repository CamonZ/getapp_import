defmodule Import.Backends.SoftwareAdvice do
  alias Import.Software

  def process(location) do
    case File.read(location) do
      {:ok, raw_json} -> decode(raw_json)
      {:error, _} -> {:error, :error_opening_data_location}
    end
  end

  defp decode(data) do
    case Poison.decode(data) do
      {:ok, %{"products" => entries}} -> map_entries_to_softwares(entries)
      {:error, _} -> {:error, :malformed_data_source}
    end
  end

  defp map_entries_to_softwares(entries) when is_list(entries) do
    result = entries
    |> Enum.map(&to_software(&1))
    |> Enum.reject(&is_nil/1)

    {:ok, result}
  end

  defp map_entries_to_softwares(_) do
    {:error, :malformed_data_source}
  end


  defp to_software(%{"categories" => categories, "title" => name, "twitter" => twitter}) do
    Map.put(to_software(%{"categories" => categories, "title" => name}), :twitter, twitter)
  end

  defp to_software(%{"categories" => categories, "title" => name}) do
    Software.new(name, categories)
  end

  defp to_software(_) do
    nil
  end
end
