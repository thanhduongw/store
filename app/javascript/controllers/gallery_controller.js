import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "thumb", "dot"]

  connect() {
    this.current = 0
  }

  next() {
    this.goToIndex((this.current + 1) % this.slideTargets.length)
  }

  prev() {
    this.goToIndex((this.current - 1 + this.slideTargets.length) % this.slideTargets.length)
  }

  goTo(event) {
    this.goToIndex(parseInt(event.currentTarget.dataset.index))
  }

  goToIndex(index) {
    this.slideTargets.forEach((slide, i) => {
      slide.classList.toggle("hidden", i !== index)
    })

    this.thumbTargets.forEach((thumb, i) => {
      thumb.classList.toggle("border-[#ee4d2d]", i === index)
      thumb.classList.toggle("border-gray-200", i !== index)
    })

    this.dotTargets.forEach((dot, i) => {
      dot.classList.toggle("bg-[#ee4d2d]", i === index)
      dot.classList.toggle("bg-gray-300", i !== index)
    })

    this.current = index
  }
}
