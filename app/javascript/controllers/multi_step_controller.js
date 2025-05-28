// app/javascript/controllers/multi_step_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["step", "senderDetails", "receiverDetails", "parcelDetails"]

  connect() {
    this.currentStep = 0;
    this.showCurrentStep();
    console.log('multi-step-controller-connected')
  }

  next() {
    if (this.currentStep < this.stepTargets.length - 1) {
      this.currentStep++;
      this.showCurrentStep();
    }
  }

  prev() {
    if (this.currentStep > 0) {
      this.currentStep--;
      this.showCurrentStep();
    }
  }

  showCurrentStep() {
    this.stepTargets.forEach((step, index) => {
      step.classList.toggle("d-none", index !== this.currentStep);
    });
  }

  toggleSenderDetails(event) {
    if (this.hasSenderDetailsTarget) {
      this.senderDetailsTarget.style.display = event.target.checked ? "block" : "none";
    }
  }

  toggleReceiverDetails(event) {
    if (this.hasReceiverDetailsTarget) {
      this.receiverDetailsTarget.style.display = event.target.checked ? "block" : "none";
    }
  }

  toggleParcelDetails(event) {
    if (this.hasParcelDetailsTarget) {
      this.parcelDetailsTarget.style.display = event.target.checked ? "block" : "none";
    }
  }
}
