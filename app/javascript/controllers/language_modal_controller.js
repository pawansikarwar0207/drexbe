import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modal", "languageContent", "currencyContent", "languageTab", "currencyTab"];

  connect() {
    console.log("Language Modal Controller Connected");
  }

  open(event) {
    event.preventDefault();
    this.modalTarget.classList.add("show");
    document.body.style.overflow = "hidden";
  }

  close(event) {
    event.preventDefault();
    this.modalTarget.classList.remove("show");
    document.body.style.overflow = "auto";
  }

  switchTab(event) {
    event.preventDefault();
    const tab = event.target.dataset.tab;

    // Hide both content sections
    this.languageContentTarget.style.display = "none";
    this.currencyContentTarget.style.display = "none";

    // Remove active class from both tabs
    this.languageTabTarget.classList.remove("active");
    this.currencyTabTarget.classList.remove("active");

    // Show the selected content and highlight the tab
    if (tab === "currency") {
      this.currencyContentTarget.style.display = "block";
      this.currencyTabTarget.classList.add("active");
    } else {
      this.languageContentTarget.style.display = "block";
      this.languageTabTarget.classList.add("active");
    }
  }
}
