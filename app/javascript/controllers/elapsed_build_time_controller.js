import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["value"];

  connect() {
    if (!this.hasValueTarget) {
      return;
    }

    setInterval(() => {
      this.valueTarget.textContent = this.elapsedTime();
    }, 1000);
  }

  elapsedTime() {
    return new Date().toLocaleTimeString();
  }
}
