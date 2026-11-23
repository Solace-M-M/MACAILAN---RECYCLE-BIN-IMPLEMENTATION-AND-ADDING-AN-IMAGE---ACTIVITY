-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 23, 2026 at 05:37 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12
-- Sample Full Test Database Version

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `game_studio_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_log`
--

CREATE TABLE `activity_log` (
  `log_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `username` varchar(30) NOT NULL,
  `action` varchar(20) NOT NULL,
  `entity` varchar(20) NOT NULL,
  `entity_id` int(10) UNSIGNED DEFAULT NULL,
  `details` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `activity_log`
--

INSERT INTO `activity_log` (`log_id`, `user_id`, `username`, `action`, `entity`, `entity_id`, `details`, `created_at`) VALUES
(1, 1, 'Prozac', 'REGISTER', 'user', 1, 'New account created for Prozac', '2026-10-31 17:59:08'),
(2, 1, 'Prozac', 'LOGIN', 'user', 1, 'Prozac logged in', '2026-10-31 17:59:29'),
(3, 1, 'Prozac', 'LOGOUT', 'user', 1, 'Prozac logged out', '2026-10-31 18:00:10'),
(4, 1, 'Prozac', 'LOGIN', 'user', 1, 'Prozac logged in', '2026-10-31 18:00:57'),
(5, 1, 'Prozac', 'INSERT', 'studio', 1, 'Registered studio \"Valve\"', '2026-10-31 18:04:17'),
(6, 1, 'Prozac', 'UPDATE', 'studio', 1, 'Updated studio \"Valve\"', '2026-10-31 18:06:50'),
(7, 1, 'Prozac', 'INSERT', 'studio', 2, 'Registered studio \"Delete Studio\"', '2026-10-31 18:09:13'),
(8, 1, 'Prozac', 'DELETE', 'studio', 2, 'Deleted studio \"Delete Studio\" and its 0 game(s)', '2026-10-31 18:09:34'),
(9, 1, 'Prozac', 'INSERT', 'game', 1, 'Added game \"Dota 3\" to studio #1', '2026-10-31 18:12:18'),
(10, 1, 'Prozac', 'UPDATE', 'game', 1, 'Updated game \"Dota 3: The Threequel\"', '2026-10-31 18:13:44'),
(11, 1, 'Prozac', 'DELETE', 'game', 1, 'Deleted game \"Dota 3: The Threequel\" from \"Valve\"', '2026-10-31 18:15:11'),
(12, 1, 'Prozac', 'LOGOUT', 'user', 1, 'Prozac logged out', '2026-10-31 18:15:37'),
(13, 1, 'Prozac', 'LOGIN', 'user', 1, 'Prozac logged in', '2026-11-15 12:10:06'),
(14, 1, 'Prozac', 'LOGOUT', 'user', 1, 'Prozac logged out', '2026-11-15 12:13:35'),
(15, 2, 'DeXiaoRong', 'REGISTER', 'user', 2, 'New account created for DeXiaoRong', '2026-11-15 12:29:02'),
(16, 2, 'DeXiaoRong', 'LOGIN', 'user', 2, 'DeXiaoRong logged in', '2026-11-15 12:29:24'),
(17, 2, 'DeXiaoRong', 'LOGIN', 'user', 2, 'DeXiaoRong logged in', '2026-11-16 11:31:35'),
(18, 2, 'DeXiaoRong', 'INSERT', 'game', 2, 'Added game \"Dota 3\" to studio #1', '2026-11-16 11:32:22'),
(19, 2, 'DeXiaoRong', 'UPDATE', 'game', 2, 'Updated game \"Dota 4\"', '2026-11-16 11:35:48'),
(20, 2, 'DeXiaoRong', 'INSERT', 'game', 3, 'Added game \"Dota 3\" to studio #1', '2026-11-16 11:42:44'),
(21, 1, 'Prozac', 'LOGIN', 'user', 1, 'Prozac logged in', '2026-11-23 12:31:32'),
(22, 1, 'Prozac', 'DELETE', 'studio', 1, 'Deleted studio \"Valve\" and its 2 game(s)', '2026-11-23 12:31:46'),
(23, 1, 'Prozac', 'INSERT', 'studio', 3, 'Registered studio \"Valve\"', '2026-11-23 12:32:16'),
(24, 1, 'Prozac', 'INSERT', 'game', 4, 'Added game \"Dota 3\" to studio #3', '2026-11-23 12:32:41'),
(25, 1, 'Prozac', 'UPDATE', 'game', 4, 'Updated game \"Dota 3\"', '2026-11-23 12:33:10'),
(26, 1, 'Prozac', 'DELETE', 'game', 4, 'Moved game \"Dota 3\" from \"Valve\" to the recycle bin', '2026-11-23 12:33:23'),
(27, 1, 'Prozac', 'RESTORE', 'game', 4, 'Restored game \"Dota 3\" to \"Valve\"', '2026-11-23 12:33:26'),
(28, 1, 'Prozac', 'DELETE', 'game', 4, 'Moved game \"Dota 3\" from \"Valve\" to the recycle bin', '2026-11-23 12:33:41'),
(29, 1, 'Prozac', 'RESTORE', 'game', 4, 'Restored game \"Dota 3\" to \"Valve\"', '2026-11-23 12:33:44'),
(30, 1, 'Prozac', 'LOGOUT', 'user', 1, 'Prozac logged out', '2026-11-23 12:35:09');

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE `games` (
  `game_id` int(10) UNSIGNED NOT NULL,
  `studio_id` int(10) UNSIGNED NOT NULL,
  `title` varchar(100) NOT NULL,
  `genre` varchar(30) NOT NULL,
  `platform` varchar(30) NOT NULL,
  `game_engine` varchar(30) NOT NULL,
  `release_status` varchar(20) NOT NULL DEFAULT 'In Development',
  `price` decimal(8,2) NOT NULL DEFAULT 0.00,
  `release_date` date DEFAULT NULL,
  `date_added` datetime NOT NULL DEFAULT current_timestamp(),
  `added_by` int(10) UNSIGNED DEFAULT NULL,
  `last_updated_by` int(10) UNSIGNED DEFAULT NULL,
  `last_updated` datetime NOT NULL DEFAULT current_timestamp(),
  `image_path` varchar(255) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `games`
--

INSERT INTO `games` (`game_id`, `studio_id`, `title`, `genre`, `platform`, `game_engine`, `release_status`, `price`, `release_date`, `date_added`, `added_by`, `last_updated_by`, `last_updated`, `image_path`, `deleted_at`, `deleted_by`) VALUES
(4, 3, 'Dota 3', 'Action', 'PC', 'Unreal Engine', 'Beta', 0.00, '2000-02-23', '2026-11-23 12:32:41', 1, 1, '2026-11-23 12:33:44', 'uploads/53376b4880d71f2979e940f75616d768.jpg', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `studios`
--

CREATE TABLE `studios` (
  `studio_id` int(10) UNSIGNED NOT NULL,
  `studio_name` varchar(100) NOT NULL,
  `founder_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `country` varchar(60) NOT NULL,
  `year_founded` smallint(5) UNSIGNED NOT NULL,
  `studio_type` varchar(30) NOT NULL,
  `website` varchar(255) DEFAULT NULL,
  `date_added` datetime NOT NULL DEFAULT current_timestamp(),
  `added_by` int(10) UNSIGNED DEFAULT NULL,
  `last_updated_by` int(10) UNSIGNED DEFAULT NULL,
  `last_updated` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `studios`
--

INSERT INTO `studios` (`studio_id`, `studio_name`, `founder_name`, `email`, `country`, `year_founded`, `studio_type`, `website`, `date_added`, `added_by`, `last_updated_by`, `last_updated`) VALUES
(3, 'Valve', 'Gabe Newell', 'gaben@valvesoftware.com', 'New Zealand', 2020, 'AAA', 'https://www.valvesoftware.com/en/', '2026-11-23 12:32:16', 1, 1, '2026-11-23 12:32:16');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `username` varchar(30) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `age` tinyint(3) UNSIGNED NOT NULL,
  `date_registered` datetime NOT NULL DEFAULT current_timestamp(),
  `last_login` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `username`, `email`, `password_hash`, `address`, `age`, `date_registered`, `last_login`) VALUES
(1, 'Lee Marcus', 'Macailan', 'Prozac', 'test@gmail.com', '$2y$10$Mv.OqXDxlUMWK8mb6Evd6eoCkDMxj4xGdk.ogRth2OxpbhAWiYTDC', '123 Test Street', 21, '2026-10-31 17:59:08', '2026-11-23 12:31:32'),
(2, 'Super', 'Idol', 'DeXiaoRong', 'dexiaorong@gmail.com', '$2y$10$QOvIPBhrcrPRCh/OQ1dJwubINStarz6wBHLo0wDAiwcrXkMO3dNXe', '123 Test Street', 30, '2026-11-15 12:29:02', '2026-11-16 11:31:35');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `fk_log_user` (`user_id`);

--
-- Indexes for table `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`game_id`),
  ADD UNIQUE KEY `uq_studio_title` (`studio_id`,`title`),
  ADD KEY `fk_games_added_by` (`added_by`),
  ADD KEY `fk_games_updated_by` (`last_updated_by`),
  ADD KEY `fk_games_deleted_by` (`deleted_by`);

--
-- Indexes for table `studios`
--
ALTER TABLE `studios`
  ADD PRIMARY KEY (`studio_id`),
  ADD UNIQUE KEY `studio_name` (`studio_name`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_studios_added_by` (`added_by`),
  ADD KEY `fk_studios_updated_by` (`last_updated_by`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_log`
--
ALTER TABLE `activity_log`
  MODIFY `log_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `games`
--
ALTER TABLE `games`
  MODIFY `game_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `studios`
--
ALTER TABLE `studios`
  MODIFY `studio_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD CONSTRAINT `fk_log_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `games`
--
ALTER TABLE `games`
  ADD CONSTRAINT `fk_games_added_by` FOREIGN KEY (`added_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_games_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_games_studio` FOREIGN KEY (`studio_id`) REFERENCES `studios` (`studio_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_games_updated_by` FOREIGN KEY (`last_updated_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `studios`
--
ALTER TABLE `studios`
  ADD CONSTRAINT `fk_studios_added_by` FOREIGN KEY (`added_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_studios_updated_by` FOREIGN KEY (`last_updated_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
