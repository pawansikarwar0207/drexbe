import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

// Connects to data-controller="autocomplete"
export default class extends Controller {
  static targets = ["departureCity", "arrivalCity", "departureCountry", "arrivalCountry", "dateField"];

  connect() {
    console.log("autocomplete connected")
    this.setupFlatpickr();
    this.setupAutocomplete(this.departureCityTarget, "autocomplete-dropdown", this.departureCountryTarget);
    this.setupAutocomplete(this.arrivalCityTarget, "autocomplete-dropdown", this.arrivalCountryTarget);
  }
  setupFlatpickr() {
    if (this.hasDateFieldTarget) {
      flatpickr(this.dateFieldTarget, {
        dateFormat: "Y-m-d",
        altInput: true,
      });
    }
  }
  setupAutocomplete(inputField, dropdownClassName, hiddenCountryField) {
    const dropdown = document.createElement("ul");
    dropdown.className = dropdownClassName;
    inputField.parentNode.appendChild(dropdown);

    inputField.addEventListener("input", () => {
      const query = inputField.value;
      const url = `/get_cities?query=${encodeURIComponent(query)}`;

      if (query.length > 2) {
        fetch(url)
          .then(response => {
            if (!response.ok) {
              throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
          })
          .then(data => {
            dropdown.innerHTML = "";

            data.locations.forEach(location => {
              const item = document.createElement("li");
              item.className = "autocomplete-item";
              item.innerHTML = `
                <div>
                  <div class="location">${location.name}</div>
                  <div class="address">${location.area}, ${location.country}</div>
                </div>
                <div class="arrow">&gt;</div>
              `;
              item.addEventListener("click", () => {
                inputField.value = location.name;
                hiddenCountryField.value = location.country; // Set the country field
                dropdown.innerHTML = "";
              });
              dropdown.appendChild(item);
            });
          })
          .catch(error => console.error("Error fetching cities:", error));
      } else {
        dropdown.innerHTML = "";
      }
    });

    document.addEventListener("click", event => {
      if (!dropdown.contains(event.target) && event.target !== inputField) {
        dropdown.innerHTML = "";
      }
    });
  }
}
