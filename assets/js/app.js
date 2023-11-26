// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
let Hooks = {};


Hooks.GreekDatesInput = {
    mounted() {

        this.formatDate(this.el)

        this.el.addEventListener("change", () => {
            
            console.log("change", this.el.id)

            this.formatDate(this.el)
        })

        this.el.addEventListener("beforeinput", (event) => {
            console.log("before", this.el.id)
            
        });
    },

    formatDate(el) {
        console.log(el.id)
        // Get the "data-date-format" attribute value
        const dateFormat = el.getAttribute('data-date-format');
        console.info(moment(el.value, 'YYYY-MM-DD'))
        // Parse the input value using moment.js and format it according to the data-date-format
        const formattedDate = moment(el.value, 'YYYY-MM-DD').format(dateFormat);

        // Set the "data-date" attribute to the formatted date
        el.setAttribute('data-date', formattedDate);

    }

}

Hooks.UpdateLineNumbers = {
    mounted() {
        const lineNumberText = document.querySelector("#line-numbers")

        this.el.addEventListener("input", () => {
            this.updateLineNumbers();
        })

        this.el.addEventListener("scroll", () => {
            lineNumberText.scrollTop = this.el.scrollTop;
        })

        this.handleEvent("clear-textareas", () => {
            this.el.value = "";
            lineNumberText.value = "1\n"
        })
        this.updateLineNumbers();
    },

    updateLineNumbers() {
        const lineNumberText = document.querySelector("#line-numbers")
        if (!lineNumberText) return;
        const lines = this.el.value.split("\n")
        const numbers = lines.map((_, index) => index + 1).join("\n") + "\n"
        lineNumberText.value = numbers;
    }
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken }, hooks: Hooks })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

