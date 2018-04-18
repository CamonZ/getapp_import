defmodule Import.CommandLineParser do
  alias Import.StateToken

  def parse(%StateToken{}=token, [importer, location] = args) when is_list(args) and length(args) == 2 do
    Map.merge(token, %{selected_backend: importer, data_location: location})
  end

  def parse(%StateToken{errors: errors} = token, args) when is_list(args) do
    Map.put(token, :errors, [{:error, :unrecognized_arguments_length} | errors])
  end

  def parse(%StateToken{errors: errors} = token, _) do
    Map.put(token, :errors, [{:error, :unrecognized_arguments_type} | errors])
  end
end
