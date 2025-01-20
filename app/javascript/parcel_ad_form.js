// document.addEventListener('turbo:load', () => {
//   // Select parcel type buttons and hidden field
//   const buttons = document.querySelectorAll(".parcel-type-button");
//   const hiddenField = document.getElementById("selected_parcel_type");

//   buttons.forEach(button => {
//     button.addEventListener("click", function() {
//       // Remove active class from all buttons
//       buttons.forEach(btn => btn.classList.remove("active"));
//       // Add active class to the clicked button
//       this.classList.add("active");
//       // Update the hidden field with the selected value
//       hiddenField.value = this.getAttribute("data-value");

//       // Toggle dimension fields based on selected parcel type
//       toggleDimensionFields();
//     });
//   });

//   // Toggle dimension fields visibility
//   const dimensionFields = [
//     document.querySelector('[name="parcel_ad[parcel_length]"]'),
//     document.querySelector('[name="parcel_ad[parcel_width]"]'),
//     document.querySelector('[name="parcel_ad[parcel_height]"]'),
//     document.querySelector('[name="parcel_ad[parcel_weight]"]')
//   ];

//   function toggleDimensionFields() {
//     const isDocument = hiddenField.value === 'Document';
//     dimensionFields.forEach(field => {
//       field.closest('.col-md-2').style.display = isDocument ? 'none' : '';
//       if (isDocument) {
//         field.value = ''; // Clear value if 'Document' type
//       }
//     });
//   }

//   // Initial call to set the correct visibility on page load
//   toggleDimensionFields();

//   // Update the quantity display dynamically
//   const quantityInput = document.getElementById("parcel_quantity");
//   const quantityDisplay = document.getElementById("quantity_display");

//   quantityInput.addEventListener("input", function() {
//     const quantityValue = quantityInput.value || 0;
//     quantityDisplay.textContent = `Quantity: ${quantityValue}`;
//   });

//   // Preview uploaded parcel images
//   const parcelImagesInput = document.getElementById('parcel_images_input');
//   const previewContainer = document.getElementById('parcel_images_preview');

//   parcelImagesInput.addEventListener('change', function(event) {
//     previewContainer.innerHTML = '';
//     const files = event.target.files;

//     if (files.length > 0) {
//       Array.from(files).forEach(file => {
//         const reader = new FileReader();
//         reader.onload = function(e) {
//           const img = document.createElement('img');
//           img.src = e.target.result;
//           img.classList.add('img-thumbnail', 'mr-2', 'mx-2', 'mb-2');
//           img.style.width = '100px';
//           previewContainer.appendChild(img);
//         };
//         reader.readAsDataURL(file);
//       });
//     }
//   });
// });
