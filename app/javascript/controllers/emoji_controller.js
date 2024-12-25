import { Controller } from "@hotwired/stimulus";
import { EmojiButton } from "@joeattardi/emoji-button";

export default class extends Controller {
  static targets = ["emojiButton", "reactionInput", "emojiPicker"]; // Added emojiPicker target
  static values = { chatRoomId: String, messageId: String }; // Added values for data attributes

  connect() {
    // Initialize the emoji picker instance
    this.picker = new EmojiButton({
      position: "bottom-start",
      emojiVersion: "12.1",
    });

    // Bind emoji picker to the button
    this.picker.on("emoji", (emoji) => this.selectEmoji(emoji));
  }

  togglePicker(event) {
    event.preventDefault();
    this.picker.togglePicker(this.emojiButtonTarget); // Attach picker to the emoji button target
  }

  selectEmoji(emoji) {
    // Set the selected emoji in the hidden input
    this.reactionInputTarget.value = emoji.emoji;

    // Optionally trigger additional logic, such as sending the reaction to the server
    const chatRoomId = this.chatRoomIdValue;
    const messageId = this.messageIdValue;
    this.sendReaction(chatRoomId, messageId, emoji.emoji);
  }

  sendReaction(chatRoomId, messageId, emoji) {
    const url = `/chat_rooms/${chatRoomId}/messages/${messageId}/react`;

    fetch(url, {
      method: "POST",
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
      },
      body: JSON.stringify({ emoji: emoji }),
    })
      .then((response) => response.text())
      .then((html) => Turbo.renderStreamMessage(html))
      .catch((error) => console.error("Error sending reaction:", error));
  }
  copy(event) {
    const content = event.target.dataset.clipboardContent;

    navigator.clipboard.writeText(content).then(() => {
      event.target.innerText = "Copied!";
      setTimeout(() => {
        event.target.innerText = "Copy";
      }, 2000);
    }).catch((err) => {
      console.error("Failed to copy: ", err);
    });
  }
}
