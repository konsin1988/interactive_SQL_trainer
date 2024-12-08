
-- create
CREATE TABLE author(author_id INT PRIMARY KEY AUTO_INCREMENT, name_author VARCHAR(50));
CREATE TABLE genre(genre_id INT PRIMARY KEY AUTO_INCREMENT, name_genre VARCHAR(30));
CREATE TABLE book(book_id INT PRIMARY KEY AUTO_INCREMENT, 
  title VARCHAR(50), 
  author_id INT NOT NULL, 
  genre_id INT NOT NULL, 
  price DECIMAL(8, 2),
  amount INT,
  FOREIGN KEY(author_id) REFERENCES author(author_id),
  FOREIGN KEY(genre_id) REFERENCES genre(genre_id)
  );
CREATE TABLE city(city_id INT PRIMARY KEY AUTO_INCREMENT, 
  name_city VARCHAR(30), days_delivery INT);
CREATE TABLE client(client_id INT PRIMARY KEY AUTO_INCREMENT, 
  name_client VARCHAR(50), 
  city_id INT NOT NULL,
  email VARCHAR(30),
  FOREIGN KEY(city_id) REFERENCES city(city_id)
  );
CREATE TABLE buy(
  buy_id INT PRIMARY KEY AUTO_INCREMENT, 
  buy_description VARCHAR(100),
  client_id INT NOT NULL,
  FOREIGN KEY(client_id) REFERENCES client(client_id)
  );
CREATE TABLE step(
  step_id INT PRIMARY KEY AUTO_INCREMENT,
  name_step VARCHAR(30)
  );
CREATE TABLE buy_book(
  buy_book_id INT PRIMARY KEY AUTO_INCREMENT,
  buy_id INT NOT NULL,
  book_id INT NOT NULL,
  amount INT,
  FOREIGN KEY(buy_id) REFERENCES buy(buy_id),
  FOREIGN KEY(book_id) REFERENCES book(book_id)
  );
CREATE TABLE buy_step(
  buy_step_id INT PRIMARY KEY AUTO_INCREMENT,
  buy_id INT NOT NULL,
  step_id INT NOT NULL,
  date_step_beg DATE,
  date_step_end DATE,
  FOREIGN KEY(buy_id) REFERENCES buy(buy_id),
  FOREIGN KEY(step_id) REFERENCES step(step_id)
  );



-- insert
INSERT INTO author(name_author)
  VALUES ('Булгаков М.А.'), ('Достоевский Ф.М.'), 
  ('Есенин С.А.'), ('Пастернак Б.Л.'), ('Лермонтов М.Ю.');
INSERT INTO genre(name_genre)
  VALUES ('Роман'), ('Поэзия'), ('Приключения');
INSERT INTO book(title, author_id, genre_id, price, amount)
  VALUES ('Мастер и Маргарита', 1, 1, 670.99, 3),
          ('Белая гвардия', 1, 1, 540.50, 5),
          ('Идиот', 2, 1, 460.00, 10),
          ('Братья Карамазовы', 2, 1, 799.01, 2),
          ('Игрок', 2, 1, 480.50, 10),
          ('Стихотворения и поэмы', 3, 2, 650.00, 15),
          ('Черный человек', 3, 2, 570.20, 6),
          ('Лирика', 4, 2, 518.99, 2);
INSERT INTO city(name_city, days_delivery)
  VALUES ('Москва', 5),
          ('Санкт-Петербург', 3),
          ('Владивосток', 12);
INSERT INTO client(name_client, city_id, email)
  VALUES ('Баранов Павел', 3, 'baranov@test'),
          ('Абрамова Катя', 1, 'abramova@test'),
          ('Семенонов Иван', 2, 'semenov@test'),
          ('Яковлева Галина', 1, 'yakovleva@test');
INSERT INTO buy(buy_description, client_id)
  VALUES ('Доставка только вечером', 1),
          ('', 3),
          ('Упаковать каждую книгу по отдельности', 2),
          ('', 1);
INSERT INTO buy_book(buy_id, book_id, amount)
  VALUES (1, 1, 1),
          (1, 7, 2),
          (1, 3, 1),
          (2, 8, 2),
          (3, 3, 2),
          (3, 2, 1),
          (3, 1, 1),
          (4, 5, 1);
INSERT INTO step(name_step)
  VALUES ('Оплата'),
          ('Упаковка'),
          ('Транспортировка'),
          ('Доставка');
INSERT INTO buy_step(buy_id, step_id, date_step_beg, date_step_end)
  VALUES (1, 1, '2020-02-20', '2020-02-20'),
          (1, 2, '2020-02-20', '2020-02-21'),
          (1, 3, '2020-02-22', '2020-03-07'),
          (1, 4, '2020-03-08', '2020-03-08'),
          (2, 1, '2020-02-28', '2020-02-28'),
          (2, 2, '2020-02-29', '2020-03-01'),
          (2, 3, '2020-03-02', NULL),
          (2, 4, NULL, NULL),
          (3, 1, '2020-03-05', '2020-03-05'),
          (3, 2, '2020-03-05', '2020-03-06'),
          (3, 3, '2020-03-06', '2020-03-10'),
          (3, 4, '2020-03-11', NULL),
          (4, 1, '2020-03-20', NULL),
          (4, 2, NULL, NULL),
          (4, 3, NULL, NULL),
          (4, 4, NULL, NULL);

-------------------------------------------------------
/* insert/create */
/*Включить нового человека в таблицу с клиентами. 
Его имя Попов Илья, его email popov@test, 
проживает он в Москве.*/
INSERT INTO client(name_client, city_id, email)
VALUES('Попов Илья', (
    SELECT city_id
    FROM city
    WHERE name_city = 'Москва'
    ), 'popov@test');

/*Создать новый заказ для Попова Ильи. 
Его комментарий для заказа: 
«Связаться со мной по вопросу доставки».*/
INSERT INTO buy(buy_description, client_id)
SELECT 'Связаться со мной по вопросу доставки', client_id 
FROM client
WHERE name_client = 'Попов Илья';

/*В таблицу buy_book добавить заказ с номером 5. 
Этот заказ должен содержать книгу Пастернака 
«Лирика» в количестве двух экземпляров 
и книгу Булгакова «Белая гвардия» 
в одном экземпляре.*/
INSERT INTO buy_book(buy_id, book_id, amount)
VALUES
  (5, (
    SELECT book_id
    FROM book INNER JOIN author USING(author_id)
    WHERE title='Лирика' AND name_author LIKE 'Пастернак %'
  ), 2),
  (5, (
    SELECT book_id
    FROM book INNER JOIN author USING(author_id)
    WHERE title='Белая Гвардия' AND name_author LIKE 'Булгаков %'
  ), 1
  );

  /*Количество тех книг на складе, которые были 
  включены в заказ с номером 5, уменьшить 
  на то количество, которое в заказе с номером 5  указано.*/
  /*В подобрых заданиях с Update и условием правильнее условие прописывать в INNER JOIN, так оптимизация работает лучше*/
  UPDATE book INNER JOIN buy_book ON book.book_id = buy_book.book_id AND buy_id = 5
SET book.amount = book.amount - buy_book.amount;

/*Создать счет (таблицу buy_pay) на оплату заказа с номером 5, 
в который включить название книг, их автора, цену, 
количество заказанных книг и  стоимость. Последний 
столбец назвать Стоимость. Информацию в таблицу занести 
в отсортированном по названиям книг виде.*/
CREATE TABLE buy_pay AS (
  SELECT title, name_author, price, buy_book.amount, price * buy_book.amount AS 'Стоимость'
  FROM book INNER JOIN author USING(author_id)
    INNER JOIN buy_book ON book.book_id = buy_book.book_id AND buy_id = 5
  ORDER BY title
);

/*Создать общий счет (таблицу buy_pay) на оплату 
заказа с номером 5. Куда включить номер заказа, 
количество книг в заказе (название столбца Количество) 
и его общую стоимость (название столбца Итого). 
Для решения используйте ОДИН запрос.*/
CREATE TABLE buy_pay AS (
  SELECT buy_id, SUM(buy_book.amount) AS 'Количество', SUM(price * buy_book.amount) AS 'Итого'
  FROM book INNER JOIN buy_book ON book.book_id = buy_book.book_id AND buy_book.buy_id = 5
  GROUP BY buy_id
);

/*В таблицу buy_step для заказа с номером 5 
включить все этапы из таблицы step, которые 
должен пройти этот заказ. В столбцы date_step_beg 
и date_step_end всех записей занести Null.*/
INSERT INTO buy_step(buy_id, step_id)
SELECT 5, step_id
FROM step;

/* В таблицу buy_step занести дату 12.04.2020
 выставления счета на оплату заказа с номером 5.*/
 UPDATE buy_step 
  INNER JOIN step ON step.step_id = buy_step.step_id 
    AND buy_step.step_id = 1 
    AND buy_step.buy_id = 5
SET date_step_beg = '2020.04.12';

/*Завершить этап «Оплата» для заказа с номером 5, 
вставив в столбец date_step_end дату 13.04.2020, 
и начать следующий этап («Упаковка»), 
задав в столбце date_step_beg для этого этапа ту же дату.

Реализовать два запроса для завершения этапа 
и начала следующего. Они должны быть записаны 
в общем виде, чтобы его можно было применять 
для любых этапов, изменив только текущий этап. 
Для примера пусть это будет этап «Оплата».*/
UPDATE buy_step
  JOIN (
    SELECT @step := step.step_id, @date := '2020.04.13', @next_step := step.step_id + 1
    FROM step 
    WHERE name_step = 'Оплата'
  ) var
  INNER JOIN step ON step.step_id = buy_step.step_id
  AND buy_id = 5
SET date_step_end = IF(buy_step.step_id = @step, @date, date_step_end),
  date_step_beg = IF(buy_step.step_id = @next_step, @date, date_step_beg);


--------------------------------------------------------------------------
-- fetch 
-- Вывести фамилии всех клиентов, которые заказали книгу Булгакова «Мастер и Маргарита».
SELECT name_client
FROM client
WHERE client_id IN (
    SELECT client_id
    FROM buy INNER JOIN buy_book ON buy.buy_id = buy_book.buy_id 
    INNER JOIN book ON buy_book.book_id = book.book_id
    INNER JOIN author ON author.author_id = book.book_id
    WHERE author.name_author LIKE 'Булгаков %' AND book.title = 'Мастер и Маргарита'
  );

/* Вывести все заказы Баранова Павла 
(id заказа, какие книги, по какой цене и в каком количестве он заказал) 
в отсортированном по номеру заказа и названиям книг виде. */
SELECT buy.buy_id, title, price, buy_book.amount
FROM author INNER JOIN book ON author.author_id = book.author_id
  INNER JOIN buy_book ON book.book_id = buy_book.book_id
  INNER JOIN buy ON buy.buy_id = buy_book.buy_id
  INNER JOIN client ON buy.client_id = client.client_id
  WHERE client.name_client = 'Баранов Павел'
ORDER BY buy_id, title;

/* Посчитать, сколько раз была заказана каждая книга, 
для книги вывести ее автора (нужно посчитать, 
в каком количестве заказов фигурирует каждая книга).  
Вывести фамилию и инициалы автора, название книги, 
последний столбец назвать Количество. 
Результат отсортировать сначала  по фамилиям авторов, 
а потом по названиям книг. */
SELECT name_author, title, COUNT(buy_book.book_id) AS 'Количество'
FROM book LEFT JOIN author ON author.author_id = book.author_id
  LEFT JOIN buy_book ON buy_book.book_id = book.book_id
GROUP BY book.book_id
ORDER BY author.name_author, book.title;

/*Вывести города, в которых живут клиенты, 
оформлявшие заказы в интернет-магазине. 
Указать количество заказов в каждый город, 
этот столбец назвать Количество. 
Информацию вывести по убыванию количества заказов, 
а затем в алфавитном порядке по названию городов. */
SELECT name_city, COUNT(buy.buy_id) AS 'Количество'
FROM city LEFT JOIN client ON city.city_id = client.city_id
  LEFT JOIN buy ON buy.client_id = client.client_id
GROUP BY city.city_id
ORDER BY Количество DESC, name_city;

/* Вывести номера всех оплаченных заказов 
и даты, когда они были оплачены.*/
SELECT buy.buy_id, buy_step.date_step_end
FROM buy INNER JOIN buy_step ON buy.buy_id = buy_step.buy_id
  INNER JOIN step ON buy_step.step_id = step.step_id
WHERE step.name_step = 'Оплата' AND date_step_end IS NOT NULL;

/*Вывести информацию о каждом заказе: 
его номер, кто его сформировал (фамилия пользователя) 
и его стоимость (сумма произведений количества 
заказанных книг и их цены), в отсортированном 
по номеру заказа виде. Последний столбец назвать Стоимость.*/
SELECT buy_book.buy_id, client.name_client, SUM(book.price * buy_book.amount) AS 'Стоимость'
FROM book 
  INNER JOIN buy_book ON book.book_id = buy_book.book_id
  INNER JOIN buy ON buy_book.buy_id = buy.buy_id
  INNER JOIN client ON client.client_id = buy.client_id
GROUP BY buy.buy_id
ORDER BY buy.buy_id;

/*Вывести номера заказов (buy_id) и названия этапов,  
на которых они в данный момент находятся. 
Если заказ доставлен –  информацию о нем не выводить. 
Информацию отсортировать по возрастанию buy_id.*/
SELECT buy.buy_id, step.name_step
FROM buy 
  INNER JOIN buy_step ON buy.buy_id = buy_step.buy_id
  INNER JOIN step ON buy_step.step_id = step.step_id
WHERE date_step_end IS NULL AND date_step_beg IS NOT NULL
ORDER BY buy.buy_id;

/* В таблице city для каждого города указано количество дней, 
за которые заказ может быть доставлен в этот город 
(рассматривается только этап Транспортировка). 
Для тех заказов, которые прошли этап транспортировки, 
вывести количество дней за которое заказ 
реально доставлен в город. 
А также, если заказ доставлен с опозданием, 
указать количество дней задержки, 
в противном случае вывести 0. 
В результат включить номер заказа (buy_id), 
а также вычисляемые столбцы 
Количество_дней и Опоздание. 
Информацию вывести в отсортированном по номеру заказа виде. */
SELECT buy.buy_id, 
  @days := DATEDIFF(date_step_end, date_step_beg) AS 'Количество_дней', 
  IF(@days - city.days_delivery > 0, (@days - city.days_delivery), 0) AS 'Опоздание'
FROM city 
  INNER JOIN client ON city.city_id = client.city_id
  INNER JOIN buy ON client.client_id = buy.client_id
  INNER JOIN buy_step ON buy.buy_id = buy_step.buy_id
  INNER JOIN step ON buy_step.step_id = step.step_id
WHERE name_step = 'Транспортировка' AND date_step_beg IS NOT NULL AND date_step_end IS NOT NULL
ORDER BY buy.buy_id;

/* Выбрать всех клиентов, которые заказывали книги Достоевского, 
информацию вывести в отсортированном по алфавиту виде. 
В решении используйте фамилию автора, а не его id.*/
SELECT name_client 
FROM client 
  INNER JOIN buy ON client.client_id = buy.client_id
  INNER JOIN buy_book ON buy.buy_id = buy_book.buy_id
  INNER JOIN book ON book.book_id = buy_book.book_id
  INNER JOIN author ON author.author_id = book.author_id
WHERE author.name_author LIKE 'Достоевский %'
GROUP BY name_client
ORDER BY name_client;

/* Вывести жанр (или жанры), 
в котором было заказано больше всего экземпляров книг, 
указать это количество. 
Последний столбец назвать Количество. */
SELECT genre.name_genre, SUM(buy_book.amount) AS 'Количество'
FROM genre 
  INNER JOIN book ON genre.genre_id = book.genre_id
  INNER JOIN buy_book ON book.book_id = buy_book.book_id
GROUP BY genre.name_genre
HAVING SUM(buy_book.amount) = (
    SELECT SUM(buy_book.amount)
    FROM book INNER JOIN buy_book ON book.book_id = buy_book.book_id
    GROUP BY book.genre_id
    ORDER BY SUM(buy_book.amount) DESC
    LIMIT 1
  );

/* Сравнить ежемесячную выручку от продажи книг за текущий и предыдущий годы. 
Для этого вывести год, месяц, сумму выручки 
в отсортированном сначала по возрастанию месяцев, 
затем по возрастанию лет виде. 
Название столбцов: Год, Месяц, Сумма. */
SELECT YEAR(date_payment) AS 'Год', MONTHNAME(date_payment) AS 'Месяц', SUM(price * amount) AS 'Сумма'
FROM buy_archive
GROUP BY Год, Месяц
UNION 
SELECT YEAR(date_step_end) AS 'Год', MONTHNAME(date_step_end) AS 'Месяц', SUM(price * buy_book.amount) AS 'Сумма'
FROM book 
    INNER JOIN buy_book ON book.book_id = buy_book.book_id
    INNER JOIN buy USING(buy_id)
    INNER JOIN buy_step USING(buy_id)
WHERE step_id = 1 AND date_step_end IS NOT NULL
GROUP BY Год, Месяц
ORDER BY Месяц, Год

/* Прирост выручки с клиента по годам. */
/* Пришлось попотеть с приростом, чтоб сделать красиво, прирост при значении 0 в 2019 - 100%, прирост при значении 0 в 2020 - "-100". Некий геморрой, при том использовать переменные в этом же запросе не получается, он их высчитывает, судя по всему, позже, и даёт NULL. А если переменные записывать в предыдущем запросе, - он в переменную записывает значение последнего клиента, что нам не подходит*/
SELECT name_client, 
    IF(SUM(buy_archive.amount * buy_archive.price) IS NULL, 0.00, SUM(buy_archive.amount * buy_archive.price)) AS 'Выручка 2019, руб', 
    IF(SUM(buy_book.amount * book.price) IS NULL, 0.00, SUM(buy_book.amount * book.price))  AS 'Выручка 2020, руб', 
    IF(SUM(buy_archive.amount * buy_archive.price) IS NULL AND SUM(buy_book.amount * book.price) IS NULL, 0,     IF(SUM(buy_archive.amount * buy_archive.price) IS NULL, 100, IF(SUM(buy_book.amount * book.price) IS NULL,     -100, ROUND((SUM(buy_book.amount * book.price)-SUM(buy_archive.amount * buy_archive.price))/ SUM(buy_archive.amount  * buy_archive.price) * 100, 2) )))  AS 'Прирост, %'
FROM client 
    LEFT JOIN buy_archive USING(client_id)
    LEFT JOIN buy USING(client_id)
    LEFT JOIN buy_book ON buy.buy_id = buy_book.buy_id
    LEFT JOIN book ON book.book_id = buy_book.book_id
GROUP BY name_client
ORDER BY name_client;

/* Найти книги 2020 года в архиве 2019 года и вывести разницу в их ценах:*/
SELECT book.title, buy_archive.price AS 'Цена_2019', book.price AS 'Цена_2020', 
    ROUND((book.price - buy_archive.price) / buy_archive.price * 100, 2) AS 'Разница_%'
FROM book RIGHT JOIN buy_archive USING(book_id)
GROUP BY book.title, buy_archive.price, book.price
ORDER BY book.title;

/*Вывести города, в которых продается самая популярная книга. 
Популярность книги определить по количеству проданных книг 
(проданными считаются оплаченные книги). 
Столбцы назвать Название, Город, Количество_проданных_книг. */


