defmodule Import.CLI do
  defstruct softwares: [], errors: [], importer: nil, location: nil

  alias Import.{CommandLineParser, BackendDelegator}
  alias __MODULE__

  def main(argv) do
    %CLI{}
    |> CommandLineParser.parse(argv)
    |> BackendDelegator.process_options()
  end
end
