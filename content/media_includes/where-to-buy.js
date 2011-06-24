(function() {
  var default_stores, deltaToStoreLink, findDeltas, getUserLocation, randomStores, renderStore, store_locations;
  default_stores = [
    {
      name: "Pioneer Food Market",
      address: "77 Congress Street, Troy, New York 12180",
      website: "http://www.troyfoodcoop.com",
      latitude: 42.728752,
      longitude: -73.69043
    }
  ];
  store_locations = window.store_locations || default_stores;
  getUserLocation = function() {
    if (navigator.geolocation != null) {
      return navigator.geolocation.getCurrentPosition(function(geopos) {
        var user_loc;
        user_loc = geopos != null ? geopos.coords : void 0;
        if (((user_loc != null ? user_loc.latitude : void 0) != null) && ((user_loc != null ? user_loc.longitude : void 0) != null)) {
          return findDeltas(user_loc);
        }
      });
    } else {
      return randomStores();
    }
  };
  randomStores = function() {
    var i, index, selected_stores;
    selected_stores = [];
    for (i = 0; i <= 4; i++) {
      index = Math.floor(Math.random() * store_locations.length);
      selected_stores.push({
        store: store_locations[index]
      });
      store_locations = store_locations.slice(0, index).concat(store_locations.slice(index + 1, store_locations.length));
    }
    return renderStore(selected_stores);
  };
  findDeltas = function(user_loc) {
    var acos, cos, delta, deltas, radius, s_lat, s_lng, sin, store, u_lat, u_lng, _i, _len;
    deltas = [];
    for (_i = 0, _len = store_locations.length; _i < _len; _i++) {
      store = store_locations[_i];
      u_lat = Math.abs(user_loc.latitude) * Math.PI / 180;
      u_lng = Math.abs(user_loc.longitude) * Math.PI / 180;
      s_lat = Math.abs(store.latitude) * Math.PI / 180;
      s_lng = Math.abs(store.longitude) * Math.PI / 180;
      acos = Math.acos;
      cos = Math.cos;
      sin = Math.sin;
      radius = 3959;
      delta = acos(cos(u_lat) * cos(u_lng) * cos(s_lat) * cos(s_lng) + cos(u_lat) * sin(u_lng) * cos(s_lat) * sin(s_lng) + sin(u_lat) * sin(s_lat)) * radius;
      deltas.push({
        delta: delta,
        store: store
      });
    }
    deltas.sort(function(a, b) {
      return a.delta - b.delta;
    });
    return renderStore(deltas);
  };
  deltaToStoreLink = function(delta) {
    var link_text, map_link, name, query, store;
    store = delta.store;
    name = store.name;
    if (store.website) {
      name = "<a href='" + store.website + "'>" + name + "</a>";
    }
    map_link = "";
    if (store.address) {
      query = escape("" + store.name + " " + store.address);
    } else {
      query = escape("" + store.latitude + ", " + store.longitude);
    }
    if (delta.delta != null) {
      if (delta.delta < 1) {
        delta.delta = delta.delta.toFixed(1);
      } else {
        delta.delta = delta.delta.toFixed(0);
      }
      link_text = "" + delta.delta + " mi";
    } else {
      link_text = 'map';
    }
    map_link = " (<a href='http://maps.google.com/?q=" + query + "'>" + link_text + "</a>)";
    return "" + name + map_link;
  };
  renderStore = function(deltas) {
    var $ul, delta, extra_text, max, store_list, template, _i, _len, _ref;
    if (deltas.length > 0) {
      if (deltas.length > 1) {
        extra_text = ', and <span>other fine establishments</span>';
      } else {
        extra_text = '';
      }
      template = "Available at " + (deltaToStoreLink(deltas[0])) + extra_text + ".";
      store_list = "";
      max = 5;
      if (deltas.length < max) {
        max = deltas.length;
      }
      _ref = deltas.slice(1, max);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        delta = _ref[_i];
        store_list += "<li>" + (deltaToStoreLink(delta)) + "</li>";
      }
      $('div#store p').html(template);
      $ul = $('div#store ul');
      $ul.html(store_list);
      return $('div#store p span').click(function() {
        return $ul.slideToggle(200);
      });
    }
  };
  window.storeInit = function() {
    return getUserLocation();
  };
}).call(this);
