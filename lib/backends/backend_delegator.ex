defmodule Import.BackendDelegator do
  alias Import.StateToken

  def process_options(%StateToken{errors: errors} = token) when errors != [] do
    token
  end

  def process_options(%StateToken{data_location: location} = token) do
    case backend_for(token).process(location) do
      {:ok, softwares} -> Map.put(token, :softwares, softwares)
      {:error, reason} -> Map.put(token, :errors, [{:error, reason}])
    end
  end

  defp backend_for(%StateToken{registered_backends: backends, selected_backend: selected}) do
    case Map.has_key?(backends, selected) do
      true -> backends[selected]
      false -> backends["unrecognized"]
    end
  end
end
