import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["value"];
  static values = { buildCreatedAtDatetime: String };

  connect() {
    if (!this.hasValueTarget) {
      return;
    }

    console.log(this.buildCreatedAtDatetimeValue);

    setInterval(() => {
      this.valueTarget.textContent = this.elapsedTime();
    }, 1000);
  }

  elapsedTime() {
    return new Date().toLocaleTimeString();
  }
}
