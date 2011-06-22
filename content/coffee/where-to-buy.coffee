# list of stores and locations
# navigator.geolocation
# calc delta of user location to stores
# 

getUserLocation = ->
    navigator.geolocation?.getCurrentPosition (geopos) ->
        user_loc = geopos?.coords
        if user_loc?.latitude? and user_loc?.longitude?
            findDeltas(user_loc)

findDeltas = (user_loc) ->
    deltas = []
    for store in store_locations
        # Doesn't work across hemispheres!
        u_lat = Math.abs(user_loc.latitude) * Math.PI / 180
        u_lng = Math.abs(user_loc.longitude) * Math.PI / 180
        s_lat = Math.abs(store.latitude) * Math.PI / 180
        s_lng = Math.abs(store.longitude) * Math.PI / 180

        acos = Math.acos
        cos = Math.cos
        sin = Math.sin
        
        radius = 3959 # miles
        delta = acos(cos(u_lat)*cos(u_lng)*cos(s_lat)*cos(s_lng) + cos(u_lat)*sin(u_lng)*cos(s_lat)*sin(s_lng) + sin(u_lat)*sin(s_lat)) * radius

        deltas.push
            delta   : delta
            store   : store

    deltas.sort (a, b) -> a.delta - b.delta

    renderStore(deltas)

deltaToStoreLink = (delta) ->
    store = delta.store
    name = store.name
    if store.website
        name = "<a href='#{ store.website }'>#{ name }</a>"
    map_link = ""
    if store.address
        query = escape("#{ store.name } #{ store.address }")
    else
        query = escape("#{ store.latitude }, #{ store.longitude }")
    
    if delta.delta < 1
        delta.delta = delta.delta.toFixed(1)
    else
        delta.delta = delta.delta.toFixed(0)
    map_link = " (#{ delta.delta } mi, <a href='http://maps.google.com/?q=#{ query }'>map</a>)"
    return "#{ name }#{ map_link }"

renderStore = (deltas) ->
    if deltas.length > 0
        template = "Available at #{ deltaToStoreLink(deltas[0]) }, and <span>other fine establishments</span>."
        store_list = ""
        max = 5
        if deltas.length < max
            max = deltas.length
        for delta in deltas[1...max]
            store_list += "<li>#{ deltaToStoreLink(delta) }</li>"
        $('div#store p').html(template)
        $ul = $('div#store ul')
        $ul.html(store_list)
        $('div#store p span').click ->
            $ul.slideToggle(200)

window.storeInit = ->
    getUserLocation()


store_locations = [
  {
      name      : "Pioneer Food Market"
      address   : "77 Congress Street, Troy, New York 12180"
      website   : "http://www.troyfoodcoop.com"
      latitude  : 42.728752
      longitude : -73.69043
  }
  {
      name: "y"
      address: "y"
      website: "y"
      latitude: 20
      longitude: 3.69043
  }
  {
      name: "x"
      address: "x"
      website: "x"
      latitude: 52.728752
      longitude: -93.69043
  }
]