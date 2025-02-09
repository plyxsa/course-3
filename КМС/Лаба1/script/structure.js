 // Получение ссылок на элементы списка и изображения
 const elements = document.querySelectorAll('ul li');
 const images = document.querySelectorAll('#image-display img');

 // Функция для отображения нужного изображения
 function showImage(imageId) {
     // Скрыть все изображения
     images.forEach(img => img.style.display = 'none');
     // Показать выбранное изображение
     document.getElementById(imageId).style.display = 'block';
 }

 // Добавляем события клика на каждый элемент списка
 document.getElementById('element1').addEventListener('click', function() {
     showImage('img1');
 });
 document.getElementById('element2').addEventListener('click', function() {
     showImage('img2');
 });
 document.getElementById('element3').addEventListener('click', function() {
     showImage('img3');
 });
 document.getElementById('element4').addEventListener('click', function() {
     showImage('img4');
 });
 document.getElementById('element5').addEventListener('click', function() {
     showImage('img5');
 });
 document.getElementById('element6').addEventListener('click', function() {
     showImage('img6');
 });
 document.getElementById('element7').addEventListener('click', function() {
     showImage('img7');
 });






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