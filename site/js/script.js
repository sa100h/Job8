'use strict';

document.addEventListener("DOMContentLoaded", () => {
    let button_sign_in = document.getElementById('sign-in-button');

    button_sign_in.addEventListener('click', (e) => {
        e.preventDefault();

        window.location.replace('/passenger.html');
    });
});

