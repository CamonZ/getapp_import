defmodule CommandLineParserTest do
  use ExUnit.Case
  doctest Import.CommandLineParser

  alias Import.{CommandLineParser, CLI}

  test "Appends an error to the state token when the args length is not 2" do
    %CLI{errors: errors, importer: nil, location: nil} = CommandLineParser.parse(%CLI{}, ["foo"])

    assert length(errors) == 1
    assert [{:error, :unrecognized_arguments_length}] == errors

    %CLI{errors: errors, importer: nil, location: nil} = CommandLineParser.parse(%CLI{}, ["foo", "bar", "baz"])

    assert length(errors) == 1
    assert [{:error, :unrecognized_arguments_length}] == errors
  end

  test "Appends an error to the state token when args is not a list" do
    %CLI{errors: errors, importer: nil, location: nil} = CommandLineParser.parse(%CLI{}, %{foo: "Foo"})

    assert length(errors) == 1
    assert [{:error, :unrecognized_arguments_type}] == errors
  end

  test "Appends the importer name and data location to the state token when args are correct" do
    arguments = ["capterra", "feed-products/capterra.yml"]
    %CLI{ errors: [], importer: importer, location: location} = CommandLineParser.parse(%CLI{}, arguments)

    assert "capterra" == importer
    assert "feed-products/capterra.yml" == location
  end
end
