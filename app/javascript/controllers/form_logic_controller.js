import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="form-logic"
export default class extends Controller {
  static targets = [
    "senderDetails", 
    "receiverDetails", 
    "parcelDetails",
    "parcelImagesInput",
    "parcelImagesPreview",
    "proposedFee",
    "recommendedFee",
    "feeComparisonResult"
  ];


  connect() {
    console.log("Connected form-logic:", {
      hasProposedFeeTarget: this.hasProposedFeeTarget,
      hasRecommendedFeeTarget: this.hasRecommendedFeeTarget,
      hasParcelImagesInputTarget: this.hasParcelImagesInputTarget,
    });
    
    this.selectedFiles = [];

    this.toggleSectionByCheckbox("toggleSenderDetails", this.senderDetailsTarget);
    this.toggleSectionByCheckbox("toggleReceiverDetails", this.receiverDetailsTarget);
    this.toggleSectionByCheckbox("toggleParcelDetails", this.parcelDetailsTarget);

    this.proposedFeeTarget.addEventListener("input", this.updateComparison.bind(this));
    this.recommendedFeeTarget.addEventListener("input", this.updateComparison.bind(this));

    this.parcelImagesInputTarget.addEventListener("change", (e) => {
      const files = Array.from(e.target.files);
      this.selectedFiles = [...files];
      this.renderPreviews();
    });
  }

  toggleSectionByCheckbox(checkboxId, section) {
    const checkbox = document.getElementById(checkboxId);
    if (!checkbox || !section) return;

    const toggle = () => {
      section.style.display = checkbox.checked ? "block" : "none";
    };

    checkbox.addEventListener("change", toggle);
    toggle();
  }

  renderPreviews() {
    this.parcelImagesPreviewTarget.innerHTML = "";
    this.selectedFiles.forEach((file, index) => {
      if (!file.type.startsWith("image/")) return;

      const reader = new FileReader();
      reader.onload = (e) => {
        const wrapper = document.createElement("div");
        wrapper.classList.add("position-relative", "d-inline-block", "me-2", "mb-2");

        const img = document.createElement("img");
        img.src = e.target.result;
        img.classList.add("img-thumbnail");
        img.style.width = "100px";

        const removeBtn = document.createElement("span");
        removeBtn.innerHTML = "&times;";
        removeBtn.classList.add("position-absolute", "top-0", "end-0", "bg-secondary", "text-white", "px-1", "rounded-circle");
        removeBtn.style.cursor = "pointer";
        removeBtn.style.transform = "translate(50%, -50%)";
        removeBtn.style.zIndex = "10";
        removeBtn.title = "Remove";

        removeBtn.addEventListener("click", () => {
          this.selectedFiles.splice(index, 1);
          this.updateFileInput();
          this.renderPreviews();
        });

        wrapper.appendChild(img);
        wrapper.appendChild(removeBtn);
        this.parcelImagesPreviewTarget.appendChild(wrapper);
      };
      reader.readAsDataURL(file);
    });
  }

  updateFileInput() {
    const dataTransfer = new DataTransfer();
    this.selectedFiles.forEach(file => dataTransfer.items.add(file));
    this.parcelImagesInputTarget.files = dataTransfer.files;
  }

  updateComparison() {
    const proposed = parseFloat(this.proposedFeeTarget.value);
    const recommended = parseFloat(this.recommendedFeeTarget.value);

    if (isNaN(proposed) || isNaN(recommended)) {
      this.feeComparisonResultTarget.innerHTML = `<p class="text-warning"><strong>Please enter both fees to see a comparison.</strong></p>`;
      return;
    }

    const diff = Math.abs(proposed - recommended).toFixed(2);

    if (proposed > recommended) {
      this.feeComparisonResultTarget.innerHTML = `<p class="text-danger"><strong>Your proposed fee is $${diff} higher than the market fee.</strong></p>`;
    } else if (proposed < recommended) {
      this.feeComparisonResultTarget.innerHTML = `<p class="text-success"><strong>Your proposed fee is $${diff} lower than the market fee.</strong></p>`;
    } else {
      this.feeComparisonResultTarget.innerHTML = `<p class="text-info"><strong>Your proposed fee matches the market fee.</strong></p>`;
    }
  }
}
