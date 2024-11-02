document.addEventListener('turbo:load', () => {
  function setupAutocomplete(inputField, dropdownClassName, hiddenCountryField) {
    const dropdown = document.createElement('ul');
    dropdown.className = dropdownClassName;
    inputField.parentNode.appendChild(dropdown);

    inputField.addEventListener('input', () => {
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
            dropdown.innerHTML = '';

            data.locations.forEach(location => {
              const item = document.createElement('li');
              item.className = 'autocomplete-item';
              item.innerHTML = `
                <div>
                  <div class="location">${location.name}</div>
                  <div class="address">${location.area}, ${location.country}</div>
                </div>
                <div class="arrow">&gt;</div>
              `;
              item.addEventListener('click', () => {
                inputField.value = location.name;
                hiddenCountryField.value = location.country; // Set the country field
                dropdown.innerHTML = '';
              });
              dropdown.appendChild(item);
            });
          })
          .catch(error => console.error('Error fetching cities:', error));
      } else {
        dropdown.innerHTML = '';
      }
    });

    document.addEventListener('click', (event) => {
      if (!dropdown.contains(event.target) && event.target !== inputField) {
        dropdown.innerHTML = '';
      }
    });
  }

  // Setup flatpickr
  flatpickr("#date_field", {
    dateFormat: "Y-m-d",
    altInput: true,
  });

  // Set up autocomplete for fields
  const departureCity = document.getElementById('departure_city_select');
  const arrivalCity = document.getElementById('arrival_city_select');
  const departureCountry = document.getElementById('departure_country');
  const arrivalCountry = document.getElementById('arrival_country');

  if (departureCity && departureCountry) setupAutocomplete(departureCity, 'autocomplete-dropdown', departureCountry);
  if (arrivalCity && arrivalCountry) setupAutocomplete(arrivalCity, 'autocomplete-dropdown', arrivalCountry);
});
