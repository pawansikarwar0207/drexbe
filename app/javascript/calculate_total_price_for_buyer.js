document.addEventListener('DOMContentLoaded', function() {
  // Get references to the input fields
  const productPriceField = document.getElementById('product_price');
  const buyForMeFeeField = document.getElementById('buy_for_me_fee');
  const totalPriceField = document.getElementById('total_price');

  // Function to calculate and display the total price
  function updateTotalPrice() {
    const productPrice = parseFloat(productPriceField.value) || 0;
    const buyForMeFee = parseFloat(buyForMeFeeField.value) || 0;
    const totalPrice = productPrice + buyForMeFee;
    totalPriceField.value = totalPrice.toFixed(2);
  }

  // Attach event listeners to recalculate total price on input change
  productPriceField.addEventListener('input', updateTotalPrice);
  buyForMeFeeField.addEventListener('input', updateTotalPrice);
});