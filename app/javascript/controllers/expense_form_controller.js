import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["paidBySelect", "warning"]

  connect() {
    console.log("Expense form controller connected!")
  }

  paidByChanged() {
    const payerId = this.paidBySelectTarget.value

    if (payerId) {
      const payerCheckbox = document.getElementById(`expense_user_ids_${payerId}`)
      if (payerCheckbox) {
        payerCheckbox.checked = true
      }
      this.hideWarning()
    }
  }

  userCheckboxChanged() {
    this.checkPayerWarning()
  }

  checkPayerWarning() {
    const payerId = this.paidBySelectTarget.value

    if (payerId) {
      const payerCheckbox = document.getElementById(`expense_user_ids_${payerId}`)
      if (payerCheckbox && !payerCheckbox.checked) {
        this.showWarning()
      } else {
        this.hideWarning()
      }
    }
  }

  showWarning() {
    this.warningTarget.classList.remove('hidden')
  }

  hideWarning() {
    this.warningTarget.classList.add('hidden')
  }
}