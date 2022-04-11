
$(document).ready(() => {
    $(".container").hide()
    window.addEventListener("message", (event) => {
        let data = event.data 

        if (data.action == "openCBR") {
            $(".container").fadeIn()
            setupCBR()
        }
    })
})



let current_vraag = 0





const setupCBR = () => {
  let id = 0
  $(".mid").html("")
  let element = DATA[current_vraag]
  DATA.forEach(element =>  {
    
    id === 0 ? $(".mid").append(`<div class="current_question active">${id + 1}</div>`) : $(".mid").append(`<div class="current_question">${id + 1}</div>`)
    id++
  });

  $(".antwoorden-container").html("")
  element.antwoorden.forEach((el, index) => {
    $(".antwoorden-container").append(`<div class="antwoord" onclick="selectQuestion(${index})"><div>${el.question}</div></div>`)
  })
}


const selectQuestion = (index) => {
  DATA[current_vraag].antwoorden.forEach(el => {
    el.selected = false
  })

  DATA[current_vraag].antwoorden[index].selected = true

  let element= document.getElementsByClassName("antwoord")

  let current = document.getElementsByClassName("antwoord-select");

  // If there's no active class
  if (current.length > 0) {
    current[0].className = current[0].className.replace("antwoord-select", "");
  }
  element[index].classList.add("antwoord-select")

}






const Next = () => {
    let element = document.getElementsByClassName("current_question")
    let current = document.getElementsByClassName("active");

    // If there's no active class
    if (current.length > 0) {
      current[0].className = current[0].className.replace("active", "");
    }
    current_vraag++

    element[current_vraag] ? element[current_vraag].classList.add("active") : closeUI() 
    element[current_vraag] ? null : current_vraag = 0

    loadQuestion()
}


const closeUI = () => {
  $.post("https://mn-cbr-FiveM/testDone", JSON.stringify(DATA))

  $(".container").hide()

  current_vraag = 0


  DATA.forEach(el => {
    el.antwoorden.forEach(element => {
      element.selected = false
    })
  })
}

const loadQuestion = () => {
  let id = 0
  $(".vragen-header").text(DATA[current_vraag].vraag)
  $("#img").attr("src",DATA[current_vraag].img);
  let element = DATA[current_vraag]
  $(".antwoorden-container").html("")
  element.antwoorden.forEach((el, index) => {
    el.selected ? $(".antwoorden-container").append(`<div class="antwoord antwoord-select" onclick="selectQuestion(${index})"><div>${el.question}</div></div>`) : $(".antwoorden-container").append(`<div class="antwoord" onclick="selectQuestion(${index})"><div>${el.question}</div></div>`) 
  })


  DATA[current_vraag + 1] ? $("#right-btn").text("Volgende") :  $("#right-btn").text("Eindigen")
}


const Previous = () => {
    let element = document.getElementsByClassName("current_question")
    let current = document.getElementsByClassName("active");

    if (current.length > 0) {
      current[0].className = current[0].className.replace("active", "");
    }
    current_vraag--

    element[current_vraag] ? element[current_vraag].classList.add("active") : element[element.length - 1].classList.add("active")
    element[current_vraag] ? null : current_vraag = element.length -1
    loadQuestion()
}

