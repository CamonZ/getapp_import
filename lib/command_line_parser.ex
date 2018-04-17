defmodule Import.CommandLineParser do
  alias Import.CLI

  def parse(%CLI{}=token, [importer, location] = args) when is_list(args) and length(args) == 2 do
    Map.merge(token, %{importer: importer, location: location})
  end

  def parse(%CLI{errors: errors} = token, args) when is_list(args) do
    Map.put(token, :errors, [{:error, :unrecognized_arguments_length} | errors])
  end

  def parse(%CLI{errors: errors} = token, _) do
    Map.put(token, :errors, [{:error, :unrecognized_arguments_type} | errors])
  end
end
