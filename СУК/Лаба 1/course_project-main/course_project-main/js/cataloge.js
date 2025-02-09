
let cartIcon = document.querySelector('.cart')
let cart = document.querySelector('.cart-inside')
let closeCart = document.querySelector('.btn-close')

cartIcon.onclick = () => {
    cart.classList.add("active");
};

closeCart.onclick = () => {
    cart.classList.remove("active");
};

/////

if (document.readyState == 'loading'){
    document.addEventListener('DOMContentLoaded', ready());
} else{
    ready();
}

////Убрать предмет из корзины
function ready(){
    var removeCartButtons = document.getElementsByClassName('cart-remove');
    for (var i = 0; i < removeCartButtons.length; i++){
        var button = removeCartButtons[i]
        button.addEventListener('click', removeCartItem);
    }
    var quantityInputs = document.getElementsByClassName('cart-quantity');
    for (var i = 0; i < quantityInputs.length; i++){
        var input = quantityInputs[i];
        input.addEventListener('change', quantityChanged);
    }
    //Добавление в корзину
    var addCart = document.getElementsByClassName('add-cart');
    for (var i = 0; i < addCart.length; i++){
        var button = addCart[i]
        button.addEventListener('click', addCartClicked);
    }
    //Покупка
    document.getElementsByClassName('btn-buy')[0].addEventListener('click', BuyButtonClicked);
}

function BuyButtonClicked(){
    alert('Заказ оставлен')
    var cartContent = document.getElementsByClassName('cart-content')[0]
    while (cartContent.hasChildNodes()){
        cartContent.removeChild(cartContent.firstChild);
    }
    updateTotal();
}

function removeCartItem(event){
    var buttonClicked = event.target;
    buttonClicked.parentElement.remove();
    updateTotal();
}
//Количество изменилось
function quantityChanged(event){
    var input = event.target
    if (isNaN(input.value) || input.value <= 1) {
        input.value = 1;
    }
    updateTotal();
}

//Добавление в корзину
function addCartClicked(event){
    var button = event.target;
    var shopProducts = button.parentElement;
    var title = shopProducts.getElementsByClassName('product-title')[0].innerHTML;
    var price = shopProducts.getElementsByClassName('price')[0].innerHTML;
    var productImg = shopProducts.getElementsByClassName('product-image')[0].src;
    addProductToCart(title, price, productImg);
    updateTotal();
}



function addProductToCart(title, price, productImg){ 
    var cartShopBox = document.createElement('div');
    var cartItems = document.getElementsByClassName('cart-content')[0];
    cartShopBox.classList.add('cart-box');
    var cartItemsNames = cartItems.getElementsByClassName('cart-product-title');
    for (var i = 0; i < cartItemsNames.length; i++){
        if(cartItemsNames[i].innerHTML == title){
            alert("Товар уже добавлен");
            return;
        }
        
    }
    var cartBoxContent = `
                                    <img src="${productImg}" alt="" class="cart-image">
                                    <div class="detail-box">
                                        <div class="cart-product-title">${title}</div>
                                        <div class="cart-price">${price}</div>
                                        <input type="number" value="1" class="cart-quantity">
                                    </div>
                                    <i class="cart-remove">Убрать</i>   
`
cartShopBox.innerHTML = cartBoxContent;
cartItems.append(cartShopBox);
cartShopBox
    .getElementsByClassName('cart-remove')[0]
    .addEventListener('click', removeCartItem);
cartShopBox
    .getElementsByClassName('cart-quantity')[0]
    .addEventListener('change', quantityChanged);
}


//Обновление 
function updateTotal(){
    var cartContent = document.getElementsByClassName('cart-content')[0];
    var cartBoxes = cartContent.getElementsByClassName('cart-box');
    var total = 0;
    for(var i = 0; i < cartBoxes.length; i++){
        var cartBox = cartBoxes[i];
        var priceElement = cartBox.getElementsByClassName('cart-price')[0];
        var quantityElement = cartBox.getElementsByClassName('cart-quantity')[0];
        var price = parseFloat(priceElement.innerHTML.replace('р',''));
        var quantity = quantityElement.value;
        total = total + (price * (quantity / 100));
    }
        total = Math.round(total * 100) / 100;
        document.getElementsByClassName('total-price')[0].innerHTML = total + "р";   
        document.getElementsByClassName('in-cart')[0].innerHTML = cartBoxes.length;   
}