-- Run this ONCE in phpMyAdmin (SQL tab) on your EXISTING game_studio_db.
-- (A fresh install using schema.sql already includes these columns.)
USE game_studio_db;

ALTER TABLE games
    ADD COLUMN image_path VARCHAR(255) NULL AFTER last_updated,
    ADD COLUMN deleted_at DATETIME     NULL AFTER image_path,
    ADD COLUMN deleted_by INT UNSIGNED NULL AFTER deleted_at,
    ADD CONSTRAINT fk_games_deleted_by FOREIGN KEY (deleted_by) REFERENCES users (user_id) ON DELETE SET NULL;
