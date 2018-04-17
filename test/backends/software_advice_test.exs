defmodule SoftwareAdviceTest do
  use ExUnit.Case
  doctest Import.Backends.SoftwareAdvice

  alias Import.Backends.SoftwareAdvice
  alias Import.Software

  describe "process/1" do
    test "returns an error when the data_location does not exist" do
      {:error, message} = SoftwareAdvice.process("non_existant_source.json")
      assert :error_opening_data_location == message
    end

    test "returns an error when the data source is malformed" do
      {:error, message} = SoftwareAdvice.process("test/sample_data/softwareadvice_malformed.json")
      assert :malformed_data_source == message
    end

    test "returns a collection of Software structs when the data_location is parseable" do
      {:ok, softwares} = SoftwareAdvice.process("test/sample_data/softwareadvice.json")

      [freshdesk, zoho] = softwares

      assert %Software{
        name: "Freshdesk",
        categories: ["Customer Service","Call Center"],
        twitter: "@freshdesk"
      } == freshdesk

      assert %Software{
        name: "Zoho",
        categories: ["CRM","Sales Management"],
        twitter: nil
      } == zoho
    end

    test "returns only the parseable entries in the data_location" do
      {:ok, [zoho]} = SoftwareAdvice.process("test/sample_data/softwareadvice_with_incomplete_entries.json")

      assert %Software{
        name: "Zoho",
        categories: ["CRM","Sales Management"],
        twitter: nil
      } == zoho
    end
  end
end
