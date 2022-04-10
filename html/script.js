
$(document).ready(() => {
    window.addEventListener("message", (event) => {
        let data = event.data 

        if (data.action == "openCBR") {
            
        }
    })
})


let current_vraag = 0




const Next = () => {
    let element = document.getElementsByClassName("current_question")
    let current = document.getElementsByClassName("active");

    // If there's no active class
    if (current.length > 0) {
      current[0].className = current[0].className.replace("active", "");
    }
    current_vraag++
    console.log(current_vraag)

    element[current_vraag] ? element[current_vraag].classList.add("active") : element[0].classList.add("active")
    element[current_vraag] ? null : current_vraag = 0
}

const Previous = () => {
    let element = document.getElementsByClassName("current_question")
    let current = document.getElementsByClassName("active");

    // If there's no active class
    if (current.length > 0) {
      current[0].className = current[0].className.replace("active", "");
    }
    current_vraag--
    console.log(current_vraag)

    element[current_vraag] ? element[current_vraag].classList.add("active") : element[14].classList.add("active")
    element[current_vraag] ? null : current_vraag = element.length -1
}