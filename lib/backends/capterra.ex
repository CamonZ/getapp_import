defmodule Import.Backends.Capterra do
  alias Import.Software

  def process(location) do
    case YamlElixir.read_all_from_file(location) do
      {:ok, entries} -> map_entries_to_softwares(entries)
      {:error, _} -> {:error, :malformed_data_source}
    end
  catch
    _ -> {:error, :error_opening_data_location}
  end

  defp map_entries_to_softwares(entries) when is_list(entries) do

    result = entries
    |> List.flatten()
    |> Enum.map(&to_software(&1))
    |> Enum.reject(&is_nil/1)

    {:ok, result}
  end

  defp map_entries_to_softwares(_) do
    {:error, :malformed_data_source}
  end


  defp to_software(%{"tags" => tags, "name" => name, "twitter" => twitter}) do
    Map.put(to_software(%{"tags" => tags, "name" => name}), :twitter, "@" <> twitter)
  end

  defp to_software(%{"tags" => tags, "name" => name}) do
    categories = tags |> String.split(",")
    Software.new(name, categories)
  end

  defp to_software(_) do
    nil
  end
end
