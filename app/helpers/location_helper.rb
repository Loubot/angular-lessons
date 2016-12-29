module LocationHelper
  
  def counties_with_coords
    { 
      Antrim: { county: 'Co. Antrim', latitude: 54.719508, longitude: -6.207256 }, Armagh: { county: 'Co. Armagh', latitude: 54.350277, longitude: -6.652822},
      Carlow: { county: 'Co. Carlow', latitude: 52.836497, longitude: -6.934238}, Cavan: { county: 'Co. Cavan', latitude: 53.989637, longitude: -7.363272 },
      Clare: { county: 'Co. Clare', latitude: 52.847097, longitude: -8.989040 }, Cork: { county: 'Co. Cork', latitude: 51.897887, longitude: -8.475431},
      Derry: { county: 'Co. Derry', latitude: 54.996669, longitude: -7.308567 }, Donegal: { county: 'Co. Donegal', latitude: 54.832874, longitude: -7.485811},
      Down: { county: 'Co. Down', latitude: 54.328787, longitude: -5.715719 }, Dublin: { county: 'Co. Dublin', latitude: 53.346591, longitude: -6.265231 },
      Fermanagh: { county: 'Co. Fermanagh', latitude: 54.343928, longitude: -7.631644 }, Galway: { county: 'Co. Galway', latitude: 53.270672, longitude: -9.056779 },
      Kerry: { county: 'Co. Kerry', latitude: 52.059816, longitude: -9.504487 }, Kildare: { county: 'Co. Kildare', latitude: 53.220438, longitude: -6.659570 },
      Kilkenny: { county: 'Co. Kilkenny', latitude: 52.653411, longitude: -7.248446 }, Laois: { county: 'Co. Laois', latitude: 53.032791, longitude: -7.300100 },
      Leitrim: { county: 'Co. Leitrim', latitude: 53.945234, longitude: -8.086559 }, Limerick: { county: 'Co. Limerick', latitude: 52.664942, longitude: -8.628080 },
      Longford: { county: 'Co. Longford', latitude: 53.727371, longitude: -7.793887}, Louth: { county: 'Co. Louth', latitude: 53.999672, longitude: -6.406295 },
      Mayo: { county: 'Co. Mayo', latitude: 53.854566, longitude: -9.288492 }, Meath: { county: 'Co. Meath', latitude: 53.647000, longitude: -6.697336 },
      Monaghan: { county: 'Co. Monaghan', latitude: 54.248650, longitude: -6.969560 }, Offaly: { county: 'Co. Offaly', latitude: 53.275140, longitude: -7.493240 },
      Roscommon: { county: 'Co. Roscommon', latitude: 53.627545, longitude: -8.189194 }, Sligo: { county: 'Co. Sligo', latitude: 54.273910, longitude: -8.473718 }, 
      Tipperary: { county: 'Co. Tipperary', latitude: 52.356254, longitude: -7.695380 }, Tyrone: { county: 'Co. Tyrone', latitude: 54.597003, longitude: -7.310752 },
      Waterford: { county: 'Co. Waterford', latitude: 52.257693, longitude: -7.110284 }, Westmeath: { county: 'Co. Westmeath', latitude: 53.524646, longitude: -7.339487 },
      Wexford: { county: 'Co. Wexford', latitude: 52.333583, longitude: -6.474672 }, Wicklow: { county: 'Co. Wicklow', latitude: 52.980215, longitude: -6.060273 } 
    }
  end

end