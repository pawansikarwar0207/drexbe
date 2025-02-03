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

    // ✅ Change icon to 'fa-xmark' when on Step 2
    if (this.hasBackIconTarget) {
      this.backIconTarget.classList.remove("fas", "fa-chevron-left");
      this.backIconTarget.classList.add("fa-solid", "fa-xmark");
    }
  }

  prev(event) {
    event.preventDefault();
    this.step2Target.style.display = "none";
    this.step1Target.style.display = "block";

    // ✅ Change back to 'fa-chevron-left' when returning to Step 1
    if (this.hasBackIconTarget) {
      this.backIconTarget.classList.remove("fa-solid", "fa-xmark");
      this.backIconTarget.classList.add("fas", "fa-chevron-left");
    }
  }

  abandon(event) {
    event.preventDefault();
    console.log("Abandon post clicked");

    // ✅ Show abandon confirmation modal when clicking 'xmark'
    let abandonModal = new bootstrap.Modal(document.getElementById('abandonModal'));
    abandonModal.show();
  }
}
