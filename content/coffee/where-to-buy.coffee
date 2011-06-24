# These are included in case there is a problem with the main list
# from /js/store_locations.js, e.g. a syntax error in the file.
default_stores = [
  {
      name      : "Pioneer Food Market"
      address   : "77 Congress Street, Troy, New York 12180"
      website   : "http://www.troyfoodcoop.com"
      latitude  : 42.728752
      longitude : -73.69043
  }
]

store_locations = window.store_locations or default_stores



# If the browser supports geolocation, get the user's location for use in
# selecting nearby stores.
getUserLocation = ->
    if navigator.geolocation?
        navigator.geolocation.getCurrentPosition (geopos) ->
            user_loc = geopos?.coords
            if user_loc?.latitude? and user_loc?.longitude?
                findDeltas(user_loc)
    else
        randomStores()



# Select stores randomly from the list of possible stores.
randomStores = ->
    selected_stores = []
    for i in [0..4]
        index = Math.floor(Math.random()*store_locations.length)
        selected_stores.push
            store: store_locations[index]
        store_locations = store_locations[0...index].concat(store_locations[index+1...store_locations.length])
    renderStore(selected_stores)



# Find the distances between the user's location and the store locations.
# Then sort the list in ascending order by distance.
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
    
    if delta.delta?
        if delta.delta < 1
            delta.delta = delta.delta.toFixed(1)
        else
            delta.delta = delta.delta.toFixed(0)
        link_text = "#{ delta.delta } mi"
    else
        link_text = 'map'
    map_link = " (<a href='http://maps.google.com/?q=#{ query }'>#{ link_text }</a>)"
    return "#{ name }#{ map_link }"



renderStore = (deltas) ->
    if deltas.length > 0
        if deltas.length > 1
            extra_text = ', and <span>other fine establishments</span>'
        else
            extra_text = ''
        template = "Available at #{ deltaToStoreLink(deltas[0]) }#{ extra_text }."
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



window.storeInit = -> getUserLocation()
