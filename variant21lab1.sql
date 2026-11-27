-- 1. ГЛАВНАЯ ТАБЛИЦА: Почтовые отделения
CREATE TABLE Post_offices (
    Post_office_ID SERIAL PRIMARY KEY,
    Address        VARCHAR(100) NOT NULL,
    City           VARCHAR(50)  NOT NULL,
    District       VARCHAR(50)  NOT NULL,
    Postal_index   CHAR(6)      NOT NULL UNIQUE
                   CHECK (Postal_index ~ '^[0-9]{6}$'),
    Phone          VARCHAR(20)  NOT NULL
);
-- 2. ЗАВИСИМАЯ ТАБЛИЦА: Графики работы
-- Внешний ключ + каскадное обновление и удаление.
CREATE TABLE Work_schedules (
    Post_office_ID INT         NOT NULL,
    Department_ID  INT         NOT NULL,
    Day_of_week    VARCHAR(12) NOT NULL
                   CHECK (Day_of_week IN ('Понедельник','Вторник','Среда',
                          'Четверг','Пятница','Суббота','Воскресенье')),
    Work_start     TIME NOT NULL,
    Work_end       TIME NOT NULL,
    Break_start    TIME,
    Break_end      TIME,
    PRIMARY KEY (Post_office_ID, Department_ID, Day_of_week),
    FOREIGN KEY (Post_office_ID) REFERENCES Post_offices (Post_office_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CHECK (Work_end > Work_start),
    CHECK (Break_start IS NULL OR Break_end IS NULL
           OR (Break_end > Break_start
               AND Break_start >= Work_start
               AND Break_end <= Work_end))
);
-- 3. ЗАПОЛНЕНИЕ: Почтовые отделения (10 записей)
INSERT INTO Post_offices (Address, City, District, Postal_index, Phone) VALUES
('ул. Ленина, 15',        'Москва',          'Центральный',   '101000', '+7 (495) 123-45-01'),
('пр. Мира, 42',          'Москва',          'Северный',      '129090', '+7 (495) 123-45-02'),
('ул. Гагарина, 7',       'Санкт-Петербург', 'Невский',       '191002', '+7 (812) 234-56-03'),
('Невский пр., 100',      'Санкт-Петербург', 'Центральный',   '191025', '+7 (812) 234-56-04'),
('ул. Советская, 21',     'Казань',          'Вахитовский',   '420111', '+7 (843) 345-67-05'),
('ул. Баумана, 33',       'Казань',          'Кировский',     '420066', '+7 (843) 345-67-06'),
('ул. Кирова, 5',         'Самара',          'Ленинский',     '443010', '+7 (846) 456-78-07'),
('ул. Пушкина, 12',       'Екатеринбург',    'Верх-Исетский', '620014', '+7 (343) 567-89-08'),
('ул. Мира, 3',           'Новосибирск',     'Центральный',   '630099', '+7 (383) 678-90-09'),
('ул. Садовая, 18',       'Тверь',           'Заволжский',    '170100', '+7 (4822) 78-90-10');
-- 4. ЗАПОЛНЕНИЕ: Графики работы (12 записей)
INSERT INTO Work_schedules
(Post_office_ID, Department_ID, Day_of_week, Work_start, Work_end, Break_start, Break_end) VALUES
(1, 1, 'Понедельник',  '08:00', '20:00', '14:00', '15:00'),
(1, 1, 'Вторник',      '08:00', '20:00', '14:00', '15:00'),
(1, 2, 'Понедельник',  '09:00', '18:00', '13:00', '14:00'),
(2, 1, 'Среда',        '08:00', '19:00', '13:00', '14:00'),
(3, 1, 'Четверг',      '09:00', '18:00', '13:00', '14:00'),
(3, 3, 'Пятница',      '09:00', '17:00', NULL,    NULL),
(4, 1, 'Суббота',      '09:00', '15:00', NULL,    NULL),
(5, 2, 'Понедельник',  '08:30', '18:30', '12:30', '13:30'),
(6, 1, 'Вторник',      '08:00', '20:00', '14:00', '15:00'),
(7, 1, 'Среда',        '09:00', '18:00', '13:00', '14:00'),
(8, 4, 'Воскресенье',  '10:00', '15:00', NULL,    NULL),
(9, 1, 'Пятница',      '08:00', '19:00', '13:00', '14:00');
-- 5. ПРОВЕРКА ДАННЫХ
SELECT * FROM Post_offices;
SELECT * FROM Work_schedules;
-- 6. ПРОВЕРКА КАСКАДНОГО ОБНОВЛЕНИЯ И УДАЛЕНИЯ
-- Каскадное обновление: меняем код отделения 1 -> 100
UPDATE Post_offices SET Post_office_ID = 100 WHERE Post_office_ID = 1;
SELECT * FROM Work_schedules WHERE Post_office_ID = 100;
-- Каскадное удаление: удаляем отделение 100, его графики удалятся сами
DELETE FROM Post_offices WHERE Post_office_ID = 100;
SELECT * FROM Work_schedules;   -- записей с кодом 100 больше нет