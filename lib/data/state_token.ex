defmodule Import.StateToken do
  defstruct registered_backends: %{}, errors: [], softwares: [], selected_backend: nil, data_location: nil
end
