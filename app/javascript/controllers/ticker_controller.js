import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="ticket"
export default class extends Controller {
    static targets = ["tickets"];

    increase() {
        this.updateValue(1);
    }

    decrease() {
        this.updateValue(-1);
    }

    updateValue(change) {
        let currentValue = parseInt(this.ticketsTarget.value, 10) || 0;
        let newValue = Math.max(currentValue + change, 1);
        this.ticketsTarget.value = newValue;
    }
}
