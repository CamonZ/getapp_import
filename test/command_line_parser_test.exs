defmodule CommandLineParserTest do
  use ExUnit.Case
  doctest Import.CommandLineParser

  alias Import.{CommandLineParser, StateToken}

  test "Appends an error to the state token when the args length is not 2" do
    %StateToken{errors: errors, selected_backend: nil, data_location: nil} = CommandLineParser.parse(%StateToken{}, ["foo"])

    assert length(errors) == 1
    assert [{:error, :unrecognized_arguments_length}] == errors

    %StateToken{errors: errors, selected_backend: nil, data_location: nil} = CommandLineParser.parse(%StateToken{}, ["foo", "bar", "baz"])

    assert length(errors) == 1
    assert [{:error, :unrecognized_arguments_length}] == errors
  end

  test "Appends an error to the state token when args is not a list" do
    %StateToken{errors: errors, selected_backend: nil, data_location: nil} = CommandLineParser.parse(%StateToken{}, %{foo: "Foo"})

    assert length(errors) == 1
    assert [{:error, :unrecognized_arguments_type}] == errors
  end

  test "Appends the importer name and data location to the state token when args are correct" do
    arguments = ["capterra", "feed-products/capterra.yml"]
    %StateToken{errors: [], selected_backend: backend, data_location: location} = CommandLineParser.parse(%StateToken{}, arguments)

    assert "capterra" == backend
    assert "feed-products/capterra.yml" == location
  end
end
