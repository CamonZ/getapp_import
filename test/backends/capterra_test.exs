defmodule CapterraTest do
  use ExUnit.Case
  doctest Import.Backends.Capterra

  alias Import.Backends.Capterra
  alias Import.Software

  describe "process/1" do
    test "returns an error when the data_location does not exist" do
      {:error, message} = Capterra.process("non_existant_source.yaml")
      assert :error_opening_data_location == message
    end

    test "returns an error when the data source is malformed" do
      {:error, message} = Capterra.process("test/sample_data/capterra_malformed.yaml")
      assert :malformed_data_source == message
    end

    test "returns a collection of Software structs when the data_location is parseable" do
      {:ok, softwares} = Capterra.process("test/sample_data/capterra.yaml")

      [github, slack, jira] = softwares

      assert %Software{
        name: "GitGHub",
        categories: ["Bugs & Issue Tracking","Development Tools"],
        twitter: "@github"
      } == github

      assert %Software{
        name: "Slack",
        categories: ["Instant Messaging & Chat","Web Collaboration", "Productivity"],
        twitter: "@slackhq"
      } == slack

      assert %Software{
        name: "JIRA Software",
        categories: ["Project Management","Project Collaboration","Development Tools"],
        twitter: "@jira"
      } == jira
    end

    test "returns only the parseable entries in the data_location" do
      {:ok, [jira]} = Capterra.process("test/sample_data/capterra_with_incomplete_entries.yaml")

      assert %Software{
        name: "JIRA Software",
        categories: ["Project Management","Project Collaboration","Development Tools"],
        twitter: "@jira"
      } == jira
    end
  end
end
