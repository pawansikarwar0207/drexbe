import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["step1", "step2", "backIcon"];

  connect() {
    console.log("FormStepsController connected");
  }

  next(event) {
    event.preventDefault();
    this.step1Target.style.display = "none";
    this.step2Target.style.display = "block";

    // Change back arrow to cross icon and enable modal
    this.backIconTarget.innerHTML = '<i class="fas fa-times"></i>';
    this.backIconTarget.setAttribute("data-bs-toggle", "modal");
    this.backIconTarget.setAttribute("data-bs-target", "#abandonModal");
  }

  prev(event) {
    event.preventDefault();
    this.step1Target.style.display = "block";
    this.step2Target.style.display = "none";

    // Change cross icon back to arrow
    this.backIconTarget.innerHTML = '<i class="fas fa-chevron-left"></i>';
    this.backIconTarget.removeAttribute("data-bs-toggle");
    this.backIconTarget.removeAttribute("data-bs-target");
  }

  abandon() {
    window.location.href = "/";
  }
}
