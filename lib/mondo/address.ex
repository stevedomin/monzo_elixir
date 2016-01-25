defmodule Mondo.Address do
  defstruct address: nil, approximate: nil, city: nil, country: nil,
            formatted: nil, latitude: nil, longitude: nil, postcode: nil,
            region: nil, short_formatted: nil, zoom_level: nil

  @type t :: %__MODULE__{
    address: String.t,
    approximate: boolean,
    city: String.t,
    country: String.t,
    formatted: String.t,
    latitude: String.t,
    longitude: String.t,
    postcode: String.t,
    region: String.t,
    short_formatted: String.t,
    zoom_level: integer
  }
end
