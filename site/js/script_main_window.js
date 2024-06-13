'use strict';

document.addEventListener("DOMContentLoaded", () => {
    let button_sign_out = document.getElementById('dropdown--item--exit'),
        passenger_category = document.querySelectorAll('select[type-passenger]'),
        button_new_passenger = document.getElementById('button-add-passenger'),
        button_order_filter = document.getElementById('button-order-filter'),
        button_new_order = document.getElementById('button-add-order'),
        select_hour = document.getElementById('order-hour'),
        select_minute = document.getElementById('order-minute'),
        order_type = document.querySelectorAll('select[order-status]'),
        order_set_employee = document.querySelectorAll('select[order-set-employee]'),
        select_stations = document.querySelectorAll('select[order-station]');
        // modal_passenger = document.getElementById('modal-passenger');
    
    if (button_sign_out) {
        button_sign_out.addEventListener('click', (e) => {
            e.preventDefault();
            window.location.replace('/index.html');
        });
    };

    if (button_new_order) {
        button_new_order.addEventListener('click', (e) => {
            e.preventDefault();
            window.location.replace('/orders-new-item.html');
        });
    };

    const getResource = async (url) => {
        const res = await fetch(url, {});

        if (!res.ok) {
            throw new Error(`Could not fetch ${url}, status: ${res.status}`);
        }

        return await res.json();
    };

    getResource(`https://176.109.105.12:3123/get_passenger_types`)
    .then(data => {
        if (data['passenger_types']) {
            // console.log(data);
            if (passenger_category) {
                passenger_category.forEach(item => {
                    data['passenger_types'].forEach(element => {
                        let temp = document.createElement('option');
                        temp.value = element[0];
                        temp.text = element[1];
    
                        item.add(temp);
                    });
                });
            };
        };
    });

    getResource(`http://176.109.105.12:3123/get_order_status`)
    .then(data => {
        if (data['order_status']) {
            // console.log(data);
            if (order_type) {
                order_type.forEach(item => {
                    data['order_status'].forEach(element => {
                        let temp = document.createElement('option');
                        temp.value = element[0];
                        temp.text = element[1];
    
                        item.add(temp);
                    });
                });
            };
        };
    });

    getResource(`http://176.109.105.12:3123/get_stations`)
    .then(data => {
        if (data['stations']) {
            // console.log(data);
            if (select_stations) {
                select_stations.forEach(item => {
                    data['stations'].forEach(element => {
                        let temp = document.createElement('option');
                        temp.value = element[0];
                        temp.text = element[1];
    
                        item.add(temp);
                    });
                });
            };
        };
    });

    getResource(`http://176.109.105.12:3123/get_employee_info`)
    .then(data => {
        if (data['employee']) {
            // console.log(data);
            if (order_set_employee) {
                order_set_employee.forEach(item => {
                    data['employee'].forEach(element => {
                        let temp = document.createElement('option');
                        temp.value = element[0];
                        temp.text = element[1];
    
                        item.add(temp);
                    });
                });
            };
        };
    });
    
    if (button_new_passenger) {
        button_new_passenger.addEventListener('click', () => {
            let modal_new_passenger = new bootstrap.Modal(document.getElementById('modal-passenger'), {keyboard: false});
            modal_new_passenger.show();
        });
    };

    if (button_order_filter) {
        button_order_filter.addEventListener('click', () => {
            let modal_order_filter = new bootstrap.Modal(document.getElementById('modal-order-filter'), {keyboard: false});
            modal_order_filter.show();
        });
    };

    if (select_hour) {
        for (let step = 0; step < 24; step++) {
            let temp = document.createElement('option');
            temp.value = step;
            temp.text = step.toString().padStart(2, '0');

            select_hour.add(temp);
          };
    };

    if (select_minute) {
        for (let step = 0; step < 60; step+=5) {
            let temp = document.createElement('option');
            temp.value = step;
            temp.text = step.toString().padStart(2, '0');

            select_minute.add(temp);
          }
    }
    
});