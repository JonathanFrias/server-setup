CREATE DATABASE postfix;
USE postfix;

CREATE TABLE `domains` (
  `domain` varchar(50) NOT NULL default "",
  PRIMARY KEY  (`domain`),
  UNIQUE KEY `domain` (`domain`)
);

CREATE TABLE `forwardings` (
  `source` varchar(80) NOT NULL default "",
  `destination` text NOT NULL,
  PRIMARY KEY  (`source`)
);

CREATE TABLE `users` (
  `email` varchar(80) NOT NULL default "",
  `password` varchar(20) NOT NULL default "",
  `quota` varchar(20) NOT NULL default '20971520',
  `domain` varchar(255) NOT NULL default "",
  UNIQUE KEY `email` (`email`)
);

CREATE USER 'postfixuser';
GRANT SELECT, INSERT, UPDATE, DELETE ON domains TO postfixuser;
GRANT SELECT, INSERT, UPDATE, DELETE ON forwardings TO postfixuser;
GRANT SELECT, INSERT, UPDATE, DELETE ON users TO postfixuser;

INSERT INTO `domains` VALUES ('gofrias.com');

INSERT INTO `users` VALUES ('jonathan@gofrias.com', 'secret', 
'20971520', 'gofrias.com');
FLUSH PRIVILEGES;
