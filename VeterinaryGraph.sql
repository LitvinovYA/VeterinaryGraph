/*
=====================================================
  ГРАФОВАЯ БАЗА ДАННЫХ: ВЕТЕРИНАРИЯ
  Питомцы, владельцы, прививки
  MS SQL Server Graph Database
=====================================================
*/

-- ================================================
-- ШАГ 1. СОЗДАНИЕ БАЗЫ ДАННЫХ
-- ================================================
USE master;
DROP DATABASE IF EXISTS VeterinaryGraph;
CREATE DATABASE VeterinaryGraph;
GO

USE VeterinaryGraph;
GO

-- ================================================
-- ШАГ 1. СОЗДАНИЕ ТАБЛИЦ УЗЛОВ (NODE TABLES)
-- ================================================

-- 1.1. Owners (Владельцы питомцев)
CREATE TABLE Owners
(
    id    INT             NOT NULL PRIMARY KEY,
    name  NVARCHAR(100)   NOT NULL,
    phone NVARCHAR(20)    NOT NULL,
    email NVARCHAR(100)   NULL
) AS NODE;
GO

-- 1.2. Pets (Питомцы)
CREATE TABLE Pets
(
    id         INT           NOT NULL PRIMARY KEY,
    name       NVARCHAR(50)  NOT NULL,
    species    NVARCHAR(30)  NOT NULL,
    breed      NVARCHAR(50)  NULL,
    birth_date DATE          NULL,
    gender     NCHAR(1)      NOT NULL
) AS NODE;
GO

-- 1.3. Vaccinations (Прививки/вакцины)
CREATE TABLE Vaccinations
(
    id              INT            NOT NULL PRIMARY KEY,
    name            NVARCHAR(100)  NOT NULL,
    description     NVARCHAR(200)  NULL,
    manufacturer    NVARCHAR(100)  NULL,
    validity_months INT            NOT NULL
) AS NODE;
GO

-- 1.4. Vets (Ветеринарные врачи)
CREATE TABLE Vets
(
    id        INT            NOT NULL PRIMARY KEY,
    name      NVARCHAR(100)  NOT NULL,
    specialty NVARCHAR(50)   NOT NULL,
    phone     NVARCHAR(20)   NOT NULL,
    clinic    NVARCHAR(100)  NULL
) AS NODE;
GO

-- ================================================
-- ШАГ 1. СОЗДАНИЕ ТАБЛИЦ РЁБЕР (EDGE TABLES)
-- ================================================

-- 2.1. Owns (Владеет) — владелец владеет питомцем
CREATE TABLE Owns
(
    ownership_start_date DATE NOT NULL,
    is_primary           BIT  NOT NULL DEFAULT 1
) AS EDGE;
GO

ALTER TABLE Owns
ADD CONSTRAINT EC_Owns CONNECTION (Owners TO Pets);
GO

-- 2.2. Vaccinated (Вакцинирован) — питомцу сделана прививка
CREATE TABLE Vaccinated
(
    vaccination_date DATE         NOT NULL,
    dose_number      INT          NOT NULL DEFAULT 1,
    notes            NVARCHAR(200) NULL
) AS EDGE;
GO

ALTER TABLE Vaccinated
ADD CONSTRAINT EC_Vaccinated CONNECTION (Pets TO Vaccinations);
GO

-- 2.3. PerformedBy (Проведена) — прививку сделал ветеринар
CREATE TABLE PerformedBy
(
    procedure_date     DATE         NOT NULL,
    certificate_number NVARCHAR(50) NULL
) AS EDGE;
GO

ALTER TABLE PerformedBy
ADD CONSTRAINT EC_PerformedBy CONNECTION (Vaccinations TO Vets);
GO

-- 2.4. Referral (Направление) — ветеринар направил владельца
CREATE TABLE Referral
(
    referral_date DATE         NOT NULL,
    reason        NVARCHAR(200) NULL
) AS EDGE;
GO

ALTER TABLE Referral
ADD CONSTRAINT EC_Referral CONNECTION (Vets TO Owners);
GO

-- 2.5. ReferredTo (Перенаправлен) — ветеринар перенаправил к другому ветеринару
CREATE TABLE ReferredTo
(
    referral_date DATE         NOT NULL,
    reason        NVARCHAR(200) NULL
) AS EDGE;
GO

ALTER TABLE ReferredTo
ADD CONSTRAINT EC_ReferredTo CONNECTION (Vets TO Vets);
GO

-- ================================================
-- ШАГ 2. ЗАПОЛНЕНИЕ ТАБЛИЦ УЗЛОВ (10+ строк)
-- ================================================

-- 3.1. Owners (12 владельцев)
INSERT INTO Owners (id, name, phone, email)
VALUES
(1,  N'Иван Петров',        '+375291234567', N'ivan.petrov@email.com'),
(2,  N'Мария Иванова',      '+375292345678', N'maria.ivanova@email.com'),
(3,  N'Алексей Сидоров',    '+375293456789', N'alex.sidorov@email.com'),
(4,  N'Елена Козлова',      '+375294567890', N'elena.kozlova@email.com'),
(5,  N'Дмитрий Новиков',    '+375295678901', N'dmitry.novikov@email.com'),
(6,  N'Ольга Морозова',     '+375296789012', N'olga.morozova@email.com'),
(7,  N'Сергей Волков',      '+375297890123', N'sergey.volkov@email.com'),
(8,  N'Анна Соколова',      '+375298901234', N'anna.sokolova@email.com'),
(9,  N'Павел Кузнецов',     '+375299012345', N'pavel.kuznetsov@email.com'),
(10, N'Наталья Попова',     '+375291112233', N'natalia.popova@email.com'),
(11, N'Андрей Лебедев',     '+375292223344', N'andrey.lebedev@email.com'),
(12, N'Татьяна Семёнова',   '+375293334455', N'tatiana.semenova@email.com');
GO

-- 3.2. Pets (12 питомцев)
INSERT INTO Pets (id, name, species, breed, birth_date, gender)
VALUES
(1,  N'Барсик',  N'Кошка',    N'Сиамская',    '2020-03-15', 'M'),
(2,  N'Мухтар',  N'Собака',   N'Немецкая овчарка', '2019-07-20', 'M'),
(3,  N'Мурка',   N'Кошка',    N'Персидская',  '2021-01-10', 'F'),
(4,  N'Шарик',   N'Собака',   N'Лабрадор',    '2020-11-05', 'M'),
(5,  N'Рыжик',   N'Кошка',    N'Дворовая',    '2022-04-18', 'M'),
(6,  N'Белка',   N'Собака',   N'Хаски',       '2021-08-22', 'F'),
(7,  N'Кеша',    N'Попугай',  N'Волнистый',   '2023-02-14', 'M'),
(8,  N'Джек',    N'Собака',   N'Такса',       '2018-09-30', 'M'),
(9,  N'Снежок',  N'Кошка',    N'Британская',  '2022-12-01', 'M'),
(10, N'Леди',    N'Собака',   N'Пудель',      '2020-06-17', 'F'),
(11, N'Том',     N'Кошка',    N'Мейн-кун',    '2021-05-03', 'M'),
(12, N'Рекс',    N'Собака',   N'Ротвейлер',   '2019-04-11', 'M');
GO

-- 3.3. Vaccinations (12 вакцин)
INSERT INTO Vaccinations (id, name, description, manufacturer, validity_months)
VALUES
(1,  N'Нобивак Rabies',     N'Профилактика бешенства',          N'Intervet',       36),
(2,  N'Нобивак DHPPi',     N'Чума + Гепатит + Парвовирус',    N'Intervet',       12),
(3,  N'Мультикан-8',       N'Комплексная вакцина',              N'НПО Нарвак',     12),
(4,  N'Вакдерм',           N'Дерматофитозы',                    N'ВетЗвероЦентр',  12),
(5,  N'Нобивак Bb',        N'Бордетеллез',                     N'Intervet',       12),
(6,  N'Пуревакс FeLV',     N'Лейкоз кошек',                    N'Merial',         12),
(7,  N'Нобивак Tricat',    N'Калицивирус + Ринотрахеит',       N'Intervet',       12),
(8,  N'Гексадог',          N'Бешенство + Комплексная',          N'Merial',         24),
(9,  N'Биовак',            N'Парвовирусный энтерит',            N'Биоцентр',       12),
(10, N'Нобивак Lepto',     N'Лептоспироз',                     N'Intervet',       12),
(11, N'Вангард-5',         N'Комплексная для собак',            N'Zoetis',         12),
(12, N'Фелиген CRP',       N'Калицивирус + Ринотрахеит + Панлейкопения', N'Virbac', 12);
GO

-- 3.4. Vets (12 ветеринаров)
INSERT INTO Vets (id, name, specialty, phone, clinic)
VALUES
(1,  N'Доктор Смирнов',    N'Хирургия',       '+375331234567', N'Городская ветклиника'),
(2,  N'Доктор Васильева',  N'Терапия',        '+375332345678', N'Центральная ветклиника'),
(3,  N'Доктор Кузьмин',    N'Ортопедия',      '+375333456789', N'Ветцентр Зоозабота'),
(4,  N'Доктор Белова',     N'Дерматология',   '+375334567890', N'Городская ветклиника'),
(5,  N'Доктор Фёдоров',    N'Офтальмология',  '+375335678901', N'Ветклиника Друг'),
(6,  N'Доктор Крылова',    N'Стоматология',   '+375336789012', N'Центральная ветклиника'),
(7,  N'Доктор Григорьев',  N'Хирургия',       '+375337890123', N'Ветцентр Зоозабота'),
(8,  N'Доктор Тимофеева',  N'Терапия',        '+375338901234', N'Ветклиника Друг'),
(9,  N'Доктор Захаров',    N'Кардиология',    '+375339012345', N'Городская ветклиника'),
(10, N'Доктор Морозова',   N'Неврология',     '+375331122334', N'Центральная ветклиника'),
(11, N'Доктор Павлов',     N'Онкология',      '+375332233445', N'Ветцентр Зоозабота'),
(12, N'Доктор Соколова',   N'Экзотика',       '+375333344556', N'Ветклиника Друг');
GO

-- ================================================
-- ШАГ 3. ЗАПОЛНЕНИЕ ТАБЛИЦ РЁБЕР
-- ================================================

-- 4.1. Owns (Владелец -> Питомец)
INSERT INTO Owns ($from_id, $to_id, ownership_start_date, is_primary)
VALUES
((SELECT $node_id FROM Owners WHERE id = 1),  (SELECT $node_id FROM Pets WHERE id = 1),  '2020-04-01', 1),
((SELECT $node_id FROM Owners WHERE id = 1),  (SELECT $node_id FROM Pets WHERE id = 11), '2021-06-01', 0),
((SELECT $node_id FROM Owners WHERE id = 2),  (SELECT $node_id FROM Pets WHERE id = 2),  '2019-08-10', 1),
((SELECT $node_id FROM Owners WHERE id = 3),  (SELECT $node_id FROM Pets WHERE id = 3),  '2021-02-15', 1),
((SELECT $node_id FROM Owners WHERE id = 3),  (SELECT $node_id FROM Pets WHERE id = 5),  '2022-05-20', 0),
((SELECT $node_id FROM Owners WHERE id = 4),  (SELECT $node_id FROM Pets WHERE id = 4),  '2020-12-01', 1),
((SELECT $node_id FROM Owners WHERE id = 5),  (SELECT $node_id FROM Pets WHERE id = 6),  '2021-09-10', 1),
((SELECT $node_id FROM Owners WHERE id = 6),  (SELECT $node_id FROM Pets WHERE id = 7),  '2023-03-01', 1),
((SELECT $node_id FROM Owners WHERE id = 7),  (SELECT $node_id FROM Pets WHERE id = 8),  '2018-10-15', 1),
((SELECT $node_id FROM Owners WHERE id = 8),  (SELECT $node_id FROM Pets WHERE id = 9),  '2023-01-05', 1),
((SELECT $node_id FROM Owners WHERE id = 9),  (SELECT $node_id FROM Pets WHERE id = 10), '2020-07-20', 1),
((SELECT $node_id FROM Owners WHERE id = 10), (SELECT $node_id FROM Pets WHERE id = 12), '2019-05-10', 1),
((SELECT $node_id FROM Owners WHERE id = 11), (SELECT $node_id FROM Pets WHERE id = 4),  '2022-03-15', 0),
((SELECT $node_id FROM Owners WHERE id = 12), (SELECT $node_id FROM Pets WHERE id = 6),  '2022-01-10', 0);
GO

-- 4.2. Vaccinated (Питомец -> Вакцина)
INSERT INTO Vaccinated ($from_id, $to_id, vaccination_date, dose_number, notes)
VALUES
((SELECT $node_id FROM Pets WHERE id = 1),  (SELECT $node_id FROM Vaccinations WHERE id = 1), '2023-01-15', 1, N'Плановая вакцинация'),
((SELECT $node_id FROM Pets WHERE id = 1),  (SELECT $node_id FROM Vaccinations WHERE id = 7), '2023-01-15', 1, N'Комплексная'),
((SELECT $node_id FROM Pets WHERE id = 2),  (SELECT $node_id FROM Vaccinations WHERE id = 1), '2023-02-10', 2, N'Ревакцинация'),
((SELECT $node_id FROM Pets WHERE id = 2),  (SELECT $node_id FROM Vaccinations WHERE id = 2), '2023-02-10', 1, N'Комплексная'),
((SELECT $node_id FROM Pets WHERE id = 2),  (SELECT $node_id FROM Vaccinations WHERE id = 11), '2023-02-10', 1, N'Вангард'),
((SELECT $node_id FROM Pets WHERE id = 3),  (SELECT $node_id FROM Vaccinations WHERE id = 1), '2023-03-05', 1, N'Плановая'),
((SELECT $node_id FROM Pets WHERE id = 3),  (SELECT $node_id FROM Vaccinations WHERE id = 6), '2023-03-05', 1, N'От лейкоза'),
((SELECT $node_id FROM Pets WHERE id = 4),  (SELECT $node_id FROM Vaccinations WHERE id = 1), '2022-12-20', 1, N'Плановая'),
((SELECT $node_id FROM Pets WHERE id = 4),  (SELECT $node_id FROM Vaccinations WHERE id = 8), '2022-12-20', 1, N'Гексадог'),
((SELECT $node_id FROM Pets WHERE id = 5),  (SELECT $node_id FROM Vaccinations WHERE id = 7), '2023-04-10', 1, N'Первая прививка'),
((SELECT $node_id FROM Pets WHERE id = 6),  (SELECT $node_id FROM Vaccinations WHERE id = 1), '2023-05-15', 1, N'Плановая'),
((SELECT $node_id FROM Pets WHERE id = 6),  (SELECT $node_id FROM Vaccinations WHERE id = 11), '2023-05-15', 1, N'Комплексная'),
((SELECT $node_id FROM Pets WHERE id = 7),  (SELECT $node_id FROM Vaccinations WHERE id = 1), '2023-06-01', 1, N'Для попугая'),
((SELECT $node_id FROM Pets WHERE id = 8),  (SELECT $node_id FROM Vaccinations WHERE id = 1), '2022-10-05', 3, N'Ревакцинация'),
((SELECT $node_id FROM Pets WHERE id = 8),  (SELECT $node_id FROM Vaccinations WHERE id = 2), '2022-10-05', 1, N'Комплексная'),
((SELECT $node_id FROM Pets WHERE id = 9),  (SELECT $node_id FROM Vaccinations WHERE id = 1), '2023-01-10', 1, N'Плановая'),
((SELECT $node_id FROM Pets WHERE id = 9),  (SELECT $node_id FROM Vaccinations WHERE id = 7), '2023-01-10', 1, N'Комплексная'),
((SELECT $node_id FROM Pets WHERE id = 10), (SELECT $node_id FROM Vaccinations WHERE id = 1), '2022-08-15', 1, N'Плановая'),
((SELECT $node_id FROM Pets WHERE id = 10), (SELECT $node_id FROM Vaccinations WHERE id = 11), '2022-08-15', 1, N'Комплексная'),
((SELECT $node_id FROM Pets WHERE id = 11), (SELECT $node_id FROM Vaccinations WHERE id = 1), '2023-07-01', 1, N'Плановая'),
((SELECT $node_id FROM Pets WHERE id = 12), (SELECT $node_id FROM Vaccinations WHERE id = 1), '2022-06-10', 2, N'Ревакцинация'),
((SELECT $node_id FROM Pets WHERE id = 12), (SELECT $node_id FROM Vaccinations WHERE id = 2), '2022-06-10', 1, N'Комплексная');
GO

-- 4.3. PerformedBy (Вакцинация -> Ветеринар)
INSERT INTO PerformedBy ($from_id, $to_id, procedure_date, certificate_number)
VALUES
((SELECT $node_id FROM Vaccinations WHERE id = 1), (SELECT $node_id FROM Vets WHERE id = 2), '2023-01-15', N'СЕР-2023-001'),
((SELECT $node_id FROM Vaccinations WHERE id = 7), (SELECT $node_id FROM Vets WHERE id = 2), '2023-01-15', N'СЕР-2023-002'),
((SELECT $node_id FROM Vaccinations WHERE id = 1), (SELECT $node_id FROM Vets WHERE id = 1), '2023-02-10', N'СЕР-2023-003'),
((SELECT $node_id FROM Vaccinations WHERE id = 2), (SELECT $node_id FROM Vets WHERE id = 1), '2023-02-10', N'СЕР-2023-004'),
((SELECT $node_id FROM Vaccinations WHERE id = 11), (SELECT $node_id FROM Vets WHERE id = 1), '2023-02-10', N'СЕР-2023-005'),
((SELECT $node_id FROM Vaccinations WHERE id = 1), (SELECT $node_id FROM Vets WHERE id = 4), '2023-03-05', N'СЕР-2023-006'),
((SELECT $node_id FROM Vaccinations WHERE id = 6), (SELECT $node_id FROM Vets WHERE id = 4), '2023-03-05', N'СЕР-2023-007'),
((SELECT $node_id FROM Vaccinations WHERE id = 1), (SELECT $node_id FROM Vets WHERE id = 7), '2022-12-20', N'СЕР-2022-008'),
((SELECT $node_id FROM Vaccinations WHERE id = 8), (SELECT $node_id FROM Vets WHERE id = 7), '2022-12-20', N'СЕР-2022-009'),
((SELECT $node_id FROM Vaccinations WHERE id = 7), (SELECT $node_id FROM Vets WHERE id = 8), '2023-04-10', N'СЕР-2023-010'),
((SELECT $node_id FROM Vaccinations WHERE id = 1), (SELECT $node_id FROM Vets WHERE id = 5), '2023-05-15', N'СЕР-2023-011'),
((SELECT $node_id FROM Vaccinations WHERE id = 11), (SELECT $node_id FROM Vets WHERE id = 5), '2023-05-15', N'СЕР-2023-012'),
((SELECT $node_id FROM Vaccinations WHERE id = 1), (SELECT $node_id FROM Vets WHERE id = 8), '2023-06-01', N'СЕР-2023-013'),
((SELECT $node_id FROM Vaccinations WHERE id = 1), (SELECT $node_id FROM Vets WHERE id = 2), '2022-10-05', N'СЕР-2022-014'),
((SELECT $node_id FROM Vaccinations WHERE id = 2), (SELECT $node_id FROM Vets WHERE id = 2), '2022-10-05', N'СЕР-2022-015'),
((SELECT $node_id FROM Vaccinations WHERE id = 1), (SELECT $node_id FROM Vets WHERE id = 3), '2023-01-10', N'СЕР-2023-016'),
((SELECT $node_id FROM Vaccinations WHERE id = 7), (SELECT $node_id FROM Vets WHERE id = 3), '2023-01-10', N'СЕР-2023-017'),
((SELECT $node_id FROM Vaccinations WHERE id = 1), (SELECT $node_id FROM Vets WHERE id = 6), '2022-08-15', N'СЕР-2022-018'),
((SELECT $node_id FROM Vaccinations WHERE id = 11), (SELECT $node_id FROM Vets WHERE id = 6), '2022-08-15', N'СЕР-2022-019'),
((SELECT $node_id FROM Vaccinations WHERE id = 1), (SELECT $node_id FROM Vets WHERE id = 9), '2023-07-01', N'СЕР-2023-020'),
((SELECT $node_id FROM Vaccinations WHERE id = 1), (SELECT $node_id FROM Vets WHERE id = 10), '2022-06-10', N'СЕР-2022-021'),
((SELECT $node_id FROM Vaccinations WHERE id = 2), (SELECT $node_id FROM Vets WHERE id = 10), '2022-06-10', N'СЕР-2022-022');
GO

-- 4.4. Referral (Ветеринар -> Владелец)
INSERT INTO Referral ($from_id, $to_id, referral_date, reason)
VALUES
((SELECT $node_id FROM Vets WHERE id = 2),  (SELECT $node_id FROM Owners WHERE id = 1), '2023-01-15', N'Плановый осмотр питомца'),
((SELECT $node_id FROM Vets WHERE id = 1),  (SELECT $node_id FROM Owners WHERE id = 2), '2023-02-10', N'Вакцинация собаки'),
((SELECT $node_id FROM Vets WHERE id = 4),  (SELECT $node_id FROM Owners WHERE id = 3), '2023-03-05', N'Дерматологическая консультация'),
((SELECT $node_id FROM Vets WHERE id = 7),  (SELECT $node_id FROM Owners WHERE id = 4), '2022-12-20', N'Хирургическая операция'),
((SELECT $node_id FROM Vets WHERE id = 8),  (SELECT $node_id FROM Owners WHERE id = 3), '2023-04-10', N'Вакцинация котёнка'),
((SELECT $node_id FROM Vets WHERE id = 5),  (SELECT $node_id FROM Owners WHERE id = 5), '2023-05-15', N'Офтальмологический осмотр'),
((SELECT $node_id FROM Vets WHERE id = 8),  (SELECT $node_id FROM Owners WHERE id = 6), '2023-06-01', N'Осмотр попугая'),
((SELECT $node_id FROM Vets WHERE id = 2),  (SELECT $node_id FROM Owners WHERE id = 7), '2022-10-05', N'Ревакцинация'),
((SELECT $node_id FROM Vets WHERE id = 3),  (SELECT $node_id FROM Owners WHERE id = 8), '2023-01-10', N'Ортопедическая консультация'),
((SELECT $node_id FROM Vets WHERE id = 6),  (SELECT $node_id FROM Owners WHERE id = 9), '2022-08-15', N'Стоматологическая чистка'),
((SELECT $node_id FROM Vets WHERE id = 9),  (SELECT $node_id FROM Owners WHERE id = 11), '2023-07-01', N'Кардиологическое обследование'),
((SELECT $node_id FROM Vets WHERE id = 10), (SELECT $node_id FROM Owners WHERE id = 10), '2022-06-10', N'Неврологическая консультация');
GO

-- 4.5. ReferredTo (Ветеринар -> Ветеринар)
INSERT INTO ReferredTo ($from_id, $to_id, referral_date, reason)
VALUES
((SELECT $node_id FROM Vets WHERE id = 2), (SELECT $node_id FROM Vets WHERE id = 1),  '2023-02-01', N'Необходимо хирургическое вмешательство'),
((SELECT $node_id FROM Vets WHERE id = 1), (SELECT $node_id FROM Vets WHERE id = 3),  '2023-02-15', N'Сложный перелом, требуется ортопед'),
((SELECT $node_id FROM Vets WHERE id = 2), (SELECT $node_id FROM Vets WHERE id = 4),  '2023-03-01', N'Кожная аллергия'),
((SELECT $node_id FROM Vets WHERE id = 4), (SELECT $node_id FROM Vets WHERE id = 2),  '2023-03-10', N'Общая терапия'),
((SELECT $node_id FROM Vets WHERE id = 5), (SELECT $node_id FROM Vets WHERE id = 9),  '2023-04-01', N'Офтальмология связана с кардиологией'),
((SELECT $node_id FROM Vets WHERE id = 7), (SELECT $node_id FROM Vets WHERE id = 11), '2023-04-15', N'Подозрение на опухоль'),
((SELECT $node_id FROM Vets WHERE id = 8), (SELECT $node_id FROM Vets WHERE id = 5),  '2023-05-01', N'Проблемы со зрением'),
((SELECT $node_id FROM Vets WHERE id = 6), (SELECT $node_id FROM Vets WHERE id = 2),  '2023-05-20', N'Стоматология под наркозом'),
((SELECT $node_id FROM Vets WHERE id = 9), (SELECT $node_id FROM Vets WHERE id = 7),  '2023-06-01', N'Кардиохирургия'),
((SELECT $node_id FROM Vets WHERE id = 10), (SELECT $node_id FROM Vets WHERE id = 9), '2023-06-15', N'Неврология с кардиологическими симптомами'),
((SELECT $node_id FROM Vets WHERE id = 11), (SELECT $node_id FROM Vets WHERE id = 12), '2023-07-01', N'Онкология у экзотического животного'),
((SELECT $node_id FROM Vets WHERE id = 3), (SELECT $node_id FROM Vets WHERE id = 7),  '2023-07-10', N'Ортопедическая операция');
GO

-- ================================================
-- ШАГ 4. ЗАПРОСЫ С ФУНКЦИЕЙ MATCH (5 ЗАПРОСОВ)
-- ================================================

-- 5.1. Найти всех питомцев владельца "Иван Петров"
--      и какие прививки им сделаны (цепочка: Owner -> Pet -> Vaccination)
PRINT N'=== 5.1. Питомцы Ивана Петрова и их прививки ===';
SELECT
    o.name  AS Владелец,
    p.name  AS Питомец,
    p.species AS Вид,
    v.name  AS Прививка,
    vac.vaccination_date AS Дата_прививки,
    vac.dose_number AS Доза
FROM Owners AS o
    , Owns AS ow
    , Pets AS p
    , Vaccinated AS vac
    , Vaccinations AS v
WHERE MATCH(o-(ow)->p-(vac)->v)
  AND o.name = N'Иван Петров';
GO

-- 5.2. Найти всех ветеринаров, которые делали прививки
--      питомцам владельца "Дмитрий Новиков"
--      (цепочка: Owner -> Pet -> Vaccination -> Vet)
PRINT N'=== 5.2. Ветеринары, лечившие питомцев Дмитрия Новикова ===';
SELECT
    o.name  AS Владелец,
    p.name  AS Питомец,
    v.name  AS Прививка,
    vet.name AS Ветеринар,
    pb.procedure_date AS Дата_процедуры
FROM Owners AS o
    , Owns AS ow
    , Pets AS p
    , Vaccinated AS vac
    , Vaccinations AS v
    , PerformedBy AS pb
    , Vets AS vet
WHERE MATCH(o-(ow)->p-(vac)->v-(pb)->vet)
  AND o.name = N'Дмитрий Новиков';
GO

-- 5.3. Найти всех владельцев, чьи питомцы привиты
--      вакциной "Нобивак Rabies"
--      (цепочка: Owner -> Pet -> Vaccination)
PRINT N'=== 5.3. Владельцы, чьи питомцы привиты Нобивак Rabies ===';
SELECT DISTINCT
    o.name  AS Владелец,
    p.name  AS Питомец,
    vac.dose_number AS Доза,
    vac.vaccination_date AS Дата
FROM Owners AS o
    , Owns AS ow
    , Pets AS p
    , Vaccinated AS vac
    , Vaccinations AS v
WHERE MATCH(o-(ow)->p-(vac)->v)
  AND v.name = N'Нобивак Rabies';
GO

-- 5.4. Найти всех питомцев, которым прививку делал
--      "Доктор Васильева" (цепочка: Pet -> Vaccination -> Vet)
PRINT N'=== 5.4. Питомцы, которых вакцинировал Доктор Васильева ===';
SELECT
    p.name  AS Питомец,
    p.species AS Вид,
    v.name  AS Прививка,
    pb.procedure_date AS Дата,
    vet.name AS Ветеринар
FROM Pets AS p
    , Vaccinated AS vac
    , Vaccinations AS v
    , PerformedBy AS pb
    , Vets AS vet
WHERE MATCH(p-(vac)->v-(pb)->vet)
  AND vet.name = N'Доктор Васильева';
GO

-- 5.5. Найти всех владельцев, которых направил
--      "Доктор Смирнов" и их питомцев
--      (цепочка: Vet -> Owner -> Pet)
PRINT N'=== 5.5. Владельцы, направленные Доктором Смирновым, и их питомцы ===';
SELECT
    vet.name AS Ветеринар,
    o.name   AS Владелец,
    p.name   AS Питомец,
    p.species AS Вид,
    ref.referral_date AS Дата_направления,
    ref.reason AS Причина
FROM Vets AS vet
    , Referral AS ref
    , Owners AS o
    , Owns AS ow
    , Pets AS p
WHERE MATCH(vet-(ref)->o-(ow)->p)
  AND vet.name = N'Доктор Смирнов';
GO

-- ================================================
-- ШАГ 5. ЗАПРОСЫ С ФУНКЦИЕЙ SHORTEST_PATH (2 ЗАПРОСА)
-- ================================================

-- 6.1. SHORTEST_PATH с шаблоном "+"
--      Найти кратчайший путь от "Доктора Смирнова" до "Доктора Павлова"
--      через перенаправления между ветеринарами
PRINT N'=== 6.1. Кратчайший путь от Доктора Смирнова до Доктора Павлова (шаблон "+") ===';
SELECT
    vet1.name AS От_врача,
    STRING_AGG(vet2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS Путь_через,
    LAST_VALUE(vet2.name) WITHIN GROUP (GRAPH PATH) AS Конечный_врач
FROM Vets AS vet1
    , ReferredTo FOR PATH AS rt
    , Vets FOR PATH AS vet2
WHERE MATCH(SHORTEST_PATH(vet1(-(rt)->vet2)+))
  AND vet1.name = N'Доктор Смирнов';
GO

-- 6.2. SHORTEST_PATH с шаблоном "{1,5}"
--      Найти кратчайший путь от "Доктора Смирнова" до "Доктора Павлова"
--      с ограничением длины пути от 1 до 5 шагов
PRINT N'=== 6.2. Кратчайший путь от Доктора Смирнова до Доктора Павлова (шаблон "{1,5}") ===';
WITH ShortestPaths AS (
    SELECT
        vet1.name AS От_врача,
        STRING_AGG(vet2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS Путь,
        LAST_VALUE(vet2.name) WITHIN GROUP (GRAPH PATH) AS LastNode
    FROM Vets AS vet1
        , ReferredTo FOR PATH AS rt
        , Vets FOR PATH AS vet2
    WHERE MATCH(SHORTEST_PATH(vet1(-(rt)->vet2){1,5}))
      AND vet1.name = N'Доктор Смирнов'
)
SELECT От_врача, Путь, LastNode AS Конечный_врач
FROM ShortestPaths
WHERE LastNode = N'Доктор Павлов';
GO

PRINT N'=== ГОТОВО: Все скрипты выполнены успешно ===';
GO
