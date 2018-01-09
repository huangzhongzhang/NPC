CREATE DATABASE IF NOT EXISTS NPC;

CREATE TABLE IF NOT EXISTS NPC.Crontab
(
  id      INT AUTO_INCREMENT
    PRIMARY KEY,
  time    TEXT            NOT NULL
  COMMENT 'crontab 时间',
  command TEXT        NOT NULL
  COMMENT '执行命令',
  stat    INT DEFAULT '1' NOT NULL
  COMMENT '状态',
  comment TEXT        NULL
  COMMENT '备注',
  CONSTRAINT Crontab_id_uindex
  UNIQUE (id)
)
  ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8
  COMMENT 'crontab 插入';

CREATE TABLE IF NOT EXISTS NPC.Information
(
  id      INT AUTO_INCREMENT
  COMMENT 'ID'
    PRIMARY KEY,
  time    TEXT            NOT NULL
  COMMENT 'crontab 时间',
  gnumber INT             NOT NULL
  COMMENT '群号',
  gname   TEXT            NOT NULL
  COMMENT '群组名称
	',
  message TEXT        NOT NULL
  COMMENT '要发送的信息',
  stat    INT DEFAULT '1' NOT NULL
  COMMENT '状态',
  comment TEXT            NULL
  COMMENT '备注',
  CONSTRAINT Information_id_uindex
  UNIQUE (id)
)
  ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8
  COMMENT '信息发送';

CREATE TABLE IF NOT EXISTS NPC.KnowledgeBase
(
  id      INT AUTO_INCREMENT
    PRIMARY KEY,
  gname   TEXT        NOT NULL
  COMMENT '群组名称',
  `key`   TEXT        NOT NULL
  COMMENT '关键字',
  value   TEXT        NULL
  COMMENT '回复',
  stat    INT DEFAULT '1' NOT NULL
  COMMENT '状态',
  comment TEXT        NULL
  COMMENT '备注',
  CONSTRAINT KnowledgeBase_id_uindex
  UNIQUE (id)
)
  ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8
  COMMENT '知识库';

CREATE TABLE IF NOT EXISTS NPC.LinuxQuestion
(
  id       INT AUTO_INCREMENT
  COMMENT '编号',
  date     DATE            NOT NULL
  COMMENT '提取时间'
    PRIMARY KEY,
  question TEXT        NOT NULL
  COMMENT '问题',
  answer   TEXT        NOT NULL
  COMMENT '答案',
  stat     INT DEFAULT '0' NOT NULL
  COMMENT '是否已执行',
  CONSTRAINT linux_questions_id_uindex
  UNIQUE (id),
  CONSTRAINT linux_questions_date_uindex
  UNIQUE (date)
)
  ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8
  COMMENT '每日一练';