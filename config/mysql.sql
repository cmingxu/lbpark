CREATE DATABASE `ruyipark` DEFAULT CHARACTER SET utf8mb4;
use ruyipark;

CREATE TABLE `collection` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `cts` datetime DEFAULT NULL COMMENT '创建时间',
    `uts` datetime DEFAULT NULL COMMENT '修改时间',
    `name` varchar(128) NOT NULL COMMENT '名称',
    `image` varchar(1028) DEFAULT NULL COMMENT '图片列表',
    `latlng` varchar(128) DEFAULT NULL COMMENT '经纬列表',
    `comment` varchar(128) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`id`),
    KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '市场采集信息';

ALTER TABLE collection ADD COLUMN `address` varchar(128) DEFAULT NULL COMMENT '地址' AFTER name,
ADD COLUMN `wgs` varchar(128) DEFAULT NULL COMMENT 'WGS坐标' AFTER latlng,
ADD COLUMN `gcj` varchar(128) DEFAULT NULL COMMENT 'WGS转成的GCJ地址' AFTER wgs,
ADD COLUMN `status` int(2) DEFAULT 0 COMMENT '状态';

ALTER TABLE collection ADD COLUMN `distance` double DEFAULT 0 COMMENT '距离误差';

CREATE TABLE `wy_city_cw` (
    `CI` int(11) NOT NULL COMMENT '城市ID',
    `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '区ID',
    `TITLE` varchar(64) NOT NULL COMMENT '名称',
    `X` double(10,7) DEFAULT 0 COMMENT '经度',
    `Y` double(10,7) DEFAULT 0 COMMENT '纬度',
    PRIMARY KEY (`ID`),
    KEY `idx_ci` (`CI`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '城市信息';

CREATE TABLE `wy_distinct` (
    `DI` int(11) NOT NULL COMMENT '区ID',
    `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '区域ID',
    `TITLE` varchar(64) NOT NULL COMMENT '名称',
    `X` double(10,7) DEFAULT 0 COMMENT '经度',
    `Y` double(10,7) DEFAULT 0 COMMENT '纬度',
    PRIMARY KEY (`ID`),
    KEY `idx_di` (`DI`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '城市信息';

CREATE TABLE `wy_area` (
    `AI` int(11) NOT NULL COMMENT '区域ID',
    `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '停车场ID',
    `TITLE` varchar(64) NOT NULL,
    `ADDR` varchar(64) DEFAULT NULL,
    `AIFTrue` varchar(64) DEFAULT NULL,
    `AIMAGES` varchar(64) DEFAULT NULL,
    `AIsCharges` varchar(64) DEFAULT NULL,
    `AParkColor` varchar(64) DEFAULT NULL,
    `ATScore` varchar(64) DEFAULT NULL,
    `AUTOTYPE_LARGE` varchar(64) DEFAULT NULL,
    `AUTOTYPE_MIDDLE` varchar(64) DEFAULT NULL,
    `AUTOTYPE_SMALL` varchar(64) DEFAULT NULL,
    `CHARGEING_TOP` varchar(64) DEFAULT NULL,
    `DISCOUNT_CARD` varchar(64) DEFAULT NULL,
    `DPrice` varchar(64) DEFAULT NULL,
    `DPriceDay` varchar(64) DEFAULT NULL,
    `DPriceNight` varchar(64) DEFAULT NULL,
    `EQMT_BACKSEARCH` varchar(64) DEFAULT NULL,
    `EQMT_PARKGUIDE` varchar(64) DEFAULT NULL,
    `EQMT_SMARTCARD` varchar(64) DEFAULT NULL,
    `ISALLDAY` varchar(64) DEFAULT NULL,
    `ISBOOKABLE` varchar(64) DEFAULT NULL,
    `ISOPEN` varchar(64) DEFAULT NULL,
    `PAYTYPE_MONTH` varchar(64) DEFAULT NULL,
    `PAYTYPE_TEMP` varchar(64) DEFAULT NULL,
    `PAYTYPE_TIMES` varchar(64) DEFAULT NULL,
    `PAYTYPE_WRONGTIME` varchar(64) DEFAULT NULL,
    `PAYTYPE_YEAR` varchar(64) DEFAULT NULL,
    `PAY_PHONE` varchar(64) DEFAULT NULL,
    `PCOUNT` varchar(64) DEFAULT NULL,
    `SERVICE_CHARGING` varchar(64) DEFAULT NULL,
    `SERVICE_DISABLED` varchar(64) DEFAULT NULL,
    `SERVICE_REPAIR` varchar(64) DEFAULT NULL,
    `SERVICE_STORE` varchar(64) DEFAULT NULL,
    `SERVICE_TRANSFERING` varchar(64) DEFAULT NULL,
    `SERVICE_WASH` varchar(64) DEFAULT NULL,
    `SERVICE_WC` varchar(64) DEFAULT NULL,
    `TCOUNT` varchar(64) DEFAULT NULL,
    `TParkType` varchar(64) DEFAULT NULL,
    `TTYPE` varchar(64) DEFAULT NULL,
    `TTYPEInt` varchar(64) DEFAULT NULL,
    `X` double(10,7) DEFAULT 0,
    `Y` double(10,7) DEFAULT 0,
    `character` varchar(64) DEFAULT NULL,
    `state` varchar(64) DEFAULT NULL,
    `Adistance` double DEFAULT 0,
    `TITLES` varchar(64) DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `idx_ai` (`AI`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '区域信息';

ALTER TABLE `wy_city_cw` ADD INDEX `idx_lat_lng` USING BTREE (`Y`, `X`);
ALTER TABLE `wy_distinct` ADD INDEX `idx_lat_lng` USING BTREE (`Y`, `X`);
ALTER TABLE `wy_area` ADD INDEX `idx_lat_lng` USING BTREE (`Y`, `X`);

CREATE TABLE `wy_area_status` (
    `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `PI` int(11) NOT NULL COMMENT '停车场ID',
    `HOUR` INT(3) DEFAULT NULL,
    `TCOUNT` INT(3) DEFAULT NULL,
    `TIMES` INT(3) DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `idx_pi` (`PI`)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '24小时空位';

CREATE TABLE `park` (
  `id`                    INT(5)      NOT NULL AUTO_INCREMENT COMMENT '停车场ID',
  `sn`                    VARCHAR(16) NOT NULL COMMENT '停车场编号',
  `province`              VARCHAR(8)  NOT NULL COMMENT '省',
  `city`                  VARCHAR(8)  NOT NULL COMMENT '市',
  `district`              VARCHAR(8)  NOT NULL COMMENT '区',
  `name`                  VARCHAR(32) NOT NULL COMMENT '名称',
  `address`               VARCHAR(32) COMMENT '地址',
  `ptype`                 VARCHAR(8)  NOT NULL COMMENT '车场类型',
  `type`                  VARCHAR(8)  NOT NULL COMMENT '类型',
  `type_int`              INT(5)      NOT NULL DEFAULT 0 COMMENT '类型INT',
  `total_count`           INT(3)      COMMENT '总停车位',
  `free_count`            INT(3)      COMMENT '空停车位',
  `gcj_lat`               DOUBLE(10,6) COMMENT '图示坐标纬度',
  `gcj_lng`               DOUBLE(10,6) COMMENT '图示坐标经度',
  `image`                 VARCHAR(32) COMMENT '图片',
  `is_all_day`            INT(1) DEFAULT 0 COMMENT '是否全天',
  `is_only_day`           INT(1) DEFAULT 0 COMMENT '是否白天',
  `day_time_start`        INT(2) COMMENT '白天时间段',
  `day_time_end`          INT(2) COMMENT '白天时间段',
  `day_price`             DOUBLE COMMENT '白天价格（每小时）',
  `day_first_hour_price`  DOUBLE COMMENT '白天第一小时价格',
  `day_second_hour_price` DOUBLE COMMENT '白天一小时后价格',
  `night_time_start`      INT(2) COMMENT '夜晚时间段',
  `night_time_end`        INT(2) COMMENT '夜晚时间段',
  `night_price`           DOUBLE COMMENT '夜晚价格',
  `times_price`           DOUBLE COMMENT '每次价格',
  `service_month`         INT(1) COMMENT '是否包月',
  `month_price`           INT(3) COMMENT '包月价格',
  `service_wash`          INT(1) COMMENT '是否洗车',
  `service_wc`            INT(1) COMMENT '是否有厕所',
  `service_repair`        INT(1) COMMENT '是否修理',
  `service_rent`          INT(1) COMMENT '是否租车',
  `service_rent_company`  VARCHAR(32) COMMENT '租车公司',
  `service_group`         INT(1) COMMENT '是否团购',
  `service_times`         INT(1) COMMENT '是否包次',
  `is_recommend`          INT(1) COMMENT '是否推荐',
  `tips`                  VARCHAR(64) COMMENT '小编按',

  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_sn` (`sn`),
  INDEX `idx_lat_lng` USING BTREE (`gcj_lat`, `gcj_lng`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '车场信息';

CREATE TABLE `park_status` (
  `id`             INT(5) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `park_id`        INT(5) NOT NULL COMMENT '停车场ID',
  `distance`       INT(4) COMMENT '距离',
  `price`          VARCHAR (32) COMMENT '价格',
  `state`          INT(2) COMMENT '状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '车场状态';

CREATE TABLE `park_biz` (
  `id`             INT(5) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `park_id`        INT(5) NOT NULL COMMENT '停车场ID',
  `wgs_lat`        VARCHAR(32) COMMENT '入口wgs坐标',
  `wgs_lng`        VARCHAR(32) COMMENT '入口wgs坐标',
  `contract`       VARCHAR(32) COMMENT '承包',
  `contract_phone` VARCHAR(32) COMMENT '承包人电话',
  `ownership`      VARCHAR(32) COMMENT '性质/归属',
  `owner`          VARCHAR(32) COMMENT '管理',
  `comment`        VARCHAR(256) COMMENT '备注',
  `vindicator`     VARCHAR(32) COMMENT '维护者',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_park_id` (`park_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '区域信息';

CREATE TABLE `sms_code` (
  `id`      INT(5) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `cts`     DATETIME    DEFAULT NULL COMMENT '创建时间',
  `phone`   VARCHAR(32) NOT NULL COMMENT '电话',
  `code`    INT(6)      NOT NULL COMMENT '验证码',
  `expire`  DATETIME    NOT NULL COMMENT '有效期',
  `status`  INT(1)      NOT NULL COMMENT '状态',
  PRIMARY KEY (`id`),
  KEY `idx_phone_status` (`phone`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '验证码';

ALTER TABLE `park` ADD COLUMN `service_coupon` INT(1) COMMENT '是否优惠券' AFTER `service_times`,
ADD COLUMN `service_point` INT(1) COMMENT '是否积分' AFTER `service_coupon`,
ADD COLUMN `night_price_hour` DOUBLE COMMENT '夜晚小时价格' AFTER `night_price`,
ADD COLUMN `is_times` INT(1) COMMENT '是否按次收费' AFTER `is_only_day`,
CHANGE COLUMN `image` `image` VARCHAR(256) COMMENT '图片';

ALTER TABLE `park_status` ADD COLUMN `state_desc` VARCHAR(32) COMMENT '状态描述',
ADD COLUMN `price_desc` VARCHAR(32) COMMENT '价格描述' AFTER `price`,
CHANGE COLUMN `price` `price` DOUBLE COMMENT '价格',
ADD UNIQUE KEY `idx_park_id` (`park_id`);

CREATE TABLE `park_desc` (
  `id`                  INT(5) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `park_id`             INT(5) NOT NULL COMMENT '停车场ID',
  `day_time`            VARCHAR(32) COMMENT '白天时间',
  `night_time`          VARCHAR(32) COMMENT '晚上时间',
  `day_price_desc`      VARCHAR(32) COMMENT '白天价格',
  `all_day_price_desc`  VARCHAR(32) COMMENT '整天价格',
  `night_price_desc`    VARCHAR(32) COMMENT '晚上价格',
  `times_price_desc`    VARCHAR(32) COMMENT '包次价格',
  `month_price_desc`    VARCHAR(32) COMMENT '包月价格',
  `service_wc_desc`     VARCHAR(32) COMMENT '卫生间描述',
  `service_wash_desc`   VARCHAR(32) COMMENT '洗车描述',
  `total_count_desc`    VARCHAR(32) COMMENT '车位数描述',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_park_id` (`park_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '车场描述';

CREATE TABLE `park_fault` (
  `id`                  INT(5) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `cts`                 DATETIME COMMENT '创建时间',
  `park_id`             INT(5) NOT NULL COMMENT '停车场ID',
  `fault`               VARCHAR(256) COMMENT '错误信息',
  PRIMARY KEY (`id`),
  KEY `idx_park_id` (`park_id`),
  KEY `idx_cts` (`cts`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '车场错误信息';

CREATE TABLE `user_token` (
  `id`                  INT(5) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `cts`                 DATETIME COMMENT '创建时间',
  `uts`                 DATETIME COMMENT '修改时间',
  `phone`               VARCHAR(32) NOT NULL COMMENT '用户手机号',
  `token`               VARCHAR(256) COMMENT 'Token',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_phone` (`phone`),
  KEY `idx_cts` (`cts`),
  KEY `idx_token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '用户认证信息';

CREATE TABLE `user_favorite` (
  `id`                  INT(5) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `cts`                 DATETIME COMMENT '创建时间',
  `uts`                 DATETIME COMMENT '修改时间',
  `phone`               VARCHAR(32) NOT NULL COMMENT '用户手机号',
  `park_id`             INT(5) NOT NULL COMMENT 'ParkID',
  `status`              INT(5) DEFAULT 0 COMMENT '状态',
  PRIMARY KEY (`id`),
  KEY `idx_phone_status` (`phone`, `status`),
  KEY `idx_park` (`park_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '用户认证信息';

ALTER TABLE `park` ADD COLUMN `property_one` VARCHAR(32) COMMENT '同一车场';

ALTER TABLE `park_desc` ADD COLUMN `day_price_desc_temp` VARCHAR(32) COMMENT '白天价格', ADD COLUMN `night_price_desc_temp` VARCHAR(32) COMMENT '晚上价格';

ALTER TABLE `park` ADD COLUMN `is_only_service` INT(1) DEFAULT 0 COMMENT '是否只服务';

ALTER TABLE `park_desc` ADD COLUMN `distance_desc` VARCHAR(32) COMMENT '距离';

ALTER TABLE `park` ADD COLUMN `times_price_all_day` DOUBLE COMMENT '全天按次价格' AFTER `times_price`;

