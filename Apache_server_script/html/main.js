// active

var tablinks = document.getElementsByClassName("tab-links");
var tabcontents = document.getElementsByClassName("tab-contents");

function opentab(tabname){
    for(tablink of tablinks){
        tablink.classList.remove("active-link");
    }
    for(tabcontent of tabcontents){
        tabcontent.classList.remove("active-tab");
    }
    event.currentTarget.classList.add("active-link");
    document.getElementById(tabname).classList.add("active-tab");
}



// mobile menu

var sideMenu = document.getElementById("sidemenu");

function openmenu(){
    sideMenu.style.right = "0";
}
function closemenu(){
    sideMenu.style.right = "-200px";
}


//using selectors inside the element

const questions = document.querySelectorAll('.question');
questions.forEach(function (question) {
    // questions.log(question);
    const btn = question.querySelector(".question-btn");
    // console.log(btn);
    btn.addEventListener("click", function() {

        questions.forEach(function(item) {
            if(item !== question) {
                item.classList.remove("show-text");
            }
        });

        question.classList.toggle("show-text");
    });
});

// Collection of form into google spreadsheet

document.getElementById('form').addEventListener('submit', function (e) {
    e.preventDefault();
    var formData = new FormData(e.target);
  
    fetch(e.target.action, {
      method: 'POST',
      body: JSON.stringify(Object.fromEntries(formData)),
      headers: {
        'Content-Type': 'application/json',
      },
      mode: 'no-cors',
    })
    .then(response => {
        console.log(response);
        window.location.href = 'index.html';
      })
      .catch(error => {
        console.error(error);
        // Handle errors here
      });

  });
  

  // Review section
  let currentReview = 0;

  function showReview(n) {
    const reviews = document.querySelectorAll('.review');
    for (let i = 0; i < reviews.length; i++) {
      reviews[i].style.display = 'none';
    }

    for (let i = n; i < n + 3 && i < reviews.length; i++) {
      reviews[i].style.display = 'block';
    }
  }

  function nextReview() {
    currentReview += 1;
    showReview(currentReview);
  }

  function prevReview() {
    currentReview -= 1;
    showReview(currentReview);
  }

  const reviews = document.querySelectorAll('.review');
  const prevBtn = document.getElementById('prevBtn');
  const nextBtn = document.getElementById('nextBtn');

  // Initially show the first three reviews
  showReview(currentReview);

  // Disable the "Previous" button initially
  prevBtn.disabled = true;

  // Add event listeners for "Previous" and "Next" buttons
  prevBtn.addEventListener('click', () => {
    prevReview();
    nextBtn.disabled = false;
    if (currentReview === 0) {
      prevBtn.disabled = true;
    }
  });

  nextBtn.addEventListener('click', () => {
    nextReview();
    prevBtn.disabled = false;
    if (currentReview + 1 >= reviews.length) {
      nextBtn.disabled = true;
    }
  });