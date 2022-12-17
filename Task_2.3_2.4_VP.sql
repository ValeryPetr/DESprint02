/*Задание 2.3*/

DROP TABLE users, departments, bonus;

/*1. Создать таблицу с основной информацией о сотрудниках: ФИО, дата рождения, дата начала работы, должность, 
уровень сотрудника (jun, middle, senior, lead), уровень зарплаты, идентификатор отдела, наличие/отсутствие прав(True/False). 
При этом в таблице обязательно должен быть уникальный номер для каждого сотрудника.*/

CREATE TABLE users (
user_id SERIAL PRIMARY KEY,
user_name VARCHAR (50) UNIQUE NOT NULL,
birth_date DATE NOT NULL,
first_day DATE NOT NULL,
position VARCHAR (50) NOT NULL,
experience VARCHAR (50) NOT NULL,
salary INT NOT NULL,
department_id INT NOT NULL,
drive_license BOOLEAN NOT NULL
);

/*2. Для будущих отчетов аналитики попросили вас создать еще одну таблицу с информацией по отделам – 
в таблице должен быть идентификатор для каждого отдела, название отдела (например. Бухгалтерский или IT отдел), 
ФИО руководителя и количество сотрудников.*/

CREATE TABLE departments (
department_id SERIAL PRIMARY KEY,
department_name VARCHAR (50) UNIQUE NOT NULL,
head_name VARCHAR (50) UNIQUE NOT NULL,
count_users INT NOT NULL
);

/*3. Создайте таблицу, в которой для каждого сотрудника будут его оценки за каждый квартал.
Диапазон оценок от A – самая высокая, до E – самая низкая.*/

CREATE TABLE bonus (
user_id INT NOT NULL,
year INT NOT NULL,
quarter INT NOT NULL,
rating CHAR(1) NOT NULL
);

/*Несколько уточнений по предыдущим заданиям – в первой таблице должны быть записи как минимум о 5 сотрудниках,
которые работают как минимум в 2-х разных отделах. Содержимое соответствующих атрибутов остается на совесть вашей фантазии,
но, желательно соблюдать осмысленность и правильно выбирать типы данных (для зарплаты – числовой тип, для ФИО – строковый и т.д.)*/

INSERT INTO users
values (1, 'Маслюков Юрий Дмитриевич', '1989-02-01', '2011-05-01', 'developer', 'Senior', 200500, 1, True),
       (2, 'Воротников Виталий Иванович', '1995-01-01', '2015-01-10', 'analyst', 'Junior', 50500, 1, False),
       (3, 'Рыжков Николай Иванович', '1990-09-07', '2012-05-06', 'developer', 'Middle', 100500, 1, True),
       (4, 'Соломенцев Михаил Сергеевич', '1985-01-29', '2009-12-08', 'analyst', 'Junior', 60500, 1, False),
       (5, 'Чебриков Виктор Михайлович', '1990-10-15', '2009-01-16', 'tester', 'Middle', 90600, 2, True);

/*Загрузить оценки (A, B, C, D, E) в таблицу*/

INSERT INTO bonus
values (1, 2021, 1, 'A'),
       (1, 2021, 2, 'B'),
       (1, 2021, 3, 'B'),
       (1, 2021, 4, 'A'),
       (2, 2021, 1, 'B'),
       (2, 2021, 2, 'C'),
       (2, 2021, 3, 'B'),
       (2, 2021, 4, 'C'),
       (3, 2021, 1, 'A'),
       (3, 2021, 2, 'C'),
       (3, 2021, 3, 'D'),
       (3, 2021, 4, 'C'),
       (4, 2021, 1, 'E'),
       (4, 2021, 2, 'E'),
       (4, 2021, 3, 'B'),
       (4, 2021, 4, 'C'),
       (5, 2021, 1, 'E'),
       (5, 2021, 2, 'B'),
       (5, 2021, 3, 'C'),
       (5, 2021, 4, 'A');

INSERT INTO departments
values (1, 'Machine Learning', 'Маск Илон Эрролович', 4),
       (2, 'Quality Assurance', 'Безос Джеффри Михайлович', 1);

/*Ваша команда расширяется и руководство запланировало открыть новый отдел – отдел Интеллектуального анализа данных. 
На начальном этапе в команду наняли одного руководителя отдела и двух сотрудников. 
Добавьте необходимую информацию в соответствующие таблицы.*/

INSERT INTO departments
values (3, 'Intellectual Data Analysis', 'Гейтс Уильям Генриевич', 2);

INSERT INTO users
values (6, 'Зиновьев Григорий Евсеевич', '1987-10-23', '2015-07-01', 'analyst', 'Senior', 190000, 3, True),
       (7, 'Каменев Лев Борисович', '1985-11-25', '2015-07-12', 'developer', 'Middle', 150500, 3, False);

INSERT INTO bonus
values (6, 2021, 1, 'B'),
       (6, 2021, 2, 'B'),
       (6, 2021, 3, 'A'),
       (6, 2021, 4, 'A'),
       (7, 2021, 1, 'B'),
       (7, 2021, 2, 'A'),
       (7, 2021, 3, 'D'),
       (7, 2021, 4, 'D');

/*6. Теперь пришла пора анализировать наши данные – напишите запросы для получения следующей информации:
6.1 Уникальный номер сотрудника, его ФИО и стаж работы – для всех сотрудников компании*/

SELECT user_id, user_name, EXTRACT(YEAR FROM AGE(first_day)) AS employment_length FROM users;

/*6.2 Уникальный номер сотрудника, его ФИО и стаж работы – только первых 3-х сотрудников*/

SELECT user_id, user_name, TO_CHAR(AGE(first_day), 'YY-MM') AS employment_length FROM users ORDER BY first_day LIMIT 3;

/*6.3 Уникальный номер сотрудников - водителей*/

SELECT user_id FROM users WHERE drive_license = True;

/*6.4 Выведите номера сотрудников, которые хотя бы за 1 квартал получили оценку D или E*/

SELECT user_name FROM users INNER JOIN bonus on users.user_id = bonus.user_id WHERE bonus.rating in ('D', 'E') GROUP BY user_name;

/*6.5 Выведите самую высокую зарплату в компании.*/

SELECT MAX(salary) FROM users;


/*Задание 2.4*/


/*a*/

/*Попробуйте вывести не просто самую высокую зарплату во всей команде, 
а вывести именно фамилию сотрудника с самой высокой зарплатой.*/

SELECT user_name FROM users WHERE salary = (SELECT MAX(salary) FROM users);
SELECT user_name FROM users ORDER BY salary DESC LIMIT 1;

/*b*/

/*Попробуйте вывести фамилии сотрудников в алфавитном порядке.*/

SELECT user_name FROM users ORDER by user_name;

/*c*/

/*Рассчитайте средний стаж для каждого уровня сотрудников*/

SELECT EXTRACT(EPOCH from AVG(AGE(first_day)))/(3600*24) AS avg_days, experience FROM users GROUP BY experience;

/*d*/

/*Введите фамилию сотрудника и название отдела, в котором он работает.*/

SELECT user_name, department_name FROM users LEFT JOIN departments ON users.department_id = departments.department_id;

/*e*/

/*Выведите название отдела и фамилию сотрудника с самой высокой зарплатой в данном отделе и саму зарплату также.*/

SELECT MIN(department_name) as department, MIN(user_name) as name, MAX(salary) as max_salary FROM 
users LEFT JOIN departments AS d ON users.department_id = d.department_id GROUP BY users.department_id;

