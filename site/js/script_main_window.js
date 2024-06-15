'use strict';

document.addEventListener("DOMContentLoaded", () => {
    let button_sign_out = document.getElementById('dropdown--item--exit'),
        passenger_category = document.querySelectorAll('select[type-passenger]'),
        button_new_passenger = document.getElementById('button-add-passenger'),
		button_delete_user_new = document.getElementById('button-delete-user-new'),
        button_order_filter = document.getElementById('button-order-filter'),
        button_new_order = document.getElementById('button-add-order'),
		button_new_user = document.getElementById('button-add-user'),
		button_job_day_filter = document.getElementById('button-job-day-filter'),
        select_hour = document.getElementById('order-hour'),
        select_minute = document.getElementById('order-minute'),
        order_type = document.querySelectorAll('select[order-status]'),
        order_set_employee = document.querySelectorAll('select[order-set-employee]'),
        select_stations = document.querySelectorAll('select[order-station]');
    
    let page_navigator = document.querySelector('ul[page-navigator]'),
        table_passenger = document.querySelector('table[table-passenger]');

    if (table_passenger) {
        table_passenger = table_passenger.querySelector('tbody')
    };

    let btn_passenger_to_bd = document.getElementById('btn-passenger-bd');


    let data_table_passenger;

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

    // Чистим pop-up
    const clearModalPassenger = () => {
        let modal_window = document.getElementById('modal-passenger');
        modal_window.querySelector('#firstName').value = '';
        modal_window.querySelector('#lastName').value = '';
        modal_window.querySelector('#secondName').value = '';

        if (modal_window.querySelector('#btnradio_male').getAttribute('checked') === ''){
            modal_window.querySelector('#btnradio_male').removeAttribute('checked');
        };
        if (modal_window.querySelector('#btnradio_female').getAttribute('checked') === ''){
            modal_window.querySelector('#btnradio_female').removeAttribute('checked');
        };
        modal_window.querySelector('[aria-label="contact-numbers"]').value = '';
        modal_window.querySelector('[type-passenger]').querySelectorAll('option')[0].setAttribute('selected', '');

        if (modal_window.querySelector('#btnradio_ecp_yes').getAttribute('checked') === ''){
            modal_window.querySelector('#btnradio_ecp_yes').removeAttribute('checked');
        };
        if (modal_window.querySelector('#btnradio_ecp_no').getAttribute('checked') === ''){
            modal_window.querySelector('#btnradio_ecp_no').removeAttribute('checked');
        };

        modal_window.querySelector('[aria-label="additional-info"]').value = '';
    };

    const getPassengerDataPopUp = () => {
        let modal_window = document.getElementById('modal-passenger');
        // console.log('Get data!')

        let data = {};
        data['firstName'] = modal_window.querySelector('#firstName').value;
        data['lastName'] = modal_window.querySelector('#lastName').value;
        data['secondName'] = modal_window.querySelector('#secondName').value;

        if (modal_window.querySelector('#btnradio_male').getAttribute('checked') === ''){
            data['sex'] = 1;
        };
        if (modal_window.querySelector('#btnradio_female').getAttribute('checked') === ''){
            data['sex'] = 0;
        };

        data['phone'] = modal_window.querySelector('[aria-label="contact-numbers"]').value;
        data['type'] = modal_window.querySelector('[type-passenger]').value;

        if (modal_window.querySelector('#btnradio_ecp_yes').getAttribute('checked') === ''){
            data['ecs'] = 1;
        };
        if (modal_window.querySelector('#btnradio_ecp_no').getAttribute('checked') === ''){
            data['ecs'] = 0;
        };

        data['info'] = modal_window.querySelector('[aria-label="additional-info"]').value;
        return data;
    };

    // Наполняем pop-up по ID
    const fillModalPassenger = (id) => {
        const temp = data_table_passenger[Object.keys(data_table_passenger).find(k => data_table_passenger[k][0] == id)];

        if (temp) {
            let modal_window = document.getElementById('modal-passenger');
            clearModalPassenger();
            // console.log(modal_window);
            // console.log(temp);
    
            modal_window.querySelector('#firstName').value = temp[1];
            modal_window.querySelector('#lastName').value = temp[2];
            modal_window.querySelector('#secondName').value = temp[3];
            if (temp[5] == 'М') {
                modal_window.querySelector('#btnradio_male').setAttribute('checked', '')
            } else {
                modal_window.querySelector('#btnradio_female').setAttribute('checked', '')
            };
            modal_window.querySelector('[aria-label="contact-numbers"]').value = temp[4];
            modal_window.querySelector('[type-passenger]').querySelectorAll('option')
            .forEach(item => {
                if (item.text == temp[6]) {
                    item.setAttribute('selected', '');
                    // console.log(item);
                };
            });
            if (temp[7] == 'Есть') {
                modal_window.querySelector('#btnradio_ecp_yes').setAttribute('checked', '')
            } else {
                modal_window.querySelector('#btnradio_ecp_no').setAttribute('checked', '')
            };
            modal_window.querySelector('[aria-label="additional-info"]').value = temp[8];

            return true;
        } else {
            return false;
        };
    };

    const fillTablePassenger = (start_ind, end_ind) => {
        table_passenger.innerHTML = '';

        for (let i = start_ind; i < Math.min(end_ind, data_table_passenger.length); i++) {
            // console.log(data_table_passenger[i]);

            let temp = document.createElement('tr');
            const ecp_color = data_table_passenger[i][7] === 'Есть' ? 'text-danger' : '';

            temp.innerHTML = `
            <th class="pt-2 pb-2 text-primary font-weight-400" name>${data_table_passenger[i][1]} ${data_table_passenger[i][2]} ${data_table_passenger[i][3]}</th>
            <th class="pt-2 pb-2 w-30 font-weight-400">${data_table_passenger[i][4]}</th>
            <th class="pt-2 pb-2 font-weight-400">${data_table_passenger[i][5]}</th>
            <th class="pt-2 pb-2 font-weight-400">${data_table_passenger[i][6]}</th>
            <th class="pt-2 pb-2 ${ecp_color} font-weight-400">${data_table_passenger[i][7]}</th>
            <th class="pt-2 pb-2 font-weight-400">${data_table_passenger[i][8]}</th>
            <th class="pt-2 pb-2 text-primary font-weight-400" passenger-id=${data_table_passenger[i][0]} name>
                <a class="nav-link sidebar-disable" href="#">
                    <i class="bi bi-pencil-fill"></i>
                    Изменить
                </a>
            </th>
            `;

            table_passenger.append(temp);
        };
        
        table_passenger.querySelectorAll('th[passenger-id]')
        .forEach(item => {
            item.addEventListener('click', (e) => {
                e.preventDefault();
                // console.log(e);

                let modal_new_passenger = new bootstrap.Modal(document.getElementById('modal-passenger'), {keyboard: false});
                let res = fillModalPassenger(e.target.parentElement.getAttribute('passenger-id'));
                if (res) {
                    if (btn_passenger_to_bd) {
                        btn_passenger_to_bd.addEventListener('click', () => {sendPassengerData()});
                        btn_passenger_to_bd.addEventListener('click', () => {modal_new_passenger.hide()});
                    };
                    modal_new_passenger.show();
                }
            });
        });
    };

    const clickOnTableNavigator = (event) => {
        event.preventDefault();
        // console.log(event);
        
        let cur_tag, cur_page;

        switch (event.target.tagName) {
            case 'A':
                cur_tag = event.target;
                break;
            case 'I':
                cur_tag = event.target.parentElement;
                break;
            default:
                cur_tag = event.target.querySelector('a');
                break;
        }

        const active_item = page_navigator.querySelector('li.active'),
            max_sheet = Math.floor(data_table_passenger.length / 10),
            nav_items = page_navigator.querySelectorAll('li');
        // console.log(active_item);
        // console.log(cur_tag);
        // console.log(max_sheet);

        if (cur_tag.parentElement != active_item) {
            switch (cur_tag.parentElement) {
                case nav_items[0]:
                    if (!nav_items[0].classList.contains('disabled')) {
                        cur_page = (+active_item.querySelector('a').text - 1);
                        // console.log(`${data_table_passenger.length}: ${cur_page}`);
                        fillTablePassenger((cur_page-1)*10, cur_page*10);

                        if (cur_page === 1) {
                            page_navigator.innerHTML = `
                            <li class="page-item disabled">
                                <a class="page-link" href="#" aria-label="prev">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">
                                    <i class="bi bi-three-dots"></i>
                                </a>
                            </li>
                            <li class="page-item"><a class="page-link" href="#">${max_sheet}</a></li>
                            <li class="page-item">
                                <a class="page-link" href="#" aria-label="next">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                            `;
                        } else {
                            page_navigator.innerHTML = `
                            <li class="page-item">
                                <a class="page-link" href="#" aria-label="prev">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                            <li class="page-item"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">
                                    <i class="bi bi-three-dots"></i>
                                </a>
                            </li>
                            <li class="page-item active"><a class="page-link" href="#">${cur_page}</a></li>
                            <li class="page-item"><a class="page-link" href="#">
                                    <i class="bi bi-three-dots"></i>
                                </a>
                            </li>
                            <li class="page-item"><a class="page-link" href="#">${max_sheet}</a></li>
                            <li class="page-item">
                                <a class="page-link" href="#" aria-label="next">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                            `;
                        };
                    };
                    break;
                case nav_items[1]:
                    fillTablePassenger(0, 10);

                    page_navigator.innerHTML = `
                    <li class="page-item disabled">
                        <a class="page-link" href="#" aria-label="prev">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>
                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">
                            <i class="bi bi-three-dots"></i>
                        </a>
                    </li>
                    <li class="page-item"><a class="page-link" href="#">${max_sheet}</a></li>
                    <li class="page-item">
                        <a class="page-link" href="#" aria-label="next">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                    `;
                    break;
                case nav_items[nav_items.length-2]:
                    // console.log(`${data_table_passenger.length}: ${max_sheet}`);
                    fillTablePassenger((max_sheet - 1)*10, max_sheet*10);

                    page_navigator.innerHTML = `
                    <li class="page-item ">
                        <a class="page-link" href="#" aria-label="prev">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>
                    <li class="page-item"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">
                            <i class="bi bi-three-dots"></i>
                        </a>
                    </li>
                    <li class="page-item active"><a class="page-link" href="#">${max_sheet}</a></li>
                    <li class="page-item disabled">
                        <a class="page-link" href="#" aria-label="next">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                    `;
                    break;
                case nav_items[nav_items.length-1]:
                    if (!nav_items[nav_items.length-1].classList.contains('disabled')){
                        cur_page = (+active_item.querySelector('a').text + 1);
                        // console.log(`${data_table_passenger.length}: ${cur_page}`);

                        fillTablePassenger((cur_page - 1)*10, cur_page*10);

                        if (cur_page === max_sheet) {
                            page_navigator.innerHTML = `
                            <li class="page-item ">
                                <a class="page-link" href="#" aria-label="prev">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                            <li class="page-item"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">
                                    <i class="bi bi-three-dots"></i>
                                </a>
                            </li>
                            <li class="page-item active"><a class="page-link" href="#">${max_sheet}</a></li>
                            <li class="page-item disabled">
                                <a class="page-link" href="#" aria-label="next">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                            `;
                        } else {
                            page_navigator.innerHTML = `
                            <li class="page-item">
                                <a class="page-link" href="#" aria-label="prev">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                            <li class="page-item"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">
                                    <i class="bi bi-three-dots"></i>
                                </a>
                            </li>
                            <li class="page-item active"><a class="page-link" href="#">${cur_page}</a></li>
                            <li class="page-item"><a class="page-link" href="#">
                                    <i class="bi bi-three-dots"></i>
                                </a>
                            </li>
                            <li class="page-item"><a class="page-link" href="#">${max_sheet}</a></li>
                            <li class="page-item">
                                <a class="page-link" href="#" aria-label="next">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                            `;
                        };
                    };
                    break;
                default:
                    break;
            };

            page_navigator.querySelectorAll('li').forEach(item => {
                item.addEventListener('click', (e) => clickOnTableNavigator(e));
            });
        };
    };

    //#region fromBD

    if (passenger_category) {
        getResource(`https://и-так-сойдет.рф/api/get_passenger_types`)
        .then(data => {
            if (data['passenger_types']) {
                // console.log(data);
                    passenger_category.forEach(item => {
                        data['passenger_types'].forEach(element => {
                            let temp = document.createElement('option');
                            temp.value = element[0];
                            temp.text = element[1];
        
                            item.add(temp);
                        });
                    });
                };
            });
    };

    if (order_type) {
        getResource(`https://и-так-сойдет.рф/api/get_order_status`)
        .then(data => {
            if (data['order_status']) {
                // console.log(data);
                    order_type.forEach(item => {
                        data['order_status'].forEach(element => {
                            let temp = document.createElement('option');
                            temp.value = element[0];
                            temp.text = element[1];
        
                            item.add(temp);
                        });
                    });
                };
            });
    };
    
    if (select_stations) {
        getResource(`https://и-так-сойдет.рф/api/get_stations`)
        .then(data => {
            if (data['stations']) {
                // console.log(data);
                select_stations.forEach(item => {
                    data['stations'].forEach(element => {
                        let temp = document.createElement('option');
                        temp.value = element[0];
                        temp.text = element[1];
    
                        item.add(temp);
                    });
                });
            };
        });
    };

    if (order_set_employee) {
        getResource(`https://и-так-сойдет.рф/api/get_employee_info`)
        .then(data => {
            if (data['employee']) {
                // console.log(data);
                order_set_employee.forEach(item => {
                    data['employee'].forEach(element => {
                        let temp = document.createElement('option');
                        temp.value = element[0];
                        temp.text = element[1];
    
                        item.add(temp);
                    });
                });
            };
        });
    };

    // Наполнение таблицы пассажиров
    if (table_passenger) {
        getResource(`https://и-так-сойдет.рф/api/get_passenger_for_table`)
        .then(data => {
            if (data['passenger']) {
                data_table_passenger = data['passenger'];
                // console.log(data_table_passenger[0]);
                // console.log(data_table_passenger.length);
                
                fillTablePassenger(0, 10);

                page_navigator.innerHTML = `
                <li class="page-item disabled">
                    <a class="page-link" href="#" aria-label="prev">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                </li>
                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                <li class="page-item"><a class="page-link" href="#">
                        <i class="bi bi-three-dots"></i>
                    </a>
                </li>
                <li class="page-item"><a class="page-link" href="#">${Math.floor(data_table_passenger.length / 10)}</a></li>
                <li class="page-item">
                    <a class="page-link" href="#" aria-label="next">
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </li>
                `;

                page_navigator.querySelectorAll('li').forEach(item => {
                    item.addEventListener('click', (e) => clickOnTableNavigator(e));
                });
            };
        });
    };

    //#endregion fromBD

    //#region toPage Управление элементами на странице
    
    if (button_new_passenger) {
        button_new_passenger.addEventListener('click', () => {
            let modal_new_passenger = new bootstrap.Modal(document.getElementById('modal-passenger'), {keyboard: false});
            clearModalPassenger();
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
    };

    if (button_new_order) {
        button_new_order.addEventListener('click', (e) => {
            e.preventDefault();
            window.location.replace('/orders-new-item.html');
        });
    };

    if (button_new_user) {
		button_new_user.addEventListener('click', (e) => {
			e.preventDefault()
			window.location.replace('/user-new.html')
		});
	};
    if (button_job_day_filter) {
		button_job_day_filter.addEventListener('click', (e) => {
			e.preventDefault()
			window.location.replace('/job-day-filter.html')
		});
	};

    if (button_delete_user_new) {
			button_delete_user_new.addEventListener('click', () => {
				let modal_new_passenger = new bootstrap.Modal(
					document.getElementById('modal-delete-user-new'),
					{ keyboard: false }
				)
				modal_new_passenger.show()
			});
	};


    //#endregion toPage
    
    //#region sendData to BD


    const sendPassengerData = () => {
        let ttt = getPassengerDataPopUp();
    };

    //#endregion SendData
});