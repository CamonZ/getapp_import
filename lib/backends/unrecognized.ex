defmodule Importer.Backends.Unrecognized do
 def process(_), do: {:error, :unrecognized_backend_type}
end
