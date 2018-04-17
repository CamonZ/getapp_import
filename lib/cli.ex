defmodule Import.CLI do

  alias Import.{CommandLineParser, BackendDelegator, StateToken, BackendsRegistrator}

  def main(argv) do
    %StateToken{}
    |> CommandLineParser.parse(argv)
    |> BackendsRegistrator.get_backends()
    |> BackendDelegator.process_options()
  end
end
