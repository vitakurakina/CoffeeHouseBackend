-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: localhost:3307
-- Время создания: Дек 16 2025 г., 01:29
-- Версия сервера: 10.4.32-MariaDB
-- Версия PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `coffeehouse`
--

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

CREATE TABLE `categories` (
  `id_category` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `categories`
--

INSERT INTO `categories` (`id_category`, `name`) VALUES
(1, 'Кофе'),
(2, 'Чай'),
(3, 'Соки'),
(4, 'Лимонад'),
(5, 'Торт'),
(6, 'Пирог'),
(7, 'Круассан'),
(8, 'Эклеры');

-- --------------------------------------------------------

--
-- Структура таблицы `descriptions`
--

CREATE TABLE `descriptions` (
  `id_description` int(11) NOT NULL,
  `text` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `descriptions`
--

INSERT INTO `descriptions` (`id_description`, `text`) VALUES
(1, 'Ароматный свежесваренный кофе'),
(2, 'Напиток с насыщенным вкусом и бодрящим эффектом'),
(3, 'Чай разных сортов и видов'),
(4, 'Освежающий холодный напиток'),
(5, 'Сладкий десерт, приготовленный по классическому рецепту'),
(6, 'Выпечка с разнообразными начинками'),
(7, 'Свежий круассан с маслом или шоколадом'),
(8, 'Нежный эклер с кремовой начинкой');

-- --------------------------------------------------------

--
-- Структура таблицы `desserts`
--

CREATE TABLE `desserts` (
  `id_dessert` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `id_category` int(11) DEFAULT NULL,
  `id_description` int(11) DEFAULT NULL,
  `id_item_type` int(11) NOT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `is_avalaible` tinyint(1) DEFAULT 1,
  `photo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `desserts`
--

INSERT INTO `desserts` (`id_dessert`, `name`, `id_category`, `id_description`, `id_item_type`, `price`, `is_avalaible`, `photo`) VALUES
(1, 'Шоколадный торт', 5, 5, 2, 250.00, 1, ''),
(2, 'Яблочный пирог', 6, 6, 2, 180.00, 1, ''),
(3, 'Круассан с шоколадом', 7, 7, 2, 120.00, 1, ''),
(4, 'Эклер с ванильным кремом', 8, 8, 2, 130.00, 1, '');

-- --------------------------------------------------------

--
-- Структура таблицы `drinks`
--

CREATE TABLE `drinks` (
  `id_drink` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `id_category` int(11) DEFAULT NULL,
  `id_description` int(11) DEFAULT NULL,
  `id_size` int(11) DEFAULT NULL,
  `id_type` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `is_avalaible` tinyint(1) DEFAULT 1,
  `photo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `drinks`
--

INSERT INTO `drinks` (`id_drink`, `name`, `id_category`, `id_description`, `id_size`, `id_type`, `price`, `is_avalaible`, `photo`) VALUES
(1, 'Эспрессо', 1, 1, 1, 2, 100.00, 1, '\'double_espresso.png\''),
(2, 'Эспрессо', 1, 1, 2, 2, 115.00, 1, '\'double_espresso.png\''),
(3, 'Капучино', 1, 2, 1, 2, 110.00, 1, '\'capuchino.png\''),
(4, 'Капучино', 1, 2, 2, 2, 125.00, 1, '\'capuchino.png\''),
(5, 'Капучино', 1, 2, 3, 2, 150.00, 1, '\'capuchino.png\''),
(6, 'Лимонад Киви-Яблоко', 4, 4, 3, 1, 270.00, 1, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `drinks_sizes`
--

CREATE TABLE `drinks_sizes` (
  `id_size` int(11) NOT NULL,
  `name` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `drinks_sizes`
--

INSERT INTO `drinks_sizes` (`id_size`, `name`) VALUES
(1, 'Маленький'),
(2, 'Средний'),
(3, 'Большой');

-- --------------------------------------------------------

--
-- Структура таблицы `drinks_types`
--

CREATE TABLE `drinks_types` (
  `id_type` int(11) NOT NULL,
  `name` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `drinks_types`
--

INSERT INTO `drinks_types` (`id_type`, `name`) VALUES
(1, 'Холодный'),
(2, 'Горячий');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id_user` int(11) NOT NULL,
  `login` varchar(15) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `qr_token` varchar(65) NOT NULL,
  `bonus_amount` int(11) NOT NULL,
  `is_confirmed` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id_user`, `login`, `email`, `password_hash`, `qr_token`, `bonus_amount`, `is_confirmed`) VALUES
(6, 'vitaliia ', 'talina.krina@gmail.com', 'scrypt:32768:8:1$3AeJqhfcWIxrGxqK$2a327bd85d60255043e91fa59b2defe429b88e621a03daf48605dd8598b54434d555820e1b00704f1963bdcf55ab016c6e3434477f6b2cc3b1bc27af2444c885', '2nTHW8jlNaJ6EGzMKxmr1a0hQW0JKTLlTyKhq4Z4bQz6nP3dMZMQuOcPjjZnC2Sx', 0, 0),
(7, 'login', 'email', 'scrypt:32768:8:1$PfJDq1dBRu8dBLBH$3da219ab0cc0fe53b8e814d1c42b9fe17a158efa91d98656a6391fa458dc7ac141bbe8e76d46feb5c6588ddcf4470a42a042784deff70614def4389d900182b9', 'mh6tg9dp4dRXLGrYVjCsITntVSCDZpQIlPaGkljA78UcfdQj1wJgBmqFXstCv5YN', 0, 0),
(8, '1', '2', 'scrypt:32768:8:1$z7cvlx1Edj7gVBOB$94cac1de8ea11f3c0b46574a6c01b26b367e5b65507fcaf6f8cd16838289546149fea2b6d24f6eec0e388c5677c080470e991bb2658c808adbf1467f0f9bf6ef', 'fSUheC874ESfk2XCPVnYoFWKS0CXGztveu23cOPmP87jbonOv8grzYOg7fSXx2nT', 0, 0);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id_category`);

--
-- Индексы таблицы `descriptions`
--
ALTER TABLE `descriptions`
  ADD PRIMARY KEY (`id_description`);

--
-- Индексы таблицы `desserts`
--
ALTER TABLE `desserts`
  ADD PRIMARY KEY (`id_dessert`),
  ADD KEY `id_category` (`id_category`),
  ADD KEY `id_description` (`id_description`);

--
-- Индексы таблицы `drinks`
--
ALTER TABLE `drinks`
  ADD PRIMARY KEY (`id_drink`),
  ADD KEY `id_category` (`id_category`),
  ADD KEY `id_description` (`id_description`),
  ADD KEY `id_drink_size` (`id_size`),
  ADD KEY `id_drink_type` (`id_type`);

--
-- Индексы таблицы `drinks_sizes`
--
ALTER TABLE `drinks_sizes`
  ADD PRIMARY KEY (`id_size`);

--
-- Индексы таблицы `drinks_types`
--
ALTER TABLE `drinks_types`
  ADD PRIMARY KEY (`id_type`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_user`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `categories`
--
ALTER TABLE `categories`
  MODIFY `id_category` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `descriptions`
--
ALTER TABLE `descriptions`
  MODIFY `id_description` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `desserts`
--
ALTER TABLE `desserts`
  MODIFY `id_dessert` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `drinks`
--
ALTER TABLE `drinks`
  MODIFY `id_drink` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `drinks_sizes`
--
ALTER TABLE `drinks_sizes`
  MODIFY `id_size` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `drinks_types`
--
ALTER TABLE `drinks_types`
  MODIFY `id_type` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `desserts`
--
ALTER TABLE `desserts`
  ADD CONSTRAINT `desserts_ibfk_1` FOREIGN KEY (`id_category`) REFERENCES `categories` (`id_category`),
  ADD CONSTRAINT `desserts_ibfk_2` FOREIGN KEY (`id_description`) REFERENCES `descriptions` (`id_description`);

--
-- Ограничения внешнего ключа таблицы `drinks`
--
ALTER TABLE `drinks`
  ADD CONSTRAINT `drinks_ibfk_1` FOREIGN KEY (`id_category`) REFERENCES `categories` (`id_category`),
  ADD CONSTRAINT `drinks_ibfk_2` FOREIGN KEY (`id_description`) REFERENCES `descriptions` (`id_description`),
  ADD CONSTRAINT `drinks_ibfk_3` FOREIGN KEY (`id_size`) REFERENCES `drinks_sizes` (`id_size`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `drinks_ibfk_4` FOREIGN KEY (`id_type`) REFERENCES `drinks_types` (`id_type`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
