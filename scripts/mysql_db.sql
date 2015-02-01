DROP DATABASE IF EXISTS benchmark;
CREATE DATABASE benchmark;

CREATE TABLE benchmark.`cache` (
  `key` varchar(1024) NOT NULL,
  `value` int(11) NOT NULL,
  PRIMARY KEY (`key`) USING HASH
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
