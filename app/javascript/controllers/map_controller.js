import "leaflet"
import "leaflet-control-geocoder"
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { travelersUrl: String }

  connect() {
    console.log("Map controller connected.")
    console.log("Leaflet version:", L.version)

    this.map = L.map('map').setView([20, 0], 2);

    L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(this.map);

    console.log("Map initialized.")
    
    fetch(this.travelersUrlValue)
    .then(res => res.json())
    .then(data => {
      data.travelers.forEach(traveler => {
        this.geocodeAndMark(traveler.departure_city, traveler.arrival_city, traveler, "traveler")
      })
      data.parcel_ads.forEach(parcel => {
        this.geocodeAndMark(parcel.departure_city, parcel.arrival_city, parcel, "parcel")
      })

      data.buy_for_mes.forEach(buy => {
        this.geocodeAndMark(buy.departure_city, buy.arrival_city, buy, "buy")
      })
    })
  }

  geocodeAndMark(departureCity, arrivalCity, entity, type) {
    console.log(`Geocoding departure: ${departureCity}, arrival: ${arrivalCity}`)

    const geocoder = {
      geocode: function(query, cb) {
        fetch(`/geocode?q=${encodeURIComponent(query)}`)
          .then(res => res.json())
          .then(data => {
            if (!Array.isArray(data)) {
              console.error("Unexpected geocode response:", data)
              cb([])
              return
            }
            const results = data.map(place => ({
              name: place.display_name,
              center: L.latLng(place.lat, place.lon),
              bbox: L.latLngBounds(
                L.latLng(place.boundingbox[0], place.boundingbox[2]),
                L.latLng(place.boundingbox[1], place.boundingbox[3])
              )
            }))
            cb(results)
          })
          .catch(err => {
            console.error("Geocoding failed", err)
            cb([])
          })
      }
    }

    const icon = {
      traveler: new L.Icon({
        iconUrl: "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-red.png",
        shadowUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png",
        iconSize: [25, 41],
        iconAnchor: [12, 41],
        popupAnchor: [1, -34],
        shadowSize: [41, 41]
      }),
      parcel: new L.Icon({
        iconUrl: "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-blue.png",
        shadowUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png",
        iconSize: [25, 41],
        iconAnchor: [12, 41],
        popupAnchor: [1, -34],
        shadowSize: [41, 41]
      }),
      buy: new L.Icon({
        iconUrl: "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-green.png",
        shadowUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png",
        iconSize: [25, 41],
        iconAnchor: [12, 41],
        popupAnchor: [1, -34],
        shadowSize: [41, 41]
      })
    }

    // Shared state object per entity
    const context = {
      depLatLng: null,
      arrLatLng: null,
      routeDrawn: false
    }

    const tryDrawRoute = () => {
      if (context.depLatLng && context.arrLatLng && !context.routeDrawn) {
        L.polyline([context.depLatLng, context.arrLatLng], {
          color: type === 'traveler' ? 'blue' : type === 'parcel' ? 'purple' : 'green',
          weight: 2,
          opacity: 0.7,
          dashArray: '5, 5'
        }).addTo(this.map)
        context.routeDrawn = true
      }
    }

    if (departureCity) {
      geocoder.geocode(departureCity, results => {
        console.log("Departure results:", results)
        if (results.length > 0) {
          context.depLatLng = results[0].center
          console.log("Adding departure marker at", context.depLatLng)

          const marker = L.marker(context.depLatLng, { icon: icon[type] }).addTo(this.map)
          const popupContent = this.generatePopupContent(entity, type, "departure")
          marker.bindPopup(popupContent)

          // tryDrawRoute()
        }
      })
    }

    if (arrivalCity) {
      geocoder.geocode(arrivalCity, results => {
        console.log("Arrival results:", results)
        if (results.length > 0) {
          context.arrLatLng = results[0].center
          console.log("Adding arrival marker at", context.arrLatLng)

          const marker = L.marker(context.arrLatLng, { icon: icon[type] }).addTo(this.map)
          const popupContent = this.generatePopupContent(entity, type, "arrival")
          marker.bindPopup(popupContent)

          // tryDrawRoute()
        }
      })
    }
  }



  generatePopupContent(entity, type, direction) {
    if (type === "traveler") {
      return `<b>${entity.name}</b><br>${direction === "departure" ? "Departs" : "Arrives"}: ${direction === "departure" ? entity.departure_city : entity.arrival_city}`
    } else if (type === "parcel") {
      return `<b>Parcel from ${entity.parcel_sender_name || "Unknown"}</b><br>${direction === "departure" ? "From" : "To"}: ${direction === "departure" ? entity.departure_city : entity.arrival_city}`
    } else if (type === "buy") {
      return `<b>Buy for ${entity.buyer_name || "Unknown"}</b><br>${direction === "departure" ? "Shop in" : "Deliver to"}: ${direction === "departure" ? entity.departure_city : entity.arrival_city}`
    } else {
      return "Unknown type"
    }
  }
}
