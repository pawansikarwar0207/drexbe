document.addEventListener("DOMContentLoaded", () => {
  const starRatingElement = document.getElementById("star-rating");
  const hiddenRatingInput = document.getElementById("rating-value");

  if (starRatingElement) {
    const maxStars = 5;
    const initialRating = parseInt(starRatingElement.dataset.rating, 10);

    for (let i = 1; i <= maxStars; i++) {
      const star = document.createElement("span");
      star.classList.add("star");
      star.textContent = "★";
      star.dataset.value = i;

      if (i <= initialRating) {
        star.classList.add("selected");
      }

      star.addEventListener("click", () => {
        updateStars(i);
        hiddenRatingInput.value = i; // Update the hidden input value
      });

      starRatingElement.appendChild(star);
    }

    const updateStars = (rating) => {
      const stars = starRatingElement.querySelectorAll(".star");
      stars.forEach((star) => {
        star.classList.toggle("selected", parseInt(star.dataset.value, 10) <= rating);
      });
    };
  }
});