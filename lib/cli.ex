defmodule Import.CLI do

  alias Import.{CommandLineParser, BackendDelegator, StateToken}

  def main(argv) do
    %StateToken{}
    |> CommandLineParser.parse(argv)
    |> BackendDelegator.process_options()
  end
end
