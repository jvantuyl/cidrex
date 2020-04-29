defmodule CidrexTest do
  use ExUnit.Case
  doctest Cidrex

  @raw_cidrs %{
    default4: "0.0.0.0/0",
    default6: "::/0",
    net1: "147.229.0.0/16",
    net2: "147.229.3.0/24",
    host3: "147.229.3.10/32",
    host4: "147.229.3.11",
    net16: "2001:67c:1220::/32",
    net26: "2001:67c:1220:f565::/64",
    host36: "2001:67c:1220:f565::1235/128",
    host46: "2001:67c:1220:f565::1236"
  }

  test "greets the world" do
    cidrs = Cidrex.DB.load(@raw_cidrs)

    net1 = Cidrex.find_lpm(cidrs, "147.229.100.100")
    hst1 = Cidrex.find_lpm(cidrs, "147.229.3.10")
    net2 = Cidrex.find_lpm(cidrs, "2001:67c:1220::1")

    assert to_string(net1) == "net1"
    assert to_string(hst1) == "host3"
    assert to_string(net2) == "net16"
  end
end
