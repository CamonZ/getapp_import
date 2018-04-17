defmodule Import.CLI do
  defstruct softwares: [], errors: [], importer: nil, location: nil

  alias __MODULE__

  def main(argv) do
    %CLI{}
    |> CommandLineParser.parse(argv)
  end
end
