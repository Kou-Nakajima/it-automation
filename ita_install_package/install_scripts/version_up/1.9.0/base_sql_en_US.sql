ALTER TABLE A_ACCOUNT_LIST ADD COLUMN PW_EXPIRATION INT AFTER PROVIDER_USER_ID;
ALTER TABLE A_ACCOUNT_LIST ADD COLUMN DEACTIVATE_PW_CHANGE INT AFTER PW_EXPIRATION;
ALTER TABLE A_ACCOUNT_LIST_JNL ADD COLUMN PW_EXPIRATION INT AFTER PROVIDER_USER_ID;
ALTER TABLE A_ACCOUNT_LIST_JNL ADD COLUMN DEACTIVATE_PW_CHANGE INT AFTER PW_EXPIRATION;


ALTER TABLE C_PATTERN_PER_ORCH ADD COLUMN ANS_ENGINE_VIRTUALENV_NAME VARCHAR (512) AFTER ANS_VIRTUALENV_NAME;
ALTER TABLE C_PATTERN_PER_ORCH_JNL ADD COLUMN ANS_ENGINE_VIRTUALENV_NAME VARCHAR (512) AFTER ANS_VIRTUALENV_NAME;


-- ----Conductor通知先定義
CREATE TABLE C_CONDUCTOR_NOTICE_INFO
(
NOTICE_ID                         INT                        ,

NOTICE_NAME                       VARCHAR (128)              ,

NOTICE_URL                        VARCHAR (512)              ,
HEADER                            VARCHAR (512)              ,
FIELDS                            VARCHAR (4000)             ,
FQDN                              VARCHAR (128)              ,
PROXY_URL                         VARCHAR (128)              ,
PROXY_PORT                        INT                        ,
OTHER                             VARCHAR (256)              ,
SUPPRESS_START                    DATETIME(6)                ,
SUPPRESS_END                      DATETIME(6)                ,

ACCESS_AUTH                       TEXT                       ,
NOTE                              VARCHAR (4000)             , -- 備考
DISUSE_FLAG                       VARCHAR (1)                , -- 廃止フラグ
LAST_UPDATE_TIMESTAMP             DATETIME(6)                , -- 最終更新日時
LAST_UPDATE_USER                  INT                        , -- 最終更新ユーザ

PRIMARY KEY (NOTICE_ID)
)ENGINE = InnoDB, CHARSET = utf8, COLLATE = utf8_bin, ROW_FORMAT=COMPRESSED ,KEY_BLOCK_SIZE=8;

CREATE TABLE C_CONDUCTOR_NOTICE_INFO_JNL
(
JOURNAL_SEQ_NO                    INT                        , -- 履歴用シーケンス
JOURNAL_REG_DATETIME              DATETIME(6)                , -- 履歴用変更日時
JOURNAL_ACTION_CLASS              VARCHAR (8)                , -- 履歴用変更種別

NOTICE_ID                         INT                        ,

NOTICE_NAME                       VARCHAR (128)              ,

NOTICE_URL                        VARCHAR (512)              ,
HEADER                            VARCHAR (512)              ,
FIELDS                            VARCHAR (4000)             ,
FQDN                              VARCHAR (128)              ,
PROXY_URL                         VARCHAR (128)              ,
PROXY_PORT                        INT                        ,
OTHER                             VARCHAR (256)              ,
SUPPRESS_START                    DATETIME(6)                ,
SUPPRESS_END                      DATETIME(6)                ,

ACCESS_AUTH                       TEXT                       ,
NOTE                              VARCHAR (4000)             , -- 備考
DISUSE_FLAG                       VARCHAR (1)                , -- 廃止フラグ
LAST_UPDATE_TIMESTAMP             DATETIME(6)                , -- 最終更新日時
LAST_UPDATE_USER                  INT                        , -- 最終更新ユーザ
PRIMARY KEY(JOURNAL_SEQ_NO)
)ENGINE = InnoDB, CHARSET = utf8, COLLATE = utf8_bin, ROW_FORMAT=COMPRESSED ,KEY_BLOCK_SIZE=8;
-- Conductor通知先定義----


ALTER TABLE C_CONDUCTOR_EDIT_CLASS_MNG ADD COLUMN NOTICE_INFO TEXT AFTER DESCRIPTION;
ALTER TABLE C_CONDUCTOR_EDIT_CLASS_MNG_JNL ADD COLUMN NOTICE_INFO TEXT AFTER DESCRIPTION;


ALTER TABLE C_NODE_EDIT_CLASS_MNG ADD COLUMN END_TYPE INT AFTER POINT_H;
ALTER TABLE C_NODE_EDIT_CLASS_MNG_JNL ADD COLUMN END_TYPE INT AFTER POINT_H;
UPDATE C_NODE_EDIT_CLASS_MNG SET END_TYPE=5;
UPDATE C_NODE_EDIT_CLASS_MNG_JNL SET END_TYPE=5;


ALTER TABLE C_CONDUCTOR_CLASS_MNG ADD COLUMN NOTICE_INFO TEXT AFTER DESCRIPTION;
ALTER TABLE C_CONDUCTOR_CLASS_MNG_JNL ADD COLUMN NOTICE_INFO TEXT AFTER DESCRIPTION;


ALTER TABLE C_NODE_CLASS_MNG ADD COLUMN END_TYPE INT AFTER POINT_H;
ALTER TABLE C_NODE_CLASS_MNG_JNL ADD COLUMN END_TYPE INT AFTER POINT_H;
UPDATE C_NODE_CLASS_MNG SET END_TYPE=5;
UPDATE C_NODE_CLASS_MNG_JNL SET END_TYPE=5;


ALTER TABLE C_CONDUCTOR_INSTANCE_MNG ADD COLUMN I_NOTICE_INFO TEXT AFTER EXEC_LOG;
ALTER TABLE C_CONDUCTOR_INSTANCE_MNG ADD COLUMN NOTICE_LOG VARCHAR(256) AFTER I_NOTICE_INFO;
ALTER TABLE C_CONDUCTOR_INSTANCE_MNG_JNL ADD COLUMN I_NOTICE_INFO TEXT AFTER EXEC_LOG;
ALTER TABLE C_CONDUCTOR_INSTANCE_MNG_JNL ADD COLUMN NOTICE_LOG VARCHAR(256) AFTER I_NOTICE_INFO;


ALTER TABLE C_NODE_INSTANCE_MNG ADD COLUMN END_TYPE INT AFTER EXE_SKIP_FLAG;
ALTER TABLE C_NODE_INSTANCE_MNG_JNL ADD COLUMN END_TYPE INT AFTER EXE_SKIP_FLAG;
UPDATE C_NODE_INSTANCE_MNG SET END_TYPE=5;
UPDATE C_NODE_INSTANCE_MNG_JNL SET END_TYPE=5;


CREATE OR REPLACE VIEW D_ACCOUNT_LIST AS 
SELECT TAB_A.USER_ID              ,
       TAB_A.USERNAME             ,
       TAB_A.PASSWORD             ,
       TAB_A.USERNAME_JP          ,
       TAB_A.MAIL_ADDRESS         ,
       TAB_A.PW_LAST_UPDATE_TIME  ,
       TAB_A.LAST_LOGIN_TIME      ,
       TAB_A.PW_EXPIRATION        ,
       TAB_A.DEACTIVATE_PW_CHANGE ,
       TAB_B.LOCK_ID              ,
       TAB_B.MISS_INPUT_COUNTER   ,
       TAB_B.LOCKED_TIMESTAMP     ,
       CONCAT(TAB_A.USER_ID,':',TAB_A.USERNAME) USER_PULLDOWN,
       TAB_C.USER_JUDGE_ID        ,
       TAB_C.AD_USER_SID          ,
       TAB_A.AUTH_TYPE            ,
       TAB_A.PROVIDER_ID          ,
       TAB_A.PROVIDER_USER_ID     ,
       TAB_A.ACCESS_AUTH          ,
       TAB_C.ACCESS_AUTH AS ACCESS_AUTH_01,
       TAB_A.NOTE                 ,
       TAB_A.DISUSE_FLAG          ,
       TAB_A.LAST_UPDATE_TIMESTAMP,
       TAB_A.LAST_UPDATE_USER
FROM   A_ACCOUNT_LIST TAB_A
LEFT JOIN A_ACCOUNT_LOCK TAB_B ON (TAB_A.USER_ID = TAB_B.USER_ID)
LEFT JOIN A_AD_USER_JUDGEMENT TAB_C ON (TAB_A.USER_ID = TAB_C.ITA_USER_ID)
WHERE  TAB_A.USER_ID > 0;

CREATE OR REPLACE VIEW D_ACCOUNT_LIST_JNL AS 
SELECT TAB_A.JOURNAL_SEQ_NO       ,
       TAB_A.JOURNAL_REG_DATETIME ,
       TAB_A.JOURNAL_ACTION_CLASS ,
       TAB_A.USER_ID              ,
       TAB_A.USERNAME             ,
       TAB_A.PASSWORD             ,
       TAB_A.USERNAME_JP          ,
       TAB_A.MAIL_ADDRESS         ,
       TAB_A.PW_LAST_UPDATE_TIME  ,
       TAB_A.LAST_LOGIN_TIME      ,
       TAB_A.PW_EXPIRATION        ,
       TAB_A.DEACTIVATE_PW_CHANGE ,
       TAB_B.LOCK_ID              ,
       TAB_B.MISS_INPUT_COUNTER   ,
       TAB_B.LOCKED_TIMESTAMP     ,
       CONCAT(TAB_A.USER_ID,':',TAB_A.USERNAME) USER_PULLDOWN,
       TAB_C.USER_JUDGE_ID        ,
       TAB_C.AD_USER_SID          ,
       TAB_A.AUTH_TYPE            ,
       TAB_A.PROVIDER_ID          ,
       TAB_A.PROVIDER_USER_ID     ,
       TAB_A.ACCESS_AUTH          ,
       TAB_C.ACCESS_AUTH AS ACCESS_AUTH_01,
       TAB_A.NOTE                 ,
       TAB_A.DISUSE_FLAG          ,
       TAB_A.LAST_UPDATE_TIMESTAMP,
       TAB_A.LAST_UPDATE_USER
FROM   A_ACCOUNT_LIST_JNL TAB_A
LEFT JOIN A_ACCOUNT_LOCK TAB_B ON (TAB_A.USER_ID = TAB_B.USER_ID)
LEFT JOIN A_AD_USER_JUDGEMENT TAB_C ON (TAB_A.USER_ID = TAB_C.ITA_USER_ID)
WHERE  TAB_A.USER_ID > 0;


CREATE OR REPLACE VIEW D_CMDB_MENU_LIST_SHEET_TYPE_1 AS
SELECT
 *
FROM D_CMDB_MENU_LIST TAB_A
WHERE (SHEET_TYPE IS NULL OR SHEET_TYPE = 1 OR SHEET_TYPE = 4)
;

CREATE OR REPLACE VIEW D_CMDB_MENU_LIST_SHEET_TYPE_1_JNL AS
SELECT
 *
FROM D_CMDB_MENU_LIST_JNL TAB_A
WHERE (SHEET_TYPE IS NULL OR SHEET_TYPE = 1 OR SHEET_TYPE = 4)
;

CREATE OR REPLACE VIEW D_CMDB_MG_MU_COL_LIST_SHEET_TYPE_1 AS
SELECT
 *
FROM D_CMDB_MG_MU_COL_LIST TAB_A
WHERE (SHEET_TYPE IS NULL OR SHEET_TYPE = 1 OR SHEET_TYPE = 4)
;

CREATE OR REPLACE VIEW D_CMDB_MG_MU_COL_LIST_SHEET_TYPE_1_JNL AS
SELECT
 *
FROM D_CMDB_MG_MU_COL_LIST_JNL TAB_A
WHERE (SHEET_TYPE IS NULL OR SHEET_TYPE = 1 OR SHEET_TYPE = 4)
;

CREATE OR REPLACE VIEW D_CMDB_MENU_COLUMN_SHEET_TYPE_1 AS
SELECT
  TAB_B.*,
  TAB_A.ACCESS_AUTH AS ACCESS_AUTH_01   ,
  TAB_A.ACCESS_AUTH_01 AS ACCESS_AUTH_02,
  TAB_A.ACCESS_AUTH_02 AS ACCESS_AUTH_03
FROM
  D_CMDB_MENU_LIST_SHEET_TYPE_1         TAB_A
  LEFT JOIN B_CMDB_MENU_COLUMN TAB_B ON (TAB_A.MENU_ID = TAB_B.MENU_ID)
WHERE
  TAB_B.DISUSE_FLAG = '0'
;

CREATE OR REPLACE VIEW D_CMDB_MENU_COLUMN_SHEET_TYPE_1_JNL AS
SELECT
  TAB_B.*,
  TAB_A.ACCESS_AUTH AS ACCESS_AUTH_01   ,
  TAB_A.ACCESS_AUTH_01 AS ACCESS_AUTH_02,
  TAB_A.ACCESS_AUTH_02 AS ACCESS_AUTH_03
FROM
  D_CMDB_MENU_LIST_SHEET_TYPE_1_JNL         TAB_A
  LEFT JOIN B_CMDB_MENU_COLUMN_JNL TAB_B ON (TAB_A.MENU_ID = TAB_B.MENU_ID)
WHERE
  TAB_B.DISUSE_FLAG = '0'
;

CREATE OR REPLACE VIEW D_CMDB_MENU_COLUMN_SHEET_TYPE_1_PIONEER AS
SELECT
  TAB_B.*,
  TAB_A.ACCESS_AUTH AS ACCESS_AUTH_01,
  TAB_A.ACCESS_AUTH_01 AS ACCESS_AUTH_02,
  TAB_A.ACCESS_AUTH_02 AS ACCESS_AUTH_03
FROM
  D_CMDB_MENU_LIST_SHEET_TYPE_1         TAB_A
  LEFT JOIN B_CMDB_MENU_COLUMN TAB_B ON (TAB_A.MENU_ID = TAB_B.MENU_ID)
WHERE
  TAB_B.COL_CLASS   <>  'MultiTextColumn' AND
  TAB_B.DISUSE_FLAG = '0'
;

CREATE OR REPLACE VIEW D_CMDB_MENU_COLUMN_SHEET_TYPE_1_PIONEER_JNL AS
SELECT
  TAB_B.*,
  TAB_A.ACCESS_AUTH AS ACCESS_AUTH_01,
  TAB_A.ACCESS_AUTH_01 AS ACCESS_AUTH_02,
  TAB_A.ACCESS_AUTH_02 AS ACCESS_AUTH_03
FROM
  D_CMDB_MENU_LIST_SHEET_TYPE_1_JNL         TAB_A
  LEFT JOIN B_CMDB_MENU_COLUMN_JNL TAB_B ON (TAB_A.MENU_ID = TAB_B.MENU_ID)
WHERE
  TAB_B.COL_CLASS   <>  'MultiTextColumn' AND
  TAB_B.DISUSE_FLAG = '0'
;

CREATE OR REPLACE VIEW D_CMDB_MENU_LIST_SHEET_TYPE_1_PIONEER AS
SELECT 
  TBL_A.*
FROM 
  D_CMDB_MENU_LIST_SHEET_TYPE_1 TBL_A
WHERE
  (SELECT 
     COUNT(*) 
   FROM 
     B_CMDB_MENU_COLUMN TBL_B
   WHERE
     TBL_A.MENU_ID     =   TBL_B.MENU_ID     AND
     TBL_B.COL_CLASS   <>  'MultiTextColumn' AND
     TBL_B.DISUSE_FLAG =   '0'
  ) <> 0 
;

CREATE OR REPLACE VIEW D_CMDB_MENU_LIST_SHEET_TYPE_1_PIONEER_JNL AS
SELECT 
  TBL_A.*
FROM 
  D_CMDB_MENU_LIST_SHEET_TYPE_1_JNL TBL_A
WHERE
  (SELECT 
     COUNT(*) 
   FROM 
     B_CMDB_MENU_COLUMN_JNL TBL_B
   WHERE
     TBL_A.MENU_ID     =   TBL_B.MENU_ID     AND
     TBL_B.COL_CLASS   <>  'MultiTextColumn' AND
     TBL_B.DISUSE_FLAG =   '0'
  ) <> 0
;


INSERT INTO A_SEQUENCE (NAME,VALUE,MENU_ID,DISP_SEQ,NOTE,LAST_UPDATE_TIMESTAMP) VALUES('C_CONDUCTOR_NOTICE_INFO_RIC',1,'2100180012',2100150015,NULL,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'));

INSERT INTO A_SEQUENCE (NAME,VALUE,MENU_ID,DISP_SEQ,NOTE,LAST_UPDATE_TIMESTAMP) VALUES('C_CONDUCTOR_NOTICE_INFO_JSQ',1,'2100180012',2100150016,'履歴テーブル用',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'));


UPDATE A_SYSTEM_CONFIG_LIST SET NOTE=CONCAT('Time period (seconds) to maintain authentication (session) at the time of no operation','\n','Positive number (integer only): Same as above','\n','(However, this value is less than the value specified in "session.gc_maxlifetime" of php.ini)','\n','Zero: disable','\n','Negative numbers or non-integer values: 3600') WHERE ITEM_ID=2100000008;
UPDATE A_SYSTEM_CONFIG_LIST SET NOTE=CONCAT('Maximum time period (seconds) to maintain authentication (session)','\n','Positive number (integer only): Same as above','\n','(However, this value is less than the value specified in "session.gc_maxlifetime" of php.ini)','\n','Zero: disable','\n','Negative numbers or non-integer values: 86400') WHERE ITEM_ID=2100000009;
UPDATE A_SYSTEM_CONFIG_LIST SET NOTE=CONCAT('Screen design settings','\n','The screen design can be changed by specifying the setting value to one of the following keys.','\n','If there is no input or the setting value is incorrect, it is automatically selected by default.','\n','  default(Initial design based on blue)','\n','  red(Design based on  red)','\n','  green(Design based on green)','\n','  blue(Design based on blue)','\n','  orange(Design based on orange)','\n','  yellow(Design based on yellow)','\n','  purple(Design based on purple)','\n','  brown(Design based on brown)','\n','  gray(Design based on gray)','\n','  cool(Design based on cool colors)','\n','  cute(Design based on pink)','\n','  natural(Design inspired by nature)','\n','  gorgeous(Gorgeous design based on red and black)','\n','  oase(ExastroOASE-inspired design)','\n','  epoch(ExastroEPOCH-inspired design)','\n','  darkmode(Dark design ideal for nighttime)') WHERE ITEM_ID=2100000010;
UPDATE A_SYSTEM_CONFIG_LIST_JNL SET NOTE=CONCAT('Time period (seconds) to maintain authentication (session) at the time of no operation','\n','Positive number (integer only): Same as above','\n','(However, this value is less than the value specified in "session.gc_maxlifetime" of php.ini)','\n','Zero: disable','\n','Negative numbers or non-integer values: 3600') WHERE ITEM_ID=2100000008;
UPDATE A_SYSTEM_CONFIG_LIST_JNL SET NOTE=CONCAT('Maximum time period (seconds) to maintain authentication (session)','\n','Positive number (integer only): Same as above','\n','(However, this value is less than the value specified in "session.gc_maxlifetime" of php.ini)','\n','Zero: disable','\n','Negative numbers or non-integer values: 86400') WHERE ITEM_ID=2100000009;
UPDATE A_SYSTEM_CONFIG_LIST_JNL SET NOTE=CONCAT('Screen design settings','\n','The screen design can be changed by specifying the setting value to one of the following keys.','\n','If there is no input or the setting value is incorrect, it is automatically selected by default.','\n','  default(Initial design based on blue)','\n','  red(Design based on  red)','\n','  green(Design based on green)','\n','  blue(Design based on blue)','\n','  orange(Design based on orange)','\n','  yellow(Design based on yellow)','\n','  purple(Design based on purple)','\n','  brown(Design based on brown)','\n','  gray(Design based on gray)','\n','  cool(Design based on cool colors)','\n','  cute(Design based on pink)','\n','  natural(Design inspired by nature)','\n','  gorgeous(Gorgeous design based on red and black)','\n','  oase(ExastroOASE-inspired design)','\n','  epoch(ExastroEPOCH-inspired design)','\n','  darkmode(Dark design ideal for nighttime)') WHERE ITEM_ID=2100000010;

INSERT INTO A_SYSTEM_CONFIG_LIST (ITEM_ID,CONFIG_ID,CONFIG_NAME,VALUE,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(2100000012,'ROLE_BUTTON','Show / hide the "Role" button','1',CONCAT('Configures if the "Role" button will be displayed or not. Clicking the "Role" button will display what role the logged in user belongs to.','\n','1: Activated','\n','Other than: Deactivated.'),'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO A_SYSTEM_CONFIG_LIST_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,ITEM_ID,CONFIG_ID,CONFIG_NAME,VALUE,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(-12,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',2100000012,'ROLE_BUTTON','Show / hide the "Role" button','1',CONCAT('Configures if the "Role" button will be displayed or not. Clicking the "Role" button will display what role the logged in user belongs to.','\n','1: Activated','\n','Other than: Deactivated.'),'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);


INSERT INTO A_MENU_LIST (MENU_ID,MENU_GROUP_ID,MENU_NAME,WEB_PRINT_LIMIT,WEB_PRINT_CONFIRM,XLS_PRINT_LIMIT,LOGIN_NECESSITY,SERVICE_STATUS,AUTOFILTER_FLG,INITIAL_FILTER_FLG,DISP_SEQ,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(2100180012,2100090001,'Conductor notification definition',NULL,NULL,NULL,1,0,1,1,15,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO A_MENU_LIST_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,MENU_ID,MENU_GROUP_ID,MENU_NAME,WEB_PRINT_LIMIT,WEB_PRINT_CONFIRM,XLS_PRINT_LIMIT,LOGIN_NECESSITY,SERVICE_STATUS,AUTOFILTER_FLG,INITIAL_FILTER_FLG,DISP_SEQ,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(-326,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',2100180012,2100090001,'Conductor notification definition',NULL,NULL,NULL,1,0,1,1,15,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);


INSERT INTO A_ROLE_MENU_LINK_LIST (LINK_ID,ROLE_ID,MENU_ID,PRIVILEGE,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(2100180012,1,2100180012,1,'System Administrator','0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO A_ROLE_MENU_LINK_LIST_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,LINK_ID,ROLE_ID,MENU_ID,PRIVILEGE,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(-300332,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',2100180012,1,2100180012,1,'System Administrator','0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);


UPDATE A_DEL_OPERATION_LIST SET DATA_PATH_1='/__data_relay_storage__/' WHERE ROW_ID=2100000002;
UPDATE A_DEL_OPERATION_LIST_JNL SET DATA_PATH_1='/__data_relay_storage__/' WHERE ROW_ID=2100000002;

INSERT INTO A_DEL_OPERATION_LIST (ROW_ID,LG_DAYS,PH_DAYS,TABLE_NAME,PKEY_NAME,OPE_ID_COL_NAME,GET_DATA_STRAGE_SQL,DATA_PATH_1,DATA_PATH_2,DATA_PATH_3,DATA_PATH_4,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(2100000024,3600,7200,'C_CONDUCTOR_INSTANCE_MNG','CONDUCTOR_INSTANCE_NO','OPERATION_NO_UAPK','SELECT CONDUCTOR_STORAGE_PATH_ITA AS PATH FROM C_CONDUCTOR_IF_INFO WHERE DISUSE_FLAG=\'0\'','/__data_relay_storage__/',NULL,NULL,NULL,'Conductor execution list','0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO A_DEL_OPERATION_LIST_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,ROW_ID,LG_DAYS,PH_DAYS,TABLE_NAME,PKEY_NAME,OPE_ID_COL_NAME,GET_DATA_STRAGE_SQL,DATA_PATH_1,DATA_PATH_2,DATA_PATH_3,DATA_PATH_4,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(-2100000024,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',2100000024,3600,7200,'C_CONDUCTOR_INSTANCE_MNG','CONDUCTOR_INSTANCE_NO','OPERATION_NO_UAPK','SELECT CONDUCTOR_STORAGE_PATH_ITA AS PATH FROM C_CONDUCTOR_IF_INFO WHERE DISUSE_FLAG=\'0\'','/__data_relay_storage__/',NULL,NULL,NULL,'Conductor execution list','0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);


INSERT INTO A_DEL_FILE_LIST (ROW_ID,DEL_DAYS,TARGET_DIR,TARGET_FILE,DEL_SUB_DIR_FLG,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(2100000332,1,'%%%%%ITA_DIRECTORY%%%%%/ita-root/temp/ansible_driver_temp','*',1,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO A_DEL_FILE_LIST_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,ROW_ID,DEL_DAYS,TARGET_DIR,TARGET_FILE,DEL_SUB_DIR_FLG,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(-2100000332,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',2100000332,1,'%%%%%ITA_DIRECTORY%%%%%/ita-root/temp/ansible_driver_temp','*',1,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);


INSERT INTO B_DP_HIDE_MENU_LIST (HIDE_ID,MENU_ID) VALUES('65','2100080018');


UPDATE B_DP_ABOLISHED_TYPE SET ABOLISHED_TYPE='All records' WHERE ROW_ID=1;
UPDATE B_DP_ABOLISHED_TYPE SET ABOLISHED_TYPE='Exclude discarded records' WHERE ROW_ID=2;


INSERT INTO B_SYM_EXE_STATUS (SYM_EXE_STATUS_ID,SYM_EXE_STATUS_NAME,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(11,'Warning end',NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO B_SYM_EXE_STATUS_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,SYM_EXE_STATUS_ID,SYM_EXE_STATUS_NAME,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(11,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',11,'Warning end',NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
