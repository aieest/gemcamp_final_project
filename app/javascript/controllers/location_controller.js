import { Controller } from "@hotwired/stimulus"

function setInitialDefaultValue(name, target) {
    let option = document.createElement('option')
    option.value = ""
    option.text = `Please select ${name}`
    target.appendChild(option)
    console.log("sdasdferf")
}

// Connects to data-controller="location"
export default class extends Controller {
    static targets = ['selectedRegionId', 'selectedProvinceId', 'selectedCityId', 'selectedBarangayId']
    fetchProvinces() {

        let provinceTarget = this.selectedProvinceIdTarget
        $(provinceTarget).empty()

        $.ajax({
            type: 'GET',
            url: `/api/v1/regions/${this.selectedRegionIdTarget.value}/provinces`,
            dataType: 'json',
            success: (response) => {
                console.log(response)
                setInitialDefaultValue('province', provinceTarget)
                $.each(response, function (index, record) {
                    let option = document.createElement('option')
                    option.value = record.id
                    option.text = record.name
                    provinceTarget.appendChild(option)
                })
            }
        })
    }

    fetchCities() {
        let cityTarget = this.selectedCityIdTarget
        $(cityTarget).empty()

        $.ajax({
            type: 'GET',
            url: `/api/v1/provinces/${this.selectedProvinceIdTarget.value}/cities`,
            dataType: 'json',
            success: (response) => {
                console.log(response)
                setInitialDefaultValue('city', cityTarget)
                $.each(response, function (index, record) {
                    let option = document.createElement('option')
                    option.value = record.id
                    option.text = record.name
                    cityTarget.appendChild(option)
                })
            }
        })
    }

    fetchBarangays() {
        let barangayTarget = this.selectedBarangayIdTarget
        $(barangayTarget).empty()

        $.ajax({
            type: 'GET',
            url: `/api/v1/cities/${this.selectedCityIdTarget.value}/barangays`,
            dataType: 'json',
            success: (response) => {
                console.log(response)
                setInitialDefaultValue('barangay', barangayTarget)
                $.each(response, function (index, record) {
                    let option = document.createElement('option')
                    option.value = record.id
                    option.text = record.name
                    barangayTarget.appendChild(option)
                })
            }
        })
    }
}