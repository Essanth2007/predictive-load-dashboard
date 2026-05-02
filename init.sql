CREATE DATABASE IF NOT EXISTS Miniproject;
USE Miniproject;

CREATE TABLE IF NOT EXISTS `system_snapshot` (
  `snapshot_id` int NOT NULL AUTO_INCREMENT,
  `captured_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`snapshot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `cpu_metrics` (
  `cpu_id` int NOT NULL AUTO_INCREMENT,
  `snapshot_id` int DEFAULT NULL,
  `cpu_percent` float DEFAULT NULL,
  `user_time` float DEFAULT NULL,
  `system_time` float DEFAULT NULL,
  `idle_time` float DEFAULT NULL,
  `nice_time` float DEFAULT NULL,
  `iowait_time` float DEFAULT NULL,
  `irq_time` float DEFAULT NULL,
  `physical_cores` int DEFAULT NULL,
  `logical_cores` int DEFAULT NULL,
  `current_freq` float DEFAULT NULL,
  `min_freq` float DEFAULT NULL,
  `max_freq` float DEFAULT NULL,
  `load_avg_1` float DEFAULT NULL,
  `load_avg_5` float DEFAULT NULL,
  `load_avg_15` float DEFAULT NULL,
  PRIMARY KEY (`cpu_id`),
  KEY `snapshot_id` (`snapshot_id`),
  CONSTRAINT `cpu_metrics_ibfk_1` FOREIGN KEY (`snapshot_id`) REFERENCES `system_snapshot` (`snapshot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `memory_metrics` (
  `memory_id` int NOT NULL AUTO_INCREMENT,
  `snapshot_id` int DEFAULT NULL,
  `total_ram` bigint DEFAULT NULL,
  `available_ram` bigint DEFAULT NULL,
  `used_ram` bigint DEFAULT NULL,
  `free_ram` bigint DEFAULT NULL,
  `percent_used` float DEFAULT NULL,
  `active` bigint DEFAULT NULL,
  `inactive` bigint DEFAULT NULL,
  `buffers` bigint DEFAULT NULL,
  `cached` bigint DEFAULT NULL,
  `shared` bigint DEFAULT NULL,
  `slab` bigint DEFAULT NULL,
  `swap_total` bigint DEFAULT NULL,
  `swap_used` bigint DEFAULT NULL,
  `swap_free` bigint DEFAULT NULL,
  `swap_percent` float DEFAULT NULL,
  `swap_sin` bigint DEFAULT NULL,
  `swap_sout` bigint DEFAULT NULL,
  PRIMARY KEY (`memory_id`),
  KEY `snapshot_id` (`snapshot_id`),
  CONSTRAINT `memory_metrics_ibfk_1` FOREIGN KEY (`snapshot_id`) REFERENCES `system_snapshot` (`snapshot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `disk_metrics` (
  `disk_id` int NOT NULL AUTO_INCREMENT,
  `snapshot_id` int DEFAULT NULL,
  `total_space` bigint DEFAULT NULL,
  `used_space` bigint DEFAULT NULL,
  `free_space` bigint DEFAULT NULL,
  `percent_used` float DEFAULT NULL,
  `read_count` bigint DEFAULT NULL,
  `write_count` bigint DEFAULT NULL,
  `read_bytes` bigint DEFAULT NULL,
  `write_bytes` bigint DEFAULT NULL,
  `read_time` bigint DEFAULT NULL,
  `write_time` bigint DEFAULT NULL,
  PRIMARY KEY (`disk_id`),
  KEY `snapshot_id` (`snapshot_id`),
  CONSTRAINT `disk_metrics_ibfk_1` FOREIGN KEY (`snapshot_id`) REFERENCES `system_snapshot` (`snapshot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `network_metrics` (
  `network_id` int NOT NULL AUTO_INCREMENT,
  `snapshot_id` int DEFAULT NULL,
  `bytes_sent` bigint DEFAULT NULL,
  `bytes_recv` bigint DEFAULT NULL,
  `packets_sent` bigint DEFAULT NULL,
  `packets_recv` bigint DEFAULT NULL,
  `errin` bigint DEFAULT NULL,
  `errout` bigint DEFAULT NULL,
  `dropin` bigint DEFAULT NULL,
  `dropout` bigint DEFAULT NULL,
  PRIMARY KEY (`network_id`),
  KEY `snapshot_id` (`snapshot_id`),
  CONSTRAINT `network_metrics_ibfk_1` FOREIGN KEY (`snapshot_id`) REFERENCES `system_snapshot` (`snapshot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `system_info` (
  `system_id` int NOT NULL AUTO_INCREMENT,
  `snapshot_id` int DEFAULT NULL,
  `boot_time` bigint DEFAULT NULL,
  `logged_in_users` int DEFAULT NULL,
  `total_processes` int DEFAULT NULL,
  PRIMARY KEY (`system_id`),
  KEY `snapshot_id` (`snapshot_id`),
  CONSTRAINT `system_info_ibfk_1` FOREIGN KEY (`snapshot_id`) REFERENCES `system_snapshot` (`snapshot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `alerts` (
  `alert_id` int NOT NULL AUTO_INCREMENT,
  `snapshot_id` int DEFAULT NULL,
  `metric_type` varchar(20) DEFAULT NULL,
  `metric_value` float DEFAULT NULL,
  `alert_message` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`alert_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
