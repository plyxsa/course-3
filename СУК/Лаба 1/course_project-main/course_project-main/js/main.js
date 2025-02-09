///////////Меню бургер///////////
$(document).ready(function() {
    $('.header-burger').click(function(event) {
        $('.header-burger,.header-menu').toggleClass('active');
        $('body').toggleClass('lock');
    });
});

////////////Копирование номера телефона///////////

function copyPhone(){
    let copyText = document.getElementById("my-Input");
    copyText.select();
    copyText.setSelectionRange(0, 99999);
    navigator.clipboard.writeText(copyText.value);
    
    let tooltip = document.getElementById("myTooltip");
    tooltip.innerHTML = "Скопирован!";
  }
  
  function outFunc() {
    let tooltip = document.getElementById("myTooltip");
    tooltip.innerHTML = "Скопировать номер телефона";
  }

/////////////Слайдер///////////////

let sliderImages = document.querySelectorAll('.img'); //Доступ к слайдам
//Доступ к кнопкам next и prev
let next = document.querySelector('.next'); 
let prev = document.querySelector('.prev');

var counter = 0;

//Код для кнопки next
next.addEventListener('click', slideNext);
function slideNext() {
  sliderImages[counter].style.animation = 'next1 0.5s ease-in forwards';
  if(counter >= sliderImages.length-1){
    counter = 0;
  }
  else{
    counter++;
  }
  sliderImages[counter].style.animation = 'next2 0.5s ease-in forwards';
}

//Код для кнопки prev
prev.addEventListener('click', slidePrev);
function slidePrev() {
  sliderImages[counter].style.animation = 'prev1 0.5s ease-in forwards';
  if(counter == 0){
    counter = sliderImages.length-1;
  }
  else{
    counter--;
  }
  sliderImages[counter].style.animation = 'prev2 0.5s ease-in forwards';
}

//Автопрокрутка
function autoSliding() {
  deletInterval = setInterval(timer, 4000);
  function timer(){
    slideNext();
  }
}
autoSliding();

//Остановка прокрутки при наведении мыши 
const container = document.querySelector('.slider-container');
container.addEventListener('mouseover', function(){
  clearInterval(deletInterval);
})

//Продолжение прокрутки, когда убран курсор мыши
container.addEventListener('mouseout', autoSliding);


/////////////////////Второй слайдер/////////////////////

const carousel = document.querySelector(".carousel");
let isDragStart = false, isDragging = false, prevPageX, prevScrollLeft, positionDiff;

const dragStart = (e) => {
    // updatating global variables value on mouse down event
    isDragStart = true;
    prevPageX = e.pageX || e.touches[0].pageX;
    prevScrollLeft = carousel.scrollLeft;
}
const dragging = (e) => {
    // scrolling images/carousel to left according to mouse pointer
    if(!isDragStart) return;
    e.preventDefault();
    isDragging = true;
    carousel.classList.add("dragging");
    positionDiff = (e.pageX || e.touches[0].pageX) - prevPageX;
    carousel.scrollLeft = prevScrollLeft - positionDiff;
}
const dragStop = () => {
    isDragStart = false;
    carousel.classList.remove("dragging");
    if(!isDragging) return;
    isDragging = false;
}
carousel.addEventListener("mousedown", dragStart);
carousel.addEventListener("touchstart", dragStart);
document.addEventListener("mousemove", dragging);
carousel.addEventListener("touchmove", dragging);
document.addEventListener("mouseup", dragStop);
carousel.addEventListener("touchend", dragStop);

//////////////////////////////

const productContainers = [...document.querySelectorAll('.product-container')];
const nxtBtn = [...document.querySelectorAll('.nxt-btn')];
const preBtn = [...document.querySelectorAll('.pre-btn')];

productContainers.forEach((item, i) => {
    let containerDimensions = item.getBoundingClientRect();
    let containerWidth = containerDimensions.width;

    nxtBtn[i].addEventListener('click', () => {
        item.scrollLeft += containerWidth;
    })

    preBtn[i].addEventListener('click', () => {
        item.scrollLeft -= containerWidth;
    })
})

///////////////////////////////////

const email = document.querySelector('#email');
const icon1 = document.querySelector('.icon1');
const icon2 = document.querySelector('.icon2');
const error = document.querySelector('.error-text');
const btn = document.querySelector('.button-email');
let regExp = /^[^ ]+@[^ ]+\.[a-z]{2,3}$/;
function check(){
  if(email.value.match(regExp)){
    email.style.borderColor = "#27ae60";
    icon1.style.display = "none";
    icon2.style.display = "block";
    error.style.display = "none";
    btn.style.display = "block";
  }else{
    email.style.borderColor = "#e74c3c";
    icon1.style.display = "block";
    icon2.style.display = "none";
    error.style.display = "block";
    btn.style.display = "none";
  }
  if(email.value == ""){
    email.style.borderColor = "lightgrey";
    icon1.style.display = "none";
    icon2.style.display = "none";
    error.style.display = "none";
    btn.style.display = "none";
  }
}

$(function() {
  $(".button-email").click(function() {
    // validate and process form here
  });
});