import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  show() {
    this.menuTarget.classList.remove("hidden")
  }

  hide() {
    this.menuTarget.classList.add("hidden")
  }
}
