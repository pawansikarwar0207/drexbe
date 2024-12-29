import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { url: String };
  static targets = ["userList", "userItem"]; // Add a target for user list

  connect() {
    // this.loadFirstUserChat(); // Automatically load the first user's chat
  }

  reset() {
  	event.target.reset();
  }

  send(event) {
    event.preventDefault();
    const urlValue = event.currentTarget.dataset.turboStreamUrlValue;
    this.loadTurboStream(urlValue);
    this.handelActiveUser();
  }

  // loadFirstUserChat() {
  //   const firstUserLink = this.element.querySelector("a"); // Get the first user link
  //   if (firstUserLink) {
  //     const turboUrl = firstUserLink.dataset.turboStreamUrlValue;
  //     this.loadTurboStream(turboUrl);
  //     this.handelActiveUser(firstUserLink);
  //   }
  // }

  showActiveUser() {
  	const activeButton = event.currentTarget;
  	this.handelActiveUser(activeButton);
  }

  handelActiveUser(button) {
    this.userItemTargets.forEach(element => {
    	element.classList.remove('active');
    });
    button.classList.add('active');
  }

  loadTurboStream(url) {
    fetch(url, {
      method: "GET",
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
      },
    })
      .then((response) => {
        if (!response.ok) throw new Error("Network response was not ok");
        return response.text();
      })
      .then((html) => Turbo.renderStreamMessage(html))
      .catch((error) => console.error("Error:", error));
  }
}
