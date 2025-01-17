import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["productPrice", "buyForMeFee", "totalPrice"];

  connect() {
    console.log("price_calculator connected")
    this.updateTotalPrice(); // Calculate total price on page load
  }

  updateTotalPrice() {
    const productPrice = parseFloat(this.productPriceTarget.value) || 0;
    const buyForMeFee = parseFloat(this.buyForMeFeeTarget.value) || 0;
    const totalPrice = productPrice + buyForMeFee;

    this.totalPriceTarget.value = totalPrice.toFixed(2);
  }
}
