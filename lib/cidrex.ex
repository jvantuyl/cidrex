defmodule Cidrex do
  @moduledoc false
  alias CIDR

  def find_lpm(%Cidrex.DB{} = cidrs, addr) do
    find_lpm(cidrs.cidr_db, addr, nil, 0)
  end

  def find_lpm([], _addr, found_key, _mask) do
    found_key
  end

  def find_lpm(
        [{current_mask, %CIDR{mask: current_mask} = cidr, key} | cidrs],
        addr,
        found_key,
        longest_mask
      ) do
    matched =
      case CIDR.match(cidr, addr) do
        {:ok, matched} -> matched
        {:error, "Argument must be a binary or IP tuple of the same protocol"} -> false
      end

    longer = current_mask > longest_mask

    case {matched, longer} do
      {false, _} -> find_lpm(cidrs, addr, found_key, longest_mask)
      {true, false} -> find_lpm(cidrs, addr, found_key, longest_mask)
      {true, true} -> find_lpm(cidrs, addr, key, current_mask)
    end
  end
end
