defmodule Import.CLI do

  alias Import.{
    CommandLineParser,
    BackendDelegator,
    StateToken,
    BackendsRegistrator,
    DataInserter,
    ResultsHandler}

  def main(argv) do
    %StateToken{}
    |> CommandLineParser.parse(argv)
    |> BackendsRegistrator.get_backends()
    |> BackendDelegator.process_options()
    |> DataInserter.process_software_list()
    |> ResultsHandler.print_results()
  end
end
