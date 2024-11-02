document.addEventListener('turbo:load', function() {
  const input = document.querySelector("#phone_number");
  const hiddenPhoneNumber = document.querySelector("#hidden_phone_number");

    if (!input || !hiddenPhoneNumber) return;  // Ensure the elements exist before proceeding

    const iti = intlTelInput(input, {
      initialCountry: "auto",
      geoIpLookup: function(callback) {
        fetch('https://ipinfo.io', { method: 'GET', headers: { 'Accept': 'application/json' } })
        .then(resp => resp.json())
        .then(data => {
          const countryCode = (data && data.country) ? data.country : "us";
          callback(countryCode);
        })
        .catch(() => {
          callback('us');
        });
      },
      separateDialCode: true,
      utilsScript: "https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/utils.js"
    });

    // Set the initial country code when the page loads
    hiddenPhoneNumber.value = iti.getNumber();

    // Update the country code when the flag is changed
    input.addEventListener('countrychange', function() {
      const selectedCountryData = iti.getSelectedCountryData();
      const countryCode = selectedCountryData.dialCode;
      hiddenPhoneNumber.value = `+${countryCode}`;
    });

    // When the form is submitted, set the hidden field with the full phone number
    document.querySelector('form').addEventListener('submit', function() {
      hiddenPhoneNumber.value = iti.getNumber();  // Full number with country code for submission
    });
  });
