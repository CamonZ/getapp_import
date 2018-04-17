defmodule Import.BackendsRegistrator do
  alias Import.StateToken
  alias Import.Backends.{Capterra, SoftwareAdvice, Unrecognized}

  def get_backends(%StateToken{registered_backends: %{}} = token) do
    Map.put(token, :registered_backends, backends())
  end

  defp backends do
    %{"capterra" => Capterra, "softwareadvice" => SoftwareAdvice, "unrecognized" => Unrecognized}
  end
end
