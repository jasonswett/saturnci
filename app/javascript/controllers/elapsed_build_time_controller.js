import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["value"];

  connect() {
    this.valueTarget.textContent = "1234";
  }
}
