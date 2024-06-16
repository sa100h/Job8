'use strict';

document.addEventListener("DOMContentLoaded", () => {
    let button_sign_out = document.getElementById('dropdown--item--exit'),
        passenger_category = document.querySelectorAll('select[type-passenger]'),
        button_new_passenger = document.getElementById('button-add-passenger'),
        button_autocomplete = document.getElementById('button-autocomplete'),
		button_delete_user_new = document.getElementById('button-delete-user-new'),
        button_order_filter = document.getElementById('button-order-filter'),
        button_new_order = document.getElementById('button-add-order'),
		button_new_user = document.getElementById('button-add-user'),
		button_send_new_order = document.getElementById('button-send-new-order'),
		button_job_day_filter = document.getElementById('button-job-day-filter'),
        select_hour = document.getElementById('order-hour'),
        select_minute = document.getElementById('order-minute'),
        order_type = document.querySelectorAll('select[order-status]'),
        order_set_employee = document.querySelectorAll('select[order-set-employee]'),
        select_stations = document.querySelectorAll('select[order-station]'),
        order_trace = document.getElementById('order-trace');
    
    let order_station_start = document.querySelectorAll('select[order-station-start]'),
        order_station_end = document.querySelectorAll('select[order-station-end]');
    
    let page_navigator = document.querySelector('ul[page-navigator]'),
        table_passenger = document.querySelector('table[table-passenger]'),
        table_passenger_order = document.querySelector('table[table-passenger-order]'),
        table_order = document.querySelector('table[table-orders]');

    if (table_passenger) {
        table_passenger = table_passenger.querySelector('tbody');
    };

    if (table_passenger_order) {
        table_passenger_order = table_passenger_order.querySelector('tbody');
    };

    if (table_order) {
        table_order = table_order.querySelector('tbody');
    };

    let btn_passenger_to_bd = document.getElementById('btn-passenger-bd');


    let data_table_passenger, data_table_orders;

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

    const postData = async (url, data) => {
		const res = await fetch(url, {
			method: 'POST',
			headers: {
				'Content-type': 'application/json'
			},
			body: data
		});

		return await res.json();
	};

    // Чистим pop-up
    const clearModalPassenger = () => {
        let modal_window = document.getElementById('modal-passenger');
        modal_window.querySelector('#firstName').value = '';
        modal_window.querySelector('#firstName').removeAttribute('pid');    
        modal_window.querySelector('#lastName').value = '';
        modal_window.querySelector('#secondName').value = '';

        modal_window.querySelector('#btnradio_female').checked = false;
        modal_window.querySelector('#btnradio_male').checked = false;
        
        modal_window.querySelector('[aria-label="contact-numbers"]').value = '';
        modal_window.querySelector('[type-passenger]').querySelectorAll('option')[0].selected = true;

        modal_window.querySelector('#btnradio_ecp_yes').checked = false;
        modal_window.querySelector('#btnradio_ecp_no').checked = false;

        modal_window.querySelector('[aria-label="additional-info"]').value = '';
    };

    const getPassengerDataPopUp = () => {
        let modal_window = document.getElementById('modal-passenger');
        // console.log('Get data!')

        let data = {};
        data['id'] = 0;
        data['firstName'] = modal_window.querySelector('#firstName').value;
        data['id'] = +modal_window.querySelector('#firstName').getAttribute('pid');
        data['lastName'] = modal_window.querySelector('#lastName').value;
        data['secondName'] = modal_window.querySelector('#secondName').value;

        if (modal_window.querySelector('#btnradio_male').checked){
            data['sex'] = 1;
        };
        if (modal_window.querySelector('#btnradio_female').checked){
            data['sex'] = 0;
        };

        data['phone'] = modal_window.querySelector('[aria-label="contact-numbers"]').value;

        modal_window.querySelector('[type-passenger]').querySelectorAll('option')
        .forEach(item => {
            if (item.selected) {
                // console.log(item);
                data['type'] = +item.value;
            };
        });

        if (modal_window.querySelector('#btnradio_ecp_yes').checked){
            data['ecs'] = 1;
        };
        if (modal_window.querySelector('#btnradio_ecp_no').checked){
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
            modal_window.querySelector('#firstName').setAttribute('pid', id);

            modal_window.querySelector('#lastName').value = temp[2];
            modal_window.querySelector('#secondName').value = temp[3];
            if (temp[5] == 'М') {
                modal_window.querySelector('#btnradio_male').checked = true;
            } else {
                modal_window.querySelector('#btnradio_female').checked = true;
            };
            modal_window.querySelector('[aria-label="contact-numbers"]').value = temp[4];
            modal_window.querySelector('[type-passenger]').querySelectorAll('option')
            .forEach(item => {
                if (item.text == temp[6]) {
                    item.selected = true;
                };
            });
            if (temp[7] == 'Есть') {
                modal_window.querySelector('#btnradio_ecp_yes').checked = true;
            } else {
                modal_window.querySelector('#btnradio_ecp_no').checked = true;
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

    const fillTablePassengerOrder = (start_ind, end_ind) => {
        table_passenger_order.innerHTML = '';

        for (let i = start_ind; i < Math.min(end_ind, data_table_passenger.length); i++) {
            // console.log(data_table_passenger[i]);

            let temp = document.createElement('tr');
            const ecp_color = data_table_passenger[i][7] === 'Есть' ? 'text-danger' : '';

            temp.innerHTML = `
            <th class="pt-2 pb-2"><input class="form-check-input mt-0" type="radio" value="${data_table_passenger[i][0]}" name="rbutton-passenger"></th>
            <th class="pt-2 pb-2 text-primary font-weight-400" name>${data_table_passenger[i][1]} ${data_table_passenger[i][2]} ${data_table_passenger[i][3]}</th>
            <th class="pt-2 pb-2 w-30 font-weight-400">${data_table_passenger[i][4]}</th>
            <th class="pt-2 pb-2 font-weight-400">${data_table_passenger[i][5]}</th>
            <th class="pt-2 pb-2 font-weight-400">${data_table_passenger[i][6]}</th>
            <th class="pt-2 pb-2 ${ecp_color} font-weight-400">${data_table_passenger[i][7]}</th>
            <th class="pt-2 pb-2 font-weight-400">${data_table_passenger[i][8]}</th>
            `;

            table_passenger_order.append(temp);
        };
    };

    const fillTableOrder = (start_ind, end_ind) => {
        table_order.innerHTML = '';

        for (let i = start_ind; i < Math.min(end_ind, data_table_orders.length); i++) {
            // console.log(data_table_orders[i]);
            let temp = document.createElement('tr');

            temp.innerHTML = `
            <th class="col-1 pt-3 pb-3" id><span class="font-weight-400 text-primary" id>${data_table_orders[i][0]}</span></th>
            <th class="col-2 pt-3 pb-3"><span class="font-weight-400 ">${data_table_orders[i][1]}</span></th>
            <th class="col-3 pt-3 pb-3"><span class="font-weight-400 ">${data_table_orders[i][2]}</span></th>
            <th class="col-2 pt-3 pb-3"><span class="font-weight-400 ">${data_table_orders[i][3] ? data_table_orders[i][3] : ''}</span></th>
            <th class="col-2 pt-3 pb-3"><span class="order-status-pill badge rounded-pill ${data_table_orders[i][5]}">${data_table_orders[i][4]}</span></th>
            `;

            table_order.append(temp);
        };

        table_order.querySelectorAll('span[id]')
        .forEach(item => {
            item.addEventListener('click', (e) => {
                e.preventDefault();
                window.location.replace(`/orders-new-item.html?order_id=${e.target.textContent}`);
            });
        });
    };

    const getOrderData = () => {
        let data = {};

        data['id'] = document.querySelector('li[aria-current="page"]').getAttribute('pid');
        data['status'] = +order_type[0].value;
        document.querySelectorAll('[name="rbutton-passenger"]').forEach(item => {
            if (item.checked) {
                data['passenger_id'] = +item.value;
            };
        });

        data['count_passenger'] = +document.getElementById('order-count-passenger').value;

        document.querySelectorAll('[type-passenger]')[1].querySelectorAll('option')
        .forEach(item => {
            if (item.selected) {
                // console.log(item);
                data['type'] = +item.value;
            };
        });

        data['luggage_type'] = document.getElementById('order-luggage-type').value;
        data['luggage_weight'] = document.getElementById('order-luggage-weight').value;

        if (document.querySelector('#btnradio_help_yes').checked) {
            data['help'] = 1;
        } else {
            data['help'] = 0;
        };

        data['info'] = document.querySelector('[type-passenger]').value;

        data['date'] = document.getElementById('order-date').value;
        data['hour'] = +document.getElementById('order-hour').value;
        data['minute'] = +document.getElementById('order-minute').value;

        data['station_start'] = +document.querySelector('select[order-station-start]').value;
        data['station_end'] = +document.querySelector('select[order-station-end]').value;
        data['evaluate_time'] = +document.getElementById('order-travel-time').value;

        data['place_meeting'] = document.getElementById('order-place-meeting').value;
        data['place_destination'] = document.getElementById('order-place-destination').value;

        data['count_all'] = +document.getElementById('order-count-employee').value;
        data['count_male'] = +document.getElementById('order-count-men').value;
        data['count_female'] = +document.getElementById('order-count-women').value;

        if (document.querySelector('#btnradio_recieve_phone').checked) {
            data['get_order_type'] = 1;
        } else {
            data['get_order_type'] = 0;
        };

        return data;
    };

    const fillOrderById = (order_id) => {
        getResource(`https://и-так-сойдет.рф/api/get_passenger_for_table`)
        .then(data => {
            if (data['passenger']) {
                let data_table_passenger = data['passenger'];
                // console.log(data_table_passenger);

                getResource(`https://и-так-сойдет.рф/api/get_order_by_id?id=${+order_id}`)
                .then(data => {
                    if (data['order_data']) {
                        console.log(data);

                    };

                    document.querySelector('li[aria-current="page"]').textContent = `Заявка #${order_id}`;
                    document.querySelector('li[aria-current="page"]').setAttribute('pid', order_id);


                    for (let index = 0; index < order_type[0].options.length; index++) {
                        if (order_type[0].options[index].text == data['order_data'][1]) {
                            order_type[0].options.selectedIndex = index;
                        };
                    };

                    for (let index = 0; index < data_table_passenger.length; index++) {
                        if (data_table_passenger[index][0] == data['order_data'][2]) {
                            fillTablePassengerOrder(Math.floor(index / 10)*10, (Math.floor(index / 10) + 1)*10);
                        };
                    };

                    document.querySelectorAll('[name="rbutton-passenger"]').forEach(item => {
                        if (item.value == data['order_data'][2]) {
                            item.checked = true;
                        };
                    });

                    document.getElementById('order-count-passenger').value = data['order_data'][3];

                    document.querySelectorAll('[type-passenger]')[1].querySelectorAll('option')
                    .forEach(item => {  
                        if (item.text == data['order_data'][4]) {
                            // console.log(item);
                            item.selected = true;
                        };
                    });

                    document.getElementById('order-luggage-type').value = data['order_data'][5];
                    document.getElementById('order-luggage-weight').value = data['order_data'][6];

                    if (+data['order_data'][7]) {
                        document.querySelector('#btnradio_help_yes').checked = true;
                    } else {
                        document.querySelector('#btnradio_help_no').checked = true;
                    };

                    const date = new Date(data['order_data'][8]);
                    
                    document.getElementById('order-date').valueAsDate = date;
                    document.getElementById('order-hour').querySelectorAll('option')
                    .forEach(item => {  
                        if (item.text == date.getHours().toString().padStart(2, '0')) {
                            item.selected = true;
                        };
                    });

                    document.getElementById('order-minute').querySelectorAll('option')
                    .forEach(item => {  
                        if (item.text == date.getMinutes().toString().padStart(2, '0')) {
                            item.selected = true;
                        };
                    });

                    order_station_start.forEach(item => {
                        item.querySelectorAll('option').forEach(opt => {
                            if (opt.value == +data['order_data'][9]) {
                                opt.selected = true;
                            };
                        });
                    });

                    order_station_end.forEach(item => {
                        item.querySelectorAll('option').forEach(opt => {
                            if (opt.value == +data['order_data'][11]) {
                                opt.selected = true;
                            };
                        });
                    });

                    changeStationPath();

                    document.getElementById('order-place-meeting').value = data['order_data'][10];
                    document.getElementById('order-place-destination').value = data['order_data'][12];
                    // document.getElementById('order-travel-time').value = data['order_data'][12];
                    
                    document.getElementById('order-count-employee').querySelectorAll('option')
                    .forEach(opt => {
                        if (opt.value == +data['order_data'][13]) {
                            opt.selected = true;
                        };
                    });

                    document.getElementById('order-count-men').querySelectorAll('option')
                    .forEach(opt => {
                        if (opt.value == +data['order_data'][14]) {
                            opt.selected = true;
                        };
                    });

                    document.getElementById('order-count-women').querySelectorAll('option')
                    .forEach(opt => {
                        if (opt.value == +data['order_data'][15]) {
                            opt.selected = true;
                        };
                    });

                    getResource(`https://и-так-сойдет.рф/api/get_employee_info`)
                    .then(empl => {
                        if (empl['employee']) {

                            document.querySelector('[employee-passenger]').remove();
                            if (data['order_data'][16]) {
                                for (let index = 0; index < data['order_data'][16].length; index++) {
                                    let temp = document.createElement('div');
                                    temp.className = 'row g-3 pt-3 pb-3';
                                    temp.setAttribute('employee-passenger', '')
                                    
                                    temp.innerHTML = `
                                    <label class="form-label text-body">Сотрудник ${index + 1}</label>
                                    <div class="d-flex m-0" >
                                        <div class="col-4 me-3">
                                            <select class="form-select me-2" order-set-employee></select>
                                        </div>
                                        <button type="button" class="btn btn-outline-danger col-1 col-md-2" button-del-set-employee>
                                            <i class="bi bi-x-lg"></i>
                                            Удалить сотрудника
                                        </button>
                                    </div>
                                    `;

                                    empl['employee'].forEach(element => {
                                        let temp2 = document.createElement('option');
                                        temp2.value = element[0];
                                        temp2.text = element[1];
                                        if (element[0] == data['order_data'][16][index]) {
                                            temp2.selected = true;
                                        };
                    
                                        temp.add(temp2);
                                    });
                                };
                            };
                        };
                    });

                    if (data['order_data'][17] == "Телефон") {
                        document.querySelector('#btnradio_recieve_phone').checked = true;
                    } else {
                        document.querySelector('#btnradio_recieve_email').checked = true;
                    };
                });
            };
        });
        
    };

    const changeStationPath = () => {
        let btn_temp = document.getElementById('btnradio_trace_auto');

        if (btn_temp.checked) {

            const start_station = +order_station_start[0].value,
                end_station = +order_station_end[0].value;

            console.log(`${start_station} -- ${end_station}`);
            if (start_station && end_station) {
                getResource(`https://и-так-сойдет.рф/api/get_path?start_id=${start_station}&end_id=${end_station}`)
                .then(data => {
                    console.log(data);

                    document.querySelectorAll('[station-transite]').forEach(item => item.remove());
                    let div_temp = order_trace.querySelectorAll('div');
                    data['transfer_station'].forEach(val => {
                        let temp = document.createElement('div')
                        temp.className = 'col-sm-4 pe-4 mt-2';
                        temp.setAttribute('station-transite', '')

                        console.log(`${val[0]}">${val[1]}`);
                        temp.innerHTML = `
                        <label class="form-label text-body">Станция пересадки</label>
                        <select class="form-select me-2" required="" order-station disabled>
                            <option value="${val[0]}">${val[1]}</option>
                        </select>
                        `;
                        div_temp[1].before(temp);
                    });

                    div_temp = document.getElementById('order-travel-time');
                    div_temp.value = data['path_time'];
                });
            };
        };
    };

    const clickOnTableNavigator = (event, data_table, func) => {
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
            max_sheet = Math.floor(data_table.length / 10),
            nav_items = page_navigator.querySelectorAll('li');
        // console.log(active_item);
        // console.log(cur_tag);
        // console.log(max_sheet);

        if (cur_tag.parentElement != active_item) {
            switch (cur_tag.parentElement) {
                case nav_items[0]:
                    if (!nav_items[0].classList.contains('disabled')) {
                        cur_page = (+active_item.querySelector('a').text - 1);
                        func((cur_page-1)*10, cur_page*10);

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
                    func(0, 10);

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
                    func((max_sheet - 1)*10, max_sheet*10);

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

                        func((cur_page - 1)*10, cur_page*10);

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
                item.addEventListener('click', (e) => clickOnTableNavigator(e, data_table, func));
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
                    item.addEventListener('click', (e) => clickOnTableNavigator(e, data_table_passenger, fillTablePassenger));
                });
            };
        });
    };

    if (table_passenger_order) {
        getResource(`https://и-так-сойдет.рф/api/get_passenger_for_table`)
        .then(data => {
            if (data['passenger']) {
                data_table_passenger = data['passenger'];
                // console.log(data_table_passenger[0]);
                // console.log(data_table_passenger.length);
                
                fillTablePassengerOrder(0, 10);

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
                    item.addEventListener('click', (e) => clickOnTableNavigator(e, data_table_passenger, fillTablePassengerOrder));
                });
            };
        });
    };

    if (table_order) {
        getResource(`https://и-так-сойдет.рф/api/get_orders_for_table`)
        .then(data => {
            // console.log(data);
            if (data['orders']) {
                data_table_orders = data['orders'];
                // console.log(data_table_orders[0]);
                // console.log(data_table_passenger.length);
                
                fillTableOrder(0, 10);

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
                <li class="page-item"><a class="page-link" href="#">${Math.floor(data_table_orders.length / 10)}</a></li>
                <li class="page-item">
                    <a class="page-link" href="#" aria-label="next">
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </li>
                `;

                page_navigator.querySelectorAll('li').forEach(item => {
                    item.addEventListener('click', (e) => clickOnTableNavigator(e, data_table_orders, fillTableOrder));
                });
            };
        });
    };

    //#endregion fromBD

    //#region toPage Управление элементами на странице
    
    if (button_new_passenger) {
        button_new_passenger.addEventListener('click', () => {
            let modal_new_passenger = new bootstrap.Modal(document.getElementById('modal-passenger'), {keyboard: false});
            if (btn_passenger_to_bd) {
                btn_passenger_to_bd.addEventListener('click', () => {sendPassengerData()});
                btn_passenger_to_bd.addEventListener('click', () => {modal_new_passenger.hide()});
            };
            clearModalPassenger();
            modal_new_passenger.show();
        });
    };

    if (button_send_new_order) {
        button_send_new_order.addEventListener('click', () => {
            sendOrderData();
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

    if (button_autocomplete) {
        button_autocomplete.addEventListener('click', (e) => {
            e.preventDefault();

            getResource(`https://и-так-сойдет.рф/api/orders_autocomplete`)
            .then(data => {
                console.log(data);
            });
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

    if (order_station_start) {
        order_station_start.forEach(item => {
            item.addEventListener('change', (item) => {
                // console.log(item.target);
                order_station_start.forEach(i => {
                    i.value = item.target.value;
                });

                changeStationPath();
            });
        });
    };

    if (order_station_end) {
        order_station_end.forEach(item => {
            item.addEventListener('change', (item) => {
                // console.log(item.target);
                order_station_end.forEach(i => {
                    i.value = item.target.value;
                });

                changeStationPath();
            });
        });
    };


    //#endregion toPage
    
    //#region sendData to BD


    const sendPassengerData = () => {
        let json = JSON.stringify(getPassengerDataPopUp());
        console.log(json);

        postData('https://и-так-сойдет.рф/api/change_passenge_by_id', json)
        .then(data => {
            console.log(data);
        }).catch(() => {
            console.log(message.failure);
            window.alert(message.failure);
        });
    };

    const sendOrderData = () => {
        let json = JSON.stringify(getOrderData());
        console.log(json);

        postData('https://и-так-сойдет.рф/api/change_order_by_id', json)
        .then(data => {
            console.log(data);
            window.location.replace('/orders.html');
        }).catch(() => {
            console.log(message.failure);
            window.alert(message.failure);
        });
    };

    //#endregion SendData

    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);

    if (urlParams.get('order_id')) {
        // console.log(urlParams.get('order_id'));
        fillOrderById(urlParams.get('order_id'));
    };
});