import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["link"];

  makeActive(event) {
    console.log(this.linkTargets);
    this.linkTargets.forEach(link => {
      console.log(link);
      link.classList.remove("active");
    });

    event.currentTarget.classList.add("active");
  }
}
