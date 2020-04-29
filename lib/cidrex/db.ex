defmodule Cidrex.DB do
  defstruct cidr_db: nil

  def load(raw_cidrs) do
    db =
      for {key, raw_cidr} <- raw_cidrs, into: [] do
        cidr = CIDR.parse(raw_cidr)
        {cidr.mask, cidr, key}
      end
      |> Enum.sort(fn {m1, _, _}, {m2, _, _} -> m2 <= m1 end)

    %__MODULE__{cidr_db: db}
  end
end
