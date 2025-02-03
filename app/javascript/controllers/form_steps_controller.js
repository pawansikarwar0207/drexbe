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

    if (this.hasBackIconTarget) {
      this.backIconTarget.classList.remove("fas", "fa-chevron-left");
      this.backIconTarget.classList.add("fa-solid", "fa-xmark");
    }
  }

  prev(event) {
    event.preventDefault();
    this.step2Target.style.display = "none";
    this.step1Target.style.display = "block";

    if (this.hasBackIconTarget) {
      this.backIconTarget.classList.remove("fa-solid", "fa-xmark");
      this.backIconTarget.classList.add("fas", "fa-chevron-left");
    }
  }

  abandon(event) {
    event.preventDefault();
    console.log("Abandon post clicked");

    let abandonModal = new bootstrap.Modal(document.getElementById("abandonModal"));
    abandonModal.show();
  }

  submit(event) {
    event.preventDefault();

    // Submit the form via AJAX
    fetch(event.target.action, {
      method: event.target.method,
      body: new FormData(event.target),
      headers: {
        "X-Requested-With": "XMLHttpRequest",
      },
    })
    .then((response) => response.json())
    .then((data) => {
        // ✅ Show the Thank You modal after successful submission
      let thankYouModal = new bootstrap.Modal(document.getElementById("thankYouModal"));
      thankYouModal.show();

        // Optional: Reset the form after submission
      event.target.reset();
    })
    .catch((error) => console.error("Error submitting form:", error));
  }
}
