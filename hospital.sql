/* Задача 1. Составить общее текстовое описание БД и решаемых ею задач */

-- База данных больницы. Человек может в ней быть пациентом или сотрудником. 
-- Пациенты записываются на прием и могут оставаться в стационаре. У всего имеется своя стоимость.
-- У сотрудника есть должность, у медицинского персонала имеется мед. сертификат по каждой специальности. В данной базе мы будем отслеживать его время действия (5 лет).
-- В стационаре есть срок пребывания, разный вид палат и питания. 

/* Задача 2-3. Скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами) */

-- Создаем базу данных больницы
DROP DATABASE IF EXISTS hospital;
CREATE DATABASE hospital;
USE hospital;

-- Таблица "Человек"
DROP TABLE IF EXISTS persons;
CREATE TABLE persons (
	id SERIAL PRIMARY KEY, -- ID
	surname VARCHAR(100), -- Фамилия
    firstname VARCHAR(100), -- Имя
    patronymic VARCHAR(100), -- Отчество
    birthday DATE, -- Дата рождения
    gender CHAR(1), -- Пол
    city VARCHAR(100), -- Город проживания
    street VARCHAR(100), -- Улица
    house VARCHAR(100), -- Дом
    phone BIGINT, -- Телефон
    email VARCHAR(100) UNIQUE, -- E-mail
    created_at DATETIME DEFAULT NOW(),
    is_deleted bit default 0
);

-- Таблица "Персонал больницы"
DROP TABLE IF EXISTS staff;
CREATE TABLE staff (
	staff_id SERIAL PRIMARY KEY, -- ID
    employment DATE, -- Дата трудоустройства
	salary BIGINT, -- Зарплата (руб. в месяц)
	dismissal bit default 0, -- Увольнение
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (staff_id) REFERENCES persons(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Справочник "Специальности"
DROP TABLE IF EXISTS specialty;
CREATE TABLE specialty(
	id SERIAL PRIMARY KEY, -- ID
    name VARCHAR(255), -- Название специальности
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Справочник "Должности"
DROP TABLE IF EXISTS positions;
CREATE TABLE positions(
	id SERIAL PRIMARY KEY, -- ID
    name VARCHAR(255), -- Название должности
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Таблица "Медицинский персонал"
DROP TABLE IF EXISTS medical_staff;
CREATE TABLE medical_staff (
	medical_staff_id BIGINT UNSIGNED NOT NULL, -- ID
	medical_staff_position BIGINT UNSIGNED NOT NULL, -- Должность
	medical_staff_specialty BIGINT UNSIGNED NOT NULL, -- Специальность
	date_sertificate DATE, -- Дата получения (обновления) медицинского сертификата
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE NOW(),
    PRIMARY KEY (medical_staff_id, medical_staff_position),
    FOREIGN KEY (medical_staff_id) REFERENCES persons(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (medical_staff_position) REFERENCES positions(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (medical_staff_specialty) REFERENCES specialty(id) ON UPDATE CASCADE ON DELETE CASCADE  
);

-- Таблица "Не медицинский персонал"
DROP TABLE IF EXISTS administrative_staff;
CREATE TABLE administrative_staff (
	administrative_staff_id BIGINT UNSIGNED NOT NULL,
	administrative_staff_position BIGINT UNSIGNED NOT NULL, -- Должность
	administrative_staff_specialty BIGINT UNSIGNED NOT NULL, -- Специальность
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE NOW(),
    PRIMARY KEY (administrative_staff_id, administrative_staff_position),
    FOREIGN KEY (administrative_staff_id) REFERENCES persons(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (administrative_staff_position) REFERENCES positions(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (administrative_staff_specialty) REFERENCES specialty(id) ON UPDATE CASCADE ON DELETE CASCADE    
);

-- Таблица "Прием врача"
DROP TABLE IF EXISTS appointment;
CREATE TABLE appointment (
	id SERIAL PRIMARY KEY, -- ID 
	patient_id BIGINT UNSIGNED NOT NULL, -- Пациент
    disease VARCHAR(100), -- Заболевание
	date_appointment DATETIME, -- Дата и время приема
	doctor_id BIGINT UNSIGNED NOT NULL, -- Доктор
	cost_appointment BIGINT, -- Стоимость приема
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE NOW(),
    FOREIGN KEY (patient_id) REFERENCES persons(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES medical_staff(medical_staff_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Таблица "Палаты"
DROP TABLE IF EXISTS chambers;
CREATE TABLE chambers(
	id SERIAL PRIMARY KEY, -- ID (№ палаты)
    quantity_beds INT, -- Количество кроватей в палате
    cost_chamber BIGINT, -- Стоимость в сутки
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Таблица "Питание"
DROP TABLE IF EXISTS food;
CREATE TABLE food(
	id SERIAL PRIMARY KEY, -- ID 
    category_food VARCHAR(100), -- Категория питания (веганское, эконом и пр.)
    cost_food BIGINT, -- Стоимость в сутки
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Таблица "Стационар"
DROP TABLE IF EXISTS stationary;
CREATE TABLE stationary (
	id SERIAL PRIMARY KEY, -- ID 
	patient_id BIGINT UNSIGNED NOT NULL, -- Пациент
    date_stationary DATETIME, -- Дата и время заселения
    date_stationary_end DATETIME, -- Дата и время выписки
	chamber_id BIGINT UNSIGNED NOT NULL, -- Палата
	food_id BIGINT UNSIGNED NOT NULL, -- Питание
    FOREIGN KEY (patient_id) REFERENCES persons(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (chamber_id) REFERENCES chambers(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (food_id) REFERENCES food(id) ON UPDATE CASCADE ON DELETE CASCADE
);

/* Задача 4. Создать ERDiagram для БД */
-- К  архиву с проектом прикреплен дополнительно файл из MySQL Workbench - ERDiagram.mwb


/* Задача 5. Cкрипты наполнения БД данными */

INSERT INTO `persons` VALUES 
(1,'Иванов','Петр','Михайлович','1988-01-25','м','Москва','Люблинская','165а',9686338804,'nellie.rutherford@example.net','2000-11-02 09:37:11','\0'),
(2,'Сидорова','Надежда','Сергеевна','1970-12-24','ж','Иваново','Куконковых','100',9978095612,'amari.grimes@example.org','2000-07-22 21:42:46','\0'),
(3,'Петрова','Елизавета','Александровна','1990-02-02','ж','Саратов','Петровская','16',9726590411,'harber.kaela@example.net','2005-05-12 14:12:10','\0'),
(4,'Фролов','Андрей','Эдуардович','1994-03-27','м','Москва','Ленинградская','22',9853454847,'everette.morissette@example.com','2020-05-02 01:14:18','\0'),
(5,'Щербакова','Юлия','Витальевна','1989-02-24','ж','Тюмень','Новочеркасская','12',9703170332,'hans.jacobson@example.org','2000-10-27 22:42:48','\0'),
(6,'Скворцов','Андрей','Владимирович','1974-07-31','м','Москва','Воронина','5',9003772651,'augustine52@example.org','2000-06-27 11:26:46','\0'),
(7,'Воронин','Вячеслав','Олегович','1999-11-08','м','Никологоры','Симовская','156',9584808419,'qfriesen@example.com','2002-09-20 21:10:03','\0'),
(8,'Самойлова','Елена','Игоревна','1965-06-24','ж','Астрахань','Гайнулина','53',9436673927,'vita57@example.net','2008-08-05 18:38:42','\0'),
(9,'Шумейко','Леонид','Алексеевич','2001-02-01','м','Москва','Вучетича','8',9059539682,'tkulas@example.net','2000-01-12 05:37:47','\0'),
(10,'Иванова','Екатерина','Романовна','1979-01-09','ж','Москва','Вигова','2',9793228664,'fisher.aletha@example.org','2004-03-14 09:54:40','\0'),
(11,'Силуянов','Георгий','Викторович','1975-12-21','м','Москва','Люблинская','55',9512062452,'daniel.vidal@example.org','2000-04-08 18:20:42','\0'),
(12,'Восканян','Паргев','Арамович','1991-10-29','м','Шуя','Ленина','13',9015802883,'julianne.gutmann@example.com','2000-09-14 23:53:30','\0'),
(13,'Мельникова','Мария','Андреевна','1994-08-15','ж','Нижний Новгород','Верховая','6г',9497056754,'abernathy.frederick@example.net','2020-02-23 20:05:56','\0'),
(14,'Торопов','Сергей','Сергеевич','1976-06-27','м','Москва','Люблинская','33',9020128191,'mavis09@example.net','2000-12-02 04:39:40','\0'),
(15,'Палий','Дмитрий','Владиславович','1980-09-05','м','Владимир','Орехова','5',9431665249,'mozelle40@example.org','2000-03-13 17:02:31','\0'),
(16,'Овсянникова','Светлана','Павловна','1984-02-15','ж','Красноярск','Дзержинского','3а',9951084200,'cornelius71@example.com','2000-06-28 09:20:26','\0'),
(17,'Блохин','Артем','Сергеевич','1980-08-05','м','Москва','Люблинская','17',9110798906,'okuhlman@example.org','2000-09-20 07:26:10','\0'),
(18,'Конов','Григорий','Ильич','1972-01-12','м','Краснодар','Летик','44',9762687298,'nolan.george@example.com','2000-08-24 13:43:56','\0'),
(19,'Михедов','Николай','Александрович','1990-10-24','м','Москва','Звездный бульвар','10',9219683846,'kevon57@example.org','2000-11-04 16:45:36','\0'),
(20,'Егоров','Александр','Петрович','1980-04-12','м','Сочи','Вилова','15',9462959320,'schroeder.sigmund@example.org','2000-09-21 10:52:22','\0');
    
INSERT INTO `staff` VALUES 
(1,'2000-01-25',60000,'\0','2000-11-02 09:37:11'),
(2,'2001-03-01',70000,'\0','2000-07-22 21:42:46'),
(3,'2002-05-13',150000,'\0','2005-05-12 14:12:10'),
(4,'2000-02-05',80000,'\0','2020-05-02 01:14:18'),
(5,'2000-07-01',30000,'\0','2000-10-27 22:42:48'),
(6,'2001-06-25',50000,'\0','2000-06-27 11:26:46'),
(7,'2003-08-14',60000,'\0','2002-09-20 21:10:03'),
(8,'2010-11-10',100000,'\0','2008-08-05 18:38:42'),
(9,'2001-02-11',80000,'\0','2000-01-12 05:37:47'),
(10,'2000-03-05',35000,'\0','2004-03-14 09:54:40');

INSERT INTO `specialty` VALUES 
(1,'травматология и ортопедия','2000-11-02 09:37:11','2000-11-02 09:37:11'),
(2,'организация здравоохранения и общественное здоровье','2000-10-27 22:42:48','2000-10-27 22:42:48'),
(3,'офтальмология','2005-05-12 14:12:10','2005-05-12 14:12:10'),
(4,'иммунология','2020-05-02 01:14:18','2020-05-02 01:14:18'),
(5,'сестринское дело','2000-10-27 22:42:48','2000-10-27 22:42:48'),
(6,'экономика и управление','2000-06-27 11:26:46','2000-06-27 11:26:46'),
(7,'инженерные системы и сети','2002-09-20 21:10:03','2002-09-20 21:10:03'),
(8,'терапия','2008-08-05 18:38:42','2008-08-05 18:38:42'),
(9,'урология','2000-01-12 05:37:47','2000-01-12 05:37:47'),
(10,'дерматовенерология','2004-03-14 09:54:40','2004-03-14 09:54:40'),
(11,'акушерство и гинекология','2004-03-14 09:54:40','2004-03-14 09:54:40'), 
(12,'анестезиология-реаниматология','2020-05-02 01:14:18','2020-05-02 01:14:18'),
(13,'рентгенология','2004-03-14 09:54:40','2004-03-14 09:54:40'),
(14,'бактериология','2000-10-27 22:42:48','2000-10-27 22:42:48'),
(15,'эпидемиология','2020-05-02 01:14:18','2020-05-02 01:14:18'),
(16,'гастроэнтерология','2000-10-27 22:42:48','2000-10-27 22:42:48'),
(17,'кардиология','2004-03-14 09:54:40','2004-03-14 09:54:40'),
(18,'онкология','2000-10-27 22:42:48','2000-10-27 22:42:48'),
(19,'диетология','2020-05-02 01:14:18','2020-05-02 01:14:18'),
(20,'неврология','2000-10-27 22:42:48','2000-10-27 22:42:48');

INSERT INTO `positions` VALUES 
(1,'врач-травматолог','2000-11-02 09:37:11','2000-11-02 09:37:11'),
(2,'главный врач','2000-07-22 21:42:46','2000-07-22 21:42:46'),
(3,'врач-офтальмолог','2005-05-12 14:12:10','2005-05-12 14:12:10'),
(4,'врач-иммунолог','2020-05-02 01:14:18','2020-05-02 01:14:18'),
(5,'медицинская сестра','2000-10-27 22:42:48','2000-10-27 22:42:48'),
(6,'администратор','2000-06-27 11:26:46','2000-06-27 11:26:46'),
(7,'санитар','2002-09-20 21:10:03','2002-09-20 21:10:03'),
(8,'врач-терапевт','2008-08-05 18:38:42','2008-08-05 18:38:42'),
(9,'врач-уролог','2000-01-12 05:37:47','2000-01-12 05:37:47'),
(10,'врач-вирусолог','2004-03-14 09:54:40','2004-03-14 09:54:40'),
(11,'врач-акушер-гинеколог','2004-03-14 09:54:40','2004-03-14 09:54:40'), 
(12,'врач-анестезиолог-реаниматолог','2020-05-02 01:14:18','2020-05-02 01:14:18'),
(13,'врач-рентгенолог','2004-03-14 09:54:40','2004-03-14 09:54:40'),
(14,'врач-бактериолог','2000-10-27 22:42:48','2000-10-27 22:42:48'),
(15,'помощник врача эпидемиолога','2020-05-02 01:14:18','2020-05-02 01:14:18'),
(16,'врач-гастроэнтеролог','2000-10-27 22:42:48','2000-10-27 22:42:48'),
(17,'врач-кардиолог','2004-03-14 09:54:40','2004-03-14 09:54:40'),
(18,'врач-онколог','2000-10-27 22:42:48','2000-10-27 22:42:48'),
(19,'медициская сестра диетическая','2020-05-02 01:14:18','2020-05-02 01:14:18'),
(20,'врач-невролог','2000-10-27 22:42:48','2000-10-27 22:42:48');

INSERT INTO `medical_staff` VALUES 
(1,1,1,'2016-11-02','2000-11-02 09:37:11','2016-11-02 09:37:11'),
(2,2,2,'2017-07-22','2000-07-22 21:42:46','2017-07-22 21:42:46'),
(3,3,3,'2015-05-12','2005-05-12 14:12:10','2015-05-12 14:12:10'),
(4,4,4,'2018-05-02','2020-05-02 01:14:18','2018-05-02 01:14:18'),
(5,5,5,'2019-10-27','2000-10-27 22:42:48','2019-10-27 22:42:48'),
(8,8,8,'2014-08-05','2008-08-05 18:38:42','2016-08-05 18:38:42'),
(2,9,9,'2017-01-12','2000-01-12 05:37:47','2017-01-12 05:37:47'),
(10,10,10,'2018-03-14','2004-03-14 09:54:40','2018-03-14 09:54:40');

INSERT INTO `administrative_staff` VALUES 
(6,6,6,'2000-06-27 11:26:46','2000-06-27 11:26:46'),
(7,7,7,'2002-09-20 21:10:03','2002-09-20 21:10:03');

INSERT INTO `appointment` values
(1,11,'перелом ноги','2021-01-25 10:30:00',1,5000,'2021-01-14 11:25:48','2021-01-24 10:30:15'),
(2,12,'головные боли','2021-01-25 10:30:00',2,5000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(3,13,'плохое зрение','2021-01-25 11:30:00',3,5000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(4,14,'сыпь','2021-01-25 11:30:00',4,5000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(5,15,'повышенная температура','2021-01-25 10:30:00',5,5000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(6,16,'затруднение дыхания','2021-01-25 11:30:00',1,5000,'2021-01-14 12:25:48','2021-01-25 10:30:15'),
(7,17,'перелом ноги','2021-01-25 11:30:00',2,5000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(8,18,'головная боль','2021-01-25 12:30:00',3,5000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(9,19,'боль в животе','2021-01-25 12:30:00',4,5000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(10,20,'геморрой','2021-01-25 11:30:00',5,5000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(11,6,'перелом ноги','2021-01-25 15:30:00',10,2000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(12,7,'вывих','2021-01-25 10:30:00',10,2000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(13,11,'выпадение волос','2020-01-25 12:30:00',1,3000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(14,12,'искривление позвоночника','2021-01-25 12:30:00',2,3000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(15,13,'боль в желудке','2021-01-25 13:30:00',3,3000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(16,14,'резкая боль в руке','2021-01-25 13:30:00',4,3000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(17,15,'перелом ноги','2021-01-25 12:30:00',5,3000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(18,16,'головная боль','2021-01-25 11:30:00',10,3000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(19,17,'повышенная температура','2021-01-25 12:30:00',10,3000,'2021-01-14 11:25:48','2021-01-25 10:30:15'),
(20,18,'температура','2021-01-25 13:30:00',10,3000,'2021-01-14 11:25:48','2021-01-25 10:30:15');

INSERT INTO `chambers` values
(1,4,1000,'2000-11-02 09:37:11','2000-11-02 09:37:11'),
(2,4,1000,'2000-10-27 22:42:48','2000-10-27 22:42:48'),
(3,4,1000,'2005-05-12 14:12:10','2005-05-12 14:12:10'),
(4,4,1000,'2020-05-02 01:14:18','2020-05-02 01:14:18'),
(5,4,1000,'2000-10-27 22:42:48','2000-10-27 22:42:48'),
(6,3,2000,'2000-06-27 11:26:46','2000-06-27 11:26:46'),
(7,3,2000,'2002-09-20 21:10:03','2002-09-20 21:10:03'),
(8,3,2000,'2008-08-05 18:38:42','2008-08-05 18:38:42'),
(9,3,2000,'2000-01-12 05:37:47','2000-01-12 05:37:47'),
(10,3,2000,'2004-03-14 09:54:40','2004-03-14 09:54:40'),
(11,2,4000,'2004-03-14 09:54:40','2004-03-14 09:54:40'), 
(12,2,4000,'2020-05-02 01:14:18','2020-05-02 01:14:18'),
(13,2,4000,'2004-03-14 09:54:40','2004-03-14 09:54:40'),
(14,2,4000,'2000-10-27 22:42:48','2000-10-27 22:42:48'),
(15,2,4000,'2020-05-02 01:14:18','2020-05-02 01:14:18'),
(16,1,10000,'2000-10-27 22:42:48','2000-10-27 22:42:48'),
(17,1,10000,'2004-03-14 09:54:40','2004-03-14 09:54:40'),
(18,1,10000,'2000-10-27 22:42:48','2000-10-27 22:42:48'),
(19,1,10000,'2020-05-02 01:14:18','2020-05-02 01:14:18'),
(20,1,10000,'2000-10-27 22:42:48','2000-10-27 22:42:48');

INSERT INTO `food` values
(1,'эконом',300,'2000-11-02 09:37:11','2000-11-02 09:37:11'),
(2,'стандарт',500,'2000-10-27 22:42:48','2000-10-27 22:42:48'),
(3,'люкс',1500,'2005-05-12 14:12:10','2005-05-12 14:12:10'),
(4,'веганское',600,'2020-05-02 01:14:18','2020-05-02 01:14:18'),
(5,'халяльное',600,'2000-10-27 22:42:48','2000-10-27 22:42:48'),
(6,'диетическое',500,'2000-06-27 11:26:46','2000-06-27 11:26:46'),
(7,'постное',300,'2002-09-20 21:10:03','2002-09-20 21:10:03'),
(8,'мусульманское',1000,'2008-08-05 18:38:42','2008-08-05 18:38:42'),
(9,'хинду',800,'2000-01-12 05:37:47','2000-01-12 05:37:47'),
(10,'кошерное',800,'2004-03-14 09:54:40','2004-03-14 09:54:40');

INSERT INTO `stationary` values
(1,11,'2000-11-02 09:37:11','2000-11-13 09:37:11',1,1),
(2,12,'2000-11-02 09:37:11','2000-11-13 09:37:11',2,2),
(3,13,'2000-11-02 09:37:11','2000-11-13 09:37:11',3,3),
(4,14,'2000-11-02 09:37:11','2000-11-13 09:37:11',4,4),
(5,15,'2000-11-02 09:37:11','2000-11-13 09:37:11',6,5),
(6,16,'2000-11-02 09:37:11','2000-11-13 09:37:11',6,6),
(7,17,'2000-11-02 09:37:11','2000-11-13 09:37:11',11,7),
(8,18,'2000-11-02 09:37:11','2000-11-13 09:37:11',11,1),
(9,19,'2000-11-02 09:37:11','2000-11-13 09:37:11',16,1),
(10,20,'2000-11-02 09:37:11','2000-11-13 09:37:11',6,8);

/* Задача 6. Cкрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы) */

-- Выбираем людей, проживающих в городе Москва
SELECT 
	surname,
	firstname,
	patronymic,
	city 
FROM persons
WHERE city LIKE 'Москва'

-- Выбираем все приемы у врача - Иванова Петра Михайловича
SELECT  
	(SELECT firstname FROM persons WHERE id = appointment.patient_id) AS name,
	(SELECT surname FROM persons WHERE id = appointment.patient_id) AS lastname,
	disease,
	date_appointment
FROM appointment
WHERE doctor_id = (SELECT id FROM persons WHERE surname LIKE 'Иванов' and firstname like 'Петр' and patronymic like 'Михайлович')


-- Количество приемов у каждого врача
SELECT 
	COUNT(*),
	(SELECT surname FROM persons where id=appointment.doctor_id ) as 'surname',
	(SELECT firstname FROM persons where id=appointment.doctor_id ) as 'firstname',
	(SELECT patronymic FROM persons where id=appointment.doctor_id ) as 'patronymic'
FROM appointment 
GROUP BY doctor_id

-- Выбираем все приемы у врача - Иванова Петра Михайловича с использованием JOIN
SELECT  
	p.firstname AS name,
	p.surname AS lastname,
	a.disease,
	a.date_appointment
FROM appointment a
JOIN persons p ON  a.patient_id = p.id
WHERE a.doctor_id = (SELECT id FROM persons WHERE surname LIKE 'Иванов' and firstname like 'Петр' and patronymic like 'Михайлович') 

-- У кого к текущему году просрочен медицинский сертификат
SELECT  
	p.surname AS lastname,
	p.firstname AS name,
	p.patronymic AS patronymic,
	s.name as specialty,
	m.date_sertificate 
FROM medical_staff m
JOIN persons p ON  m.medical_staff_id = p.id
JOIN specialty s ON  m.medical_staff_specialty = s.id
WHERE (SELECT year(date_sertificate)) < (select year(NOW()) - 5)


/* Задача 7. Представления (минимум 2) */

-- У кого просрочен сертификат
CREATE OR REPLACE VIEW end_sertificate
as
SELECT  
	p.surname AS lastname,
	p.firstname AS name,
	p.patronymic AS patronymic,
	s.name as specialty,
	m.date_sertificate 
FROM medical_staff m
JOIN persons p ON  m.medical_staff_id = p.id
JOIN specialty s ON  m.medical_staff_specialty = s.id
WHERE (SELECT year(date_sertificate)) < (select year(NOW()) - 5)

SELECT 
	lastname,
	name,
	patronymic
from end_sertificate

-- Посмотрим приемы врача Иванова Петра Михайловича в этом году 
CREATE OR REPLACE VIEW stat_appointment
as
SELECT  
	p.firstname AS name,
	p.surname AS lastname,
	a.disease,
	a.date_appointment
FROM appointment a
JOIN persons p ON  a.patient_id = p.id
WHERE a.doctor_id = (SELECT id FROM persons WHERE surname LIKE 'Иванов' and firstname like 'Петр' and patronymic like 'Михайлович') 

SELECT 
	disease,
	date_appointment 
FROM stat_appointment
WHERE (SELECT year(date_appointment) = 2021)

/* Задача 8. Хранимые процедуры / триггеры */

-- Продедура, определяющая пациентов, наблюдающихся у определенного врача
DROP PROCEDURE IF EXISTS proc_doc;

delimiter //
CREATE PROCEDURE proc_doc(IN for_doctor_id BIGINT)
BEGIN
	SELECT 
		a.patient_id
	FROM appointment a 
	WHERE a.doctor_id = for_doctor_id
	GROUP BY patient_id;
END//
delimiter ;

CALL proc_doc(10);

-- Процедура, отслеживающая все приемы определенного врача
DROP PROCEDURE IF EXISTS proc_doc2;

delimiter //
CREATE PROCEDURE proc_doc2(IN for_doctor_id BIGINT)
BEGIN
SELECT  
	p.firstname AS name,
	p.surname AS lastname,
	a.disease,
	a.date_appointment
FROM appointment a
JOIN persons p ON  a.patient_id = p.id
WHERE a.doctor_id = for_doctor_id;
END//
delimiter ;

CALL proc_doc2(10);

-- триггер для проверки возраста пользователя перед обновлением
DELIMITER //

CREATE TRIGGER check_user_age_before_update BEFORE UPDATE ON persons
FOR EACH ROW
begin
    IF NEW.birthday >= CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Update Canceled. Birthday must be in the past!';
    END IF;
END//

DELIMITER ;

-- триггер для проверки возраста пользователя при вставке новых строк
drop TRIGGER if exists check_user_age_before_insert;

DELIMITER //

CREATE TRIGGER check_user_age_before_insert BEFORE INSERT ON persons
FOR EACH ROW
begin
    IF NEW.birthday > CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Update Canceled. Birthday must be in the past!';
    END IF;
END//

DELIMITER ;


