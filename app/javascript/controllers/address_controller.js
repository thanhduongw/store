import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["province", "district", "ward", "specific"]

  connect() {
    this.loadProvinces()
  }

  async loadProvinces() {
    try {
      const res = await fetch("https://provinces.open-api.vn/api/p/")
      const provinces = await res.json()
      this.populate(this.provinceTarget, provinces, "Chọn Tỉnh/Thành phố")
    } catch {
      console.error("Không tải được danh sách tỉnh thành")
    }
  }

  async provinceChanged() {
    const option = this.provinceTarget.selectedOptions[0]
    const code = option?.dataset?.code

    this.clearSelect(this.districtTarget, "Chọn Quận/Huyện")
    this.clearSelect(this.wardTarget, "Chọn Phường/Xã")
    this.districtTarget.disabled = true
    this.wardTarget.disabled = true

    if (!code) return

    try {
      const res = await fetch(`https://provinces.open-api.vn/api/p/${code}?depth=2`)
      const data = await res.json()
      this.populate(this.districtTarget, data.districts, "Chọn Quận/Huyện")
      this.districtTarget.disabled = false
    } catch {
      console.error("Không tải được danh sách quận huyện")
    }
  }

  async districtChanged() {
    const option = this.districtTarget.selectedOptions[0]
    const code = option?.dataset?.code

    this.clearSelect(this.wardTarget, "Chọn Phường/Xã")
    this.wardTarget.disabled = true

    if (!code) return

    try {
      const res = await fetch(`https://provinces.open-api.vn/api/d/${code}?depth=2`)
      const data = await res.json()
      this.populate(this.wardTarget, data.wards, "Chọn Phường/Xã")
      this.wardTarget.disabled = false
    } catch {
      console.error("Không tải được danh sách phường xã")
    }
  }

  populate(select, items, placeholder) {
    select.innerHTML = `<option value="" data-code="">-- ${placeholder} --</option>`
    items.forEach(item => {
      const opt = document.createElement("option")
      opt.value = item.name
      opt.dataset.code = item.code
      opt.textContent = item.name
      select.appendChild(opt)
    })
  }

  clearSelect(select, placeholder) {
    select.innerHTML = `<option value="" data-code="">-- ${placeholder} --</option>`
  }
}
