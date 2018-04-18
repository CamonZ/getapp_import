defmodule Import.ResultsHandler do
  alias Import.{StateToken, Software}

  def print_results(%StateToken{errors: errors}) when length(errors) > 0 do
    IO.puts "Couldn't import data due to the following reasons:"
    Enum.each(errors, &print_error(&1))
  end

  def print_results(%StateToken{softwares: softwares}) when length(softwares) > 0 do
    IO.puts "The followed softwares have been processed"
    Enum.each(softwares, &print_import(&1))
  end

  defp print_error({:error, reason}) do
    message = reason
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.capitalize()

    IO.puts "* #{message}"
  end

  defp print_import({:ok, software}) do
    IO.puts "* Imported: #{Software.to_string(software)}"
  end
end
