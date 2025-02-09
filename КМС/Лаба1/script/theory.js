// Получение ссылок на элементы
const maxwellLink = document.getElementById('maxwell-link');
const maxwellImg = document.getElementById('maxwell-img');

// Отображение изображения при клике на ссылку
maxwellLink.addEventListener('click', function(event) {
    event.preventDefault(); // Предотвращаем переход по ссылке
    maxwellImg.style.display = 'block';
});

// Скрытие изображения при уходе курсора
maxwellImg.addEventListener('click', function() {
    maxwellImg.style.display = 'none';
});


const waveLink = document.getElementById('wave-link');
const waveImg = document.getElementById('wave-img');

waveLink.addEventListener('click', function(event) {
    event.preventDefault(); 
    waveImg.style.display = 'block';
});

waveImg.addEventListener('click', function() {
    waveImg.style.display = 'none';
});

const malusLink = document.getElementById('malus-link');
const malusImg = document.getElementById('malus-img');

malusLink.addEventListener('click', function(event) {
    event.preventDefault(); 
    malusImg.style.display = 'block';
});

malusImg.addEventListener('click', function() {
    malusImg.style.display = 'none';
});