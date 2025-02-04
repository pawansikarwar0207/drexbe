import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

export default class extends Controller {
  connect() {
    console.log("Time picker connected!");

    // Set the placeholder before initializing Flatpickr
    this.element.setAttribute("placeholder", "Select Time");

    flatpickr(this.element, { 
      enableTime: true,
      noCalendar: true,
      dateFormat: "H:i",
      time_24hr: true
    });
  }
}
