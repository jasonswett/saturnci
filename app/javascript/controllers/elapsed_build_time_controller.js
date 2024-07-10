import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["value"];

  connect() {
    if (!this.hasValueTarget) {
      return;
    }

    this.valueTarget.textContent = "1234";
  }
}
