document.addEventListener('turbo:load', () => {
  // Function to handle selection buttons
  const handleSelection = (buttonClass, hiddenFieldId) => {
    const buttons = document.querySelectorAll(buttonClass);
    const hiddenField = document.getElementById(hiddenFieldId);

    if (buttons.length > 0 && hiddenField) {
      buttons.forEach(button => {
        button.addEventListener('click', function() {
          buttons.forEach(btn => btn.classList.remove('active')); // Remove active class
          this.classList.add('active'); // Add active class
          hiddenField.value = this.getAttribute('data-value'); // Update hidden field
        });
      });
    }
  };

  // Initialize trip type, transportation, and parcel collection modes
  handleSelection(".trip-type-button", "selected_trip_type");
  handleSelection(".transportation-button", "selected_transportation");
  handleSelection(".parcel-collection-mode-button", "selected_parcel_collection_mode");
  handleSelection(".parcel-type-button", "selected_parcel_type");

  // Handle parcel quantity display
  const quantityInput = document.getElementById("parcel_qty");
  const quantityDisplay = document.getElementById("quantity_display");

  if (quantityInput && quantityDisplay) {
    quantityInput.addEventListener('input', function() {
      const quantityValue = quantityInput.value || 0; // Default to 0 if empty
      quantityDisplay.textContent = `Qty: ${quantityValue}`;
      quantityInput.value = quantityValue; // Make sure the input's value is updated
    });
  }

  // Handle trip type and show/hide return date based on selection
  const returnDateContainer = document.getElementById("return_date_container");
  const selectedTripTypeField = document.getElementById("selected_trip_type");

  if (returnDateContainer && selectedTripTypeField) {
    const tripTypeButtons = document.querySelectorAll(".trip-type-button");

    tripTypeButtons.forEach(button => {
      button.addEventListener("click", function() {
        const selectedValue = this.getAttribute("data-value");
        selectedTripTypeField.value = selectedValue;

        // Show/hide return date based on trip type
        returnDateContainer.style.display = selectedValue === "round_trip" ? "block" : "none";
      });
    });
  }
});
