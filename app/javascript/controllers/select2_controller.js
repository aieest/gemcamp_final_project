import { Controller } from "@hotwired/stimulus";

import select2 from 'select2';

window.select2 = select2();

export default class extends Controller {
    connect() {
        $('.select2').select2({}).on('select2:select', function () {
            let event = new Event('change', { bubbles: true })
            this.dispatchEvent(event)
        })
    }
}