create database hackathon;
set sql_safe_updates = 0;

use hackathon;

create table movies(
	movie_id			varchar(5)			primary key,
    title				varchar(100)		not null unique,
    duration			int 				not null,
    category			varchar(50)			not null
);

create table showtimes(
	show_id				varchar(5)			primary key,
    movie_id			varchar(5)			not null,
    room_name			varchar(50)			not null,
    start_time			datetime			not null,
    ticket_price		decimal(10,2)		not null,
    
    constraint fk_tx_movie
    foreign key (movie_id) references movies(movie_id),
    
    constraint chk_tx_price
    check (ticket_price > 0)
);

create table customers(
	customer_id			varchar(5)			primary key,
    full_name			varchar(100)		not null,
    email				varchar(100)		not null unique,
    phone				varchar(15)			not null unique
);

create table tickets(
	ticket_id			int 				primary key auto_increment,
    show_id				varchar(5)			not null,
    customer_id			varchar(5)			not null,
    seat_number			varchar(10)			not null,
    `status`			varchar(20)			not null,
    
    constraint fk_tx_show
    foreign key (show_id) references showtimes(show_id),
    
    constraint fk_tx_customer
    foreign key (customer_id) references customers(customer_id),
    
    constraint chk_tx_status
    check (`status` in ('Booked', 'Cancelled')),
    
    constraint chk_tx_unique
    unique (show_id, seat_number)
);

-- chen du lieu
insert into movies (movie_id, title, duration, category)
values
	('M01', 'Avatar 2', 190, 'Hành Động'),
	('M02', 'Joker', 120, 'Tâm Lý'),
	('M03', 'Toy Story 4', 100, 'Hoạt Hình'),
	('M04', 'Interstellar', 169, 'Khoa Học');
    
insert into showtimes (show_id, movie_id, room_name, start_time, ticket_price)
values
	('S01', 'M01', 'Cinema 01', '2025-10-01 19:00:00', '120000'),
	('S02', 'M02', 'Cinema 02', '2025-10-01 20:00:00', '90000'),
	('S03', 'M03', 'Cinema 01', '2025-10-02 09:00:00', '80000'),
	('S04', 'M04', 'Cinema 03', '2025-10-02 14:00:00', '150000');
    
insert into customers (customer_id, full_name, email, phone)
values
	('C01', 'Nguyễn Văn An', 'an.nv@gmail.com', '0911111111'),
	('C02', 'Nguyễn Thị Mai', 'mai.nt@gmail.com', '0922222222'),
	('C03', 'Trần Quang Hải', 'hai.tq@gmail.com', '0933333333');
    
insert into tickets (ticket_id, show_id, customer_id, seat_number, `status`)
values
	('1', 'S01', 'C01', 'A01', 'Booked'),
	('2', 'S02', 'C02', 'B05', 'Booked'),
	('3', 'S01', 'C03', 'A02', 'Cancelled'),
	('4', 'S04', 'C01', 'C10', 'Booked'),
	('5', 'S03', 'C02', 'D01', 'Booked');
    
-- Suất chiếu 'S01' đang rất hot, hãy tăng giá vé (ticket_price) lên 10%.
update showtimes
set ticket_price = ticket_price * 1.1
where show_id = 'S01';

-- Cập nhật số điện thoại của khách hàng 'Nguyễn Văn An' thành '0988888888'.
update customers
set phone = '0988888888'
where full_name = 'Nguyễn Văn An';

-- Xóa tất cả các vé trong bảng Tickets có trạng thái là 'Cancelled'.
delete from tickets
where `status` = 'Cancelled';

-- Phan II
-- Liệt kê danh sách các phim có thời lượng (duration) trên 120 phút..
select
	movie_id			as 'Mã Phim',
    title				as 'Tên Phim',
    duration			as 'Thời Lượng',
    category			as 'Danh Mục'
from movies
where duration > 120;

-- Lấy thông tin full_name, email của những khách hàng có tên chứa từ khóa 'Mai'.
select 
	full_name			as 'Tên Khách Hàng',
    email				as 'Email'
from customers
where full_name like '%Mai%';

-- Hiển thị danh sách các suất chiếu gồm show_id, room_name, start_time, sắp xếp theo start_time giảm dần.
select
	show_id				as 'Mã Chiếu',
    room_name			as 'Phòng',
    start_time			as 'Thời Gian Bắt Đầu'
from showtimes
order by start_time desc;

-- Lấy ra 3 suất chiếu có giá vé (ticket_price) cao nhất trong rạp.
select
	show_id				as 'Mã Chiếu',
    room_name			as 'Phòng',
    start_time			as 'Thời Gian Bắt Đầu',
    ticket_price		as 'Giá Vé'
from showtimes
order by ticket_price desc
limit 3;

-- Hiển thị title, duration từ bảng Movies, bỏ qua 1 phim đầu tiên và lấy 2 phim tiếp theo.
select
    title				as 'Tên Phim',
    duration			as 'Thời Lượng'
from movies
limit 2
offset 1;

-- Phan III
-- Hiển thị danh sách gồm: ticket_id, full_name (khách hàng), title (phim) và seat_number. Chỉ lấy các vé có trạng thái 'Booked'.
select
	t.ticket_id			as 'Mã Vé',
    c.full_name			as 'Tên Khách Hàng',
    m.title				as 'Tên Phim',
    t.seat_number		as 'Chỗ Ngồi'
from tickets t
join customers c on t.customer_id = c.customer_id
join showtimes s on s.show_id = t.show_id
join movies m on s.movie_id = m.movie_id
where t.`status` = 'Booked';

-- Liệt kê tất cả các Phim (Movies) và start_time tương ứng của phim đó. Hiển thị cả những phim chưa có suất chiếu nào .
select
	m.movie_id			as 'Mã Phim',
    m.title 			as 'Tên Phim',
    m.duration			as 'Thời Lượng',
    m.category			as 'Danh Mục',
    s.start_time		as 'Thời Gian Bắt Đầu'
from movies m
left join showtimes s on s.movie_id = m.movie_id;

-- Tính tổng số vé đã bán theo từng trạng thái (status). Kết quả gồm: status và Total_Tickets 
select 
	`status` 			as 'Trạng Thái',
    count(show_id)		as 'Tổng Số Vé Đã Bán'
from tickets
group by `status`;

-- Thống kê số lượng vé mà mỗi khách hàng đã đặt. Chỉ hiển thị full_name của những khách hàng đã đặt từ 2 vé trở lên
select
	c.full_name				as 'Tên Khách Hàng',
    count(t.customer_id)	as 'Số Lượng Vé Đã Đặt'
from tickets t
join customers c on t.customer_id = c.customer_id
group by c.full_name
having count(t.customer_id) >= 2;

-- Lấy thông tin các suất chiếu (show_id, room_name, ticket_price) có giá vé thấp hơn giá vé trung bình của tất cả các suất chiếu.
select
	show_id				as 'Mã Chiếu',
    room_name			as 'Tên Phòng',
    ticket_price		as 'Giá Vé'
from showtimes 
where ticket_price < (select avg(ticket_price) from showtimes)
group by show_id, room_name, ticket_price;

-- Hiển thị full_name và phone của những khách hàng đã từng mua vé xem phim 'Avatar 2'.
select
	c.full_name			as 'Tên Khách Hàng',
    c.phone 				as 'Số Điện Thoại'
from customers c
join tickets t on c.customer_id = t.customer_id
join showtimes s on t.show_id = s.show_id
where s.movie_id = 'M01'
group by c.full_name, c.phone;