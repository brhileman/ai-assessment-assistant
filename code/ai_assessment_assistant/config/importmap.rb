# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Flowbite for UI components
pin "flowbite", to: "https://cdn.jsdelivr.net/npm/flowbite@2.3.0/dist/flowbite.min.js"
