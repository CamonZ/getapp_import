defmodule Import.DataInserter do
  alias Import.StateToken

  def process_software_list(%StateToken{errors: errors} = token) when length(errors) > 0 do
    token
  end

  def process_software_list(%StateToken{softwares: softwares} = token) when is_list(softwares) do
    imported = Enum.map(softwares, &do_import(&1))
    Map.put(token, :softwares, imported)
  end

  # On this function is where we would build each changeset and insert on the Repo
  # or batch insert multiple changesets
  defp do_import(software) do
    {:ok, software}
  end
end
