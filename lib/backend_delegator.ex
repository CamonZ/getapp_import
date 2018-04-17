defmodule Import.BackendDelegator do
  alias Import.StateToken

  def process_options(%StateToken{errors: errors} = token) when errors != [] do
    token
  end

  def process_options(%StateToken{selected_backend: backend, data_location: location} = token) do
    case importer_module(backend).process(location) do
      {:ok, softwares} -> Map.put(token, :softwares, softwares)
      {:error, reason} -> Map.put(token, :errors, [{:error, reason}])
    end
  end

  defp importer_module("capterra"), do: Importer.Backends.Capterra
  defp importer_module("softwareadvice"), do: Importer.Backends.SoftwareAdvice
  defp importer_module(_), do: Importer.Backends.Unrecognized
end
