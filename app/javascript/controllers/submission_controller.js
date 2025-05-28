// controllers/submission_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log('submission-form-connected.')
    this.element.addEventListener("turbo:submit-end", this.handleSubmitEnd)
  }

  disconnect() {
    this.element.removeEventListener("turbo:submit-end", this.handleSubmitEnd)
  }

  handleSubmitEnd = (event) => {
    const { success } = event.detail

    if (success) {
      // ✅ Only show the modal if the submission was successful
      const modal = document.getElementById("thank-you-modal")
      if (modal) {
        modal.classList.remove("hidden") // or modal.showModal() if it's a native <dialog>
      }
    }
  }
}
