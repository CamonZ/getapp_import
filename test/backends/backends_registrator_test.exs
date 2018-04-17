defmodule BackendsRegistratorTest do
  use ExUnit.Case
  doctest Import.BackendsRegistrator

  alias Import.{BackendsRegistrator, StateToken}
  alias Import.Backends.{Capterra, SoftwareAdvice, Unrecognized}

  describe "get_backends/1" do
    test "returns the existing backends in the system" do
      %StateToken{registered_backends: backends} = BackendsRegistrator.get_backends(%StateToken{})

      assert %{"capterra" => Capterra, "softwareadvice" => SoftwareAdvice, "unrecognized" => Unrecognized} == backends
    end
  end
end
