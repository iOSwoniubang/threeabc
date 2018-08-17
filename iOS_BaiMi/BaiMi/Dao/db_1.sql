

-- 以--开头的行为注释行,语句间以go隔开(注意：这不是标准的sql格式，如果--写在一行中间将会被当做sql，
-- 必须独立成行,go也必须独立成行
-- please pay attention to above words！！！UTF-8 coding
-- 每次升级请不要在原来的db_*.sql中修改，而是新创建一个文件，把*-info.plist中的数据库版本号dbVersion+1（IOS）
-- 系统中所有的ownerId字段都表示这个记录的拥有者

-- V2.0.0

--查询快件历史记录
DROP TABLE IF EXISTS expressSearchHistory;
CREATE TABLE IF NOT EXISTS expressSearchHistory(
ownerId TEXT,
expressNo TEXT,
companyNo TEXT,
companyName TEXT,
companyLogoUrl TEXT,
searchTime datetime,
PRIMARY KEY (ownerId,expressNo)
)
go


--寄件物品类型
DROP TABLE IF EXISTS articleTypeTable;
CREATE TABLE IF NOT EXISTS articleTypeTable(
no TEXT,
name TEXT,
PRIMARY KEY (no)
)
go


-- 增值服务
-- DROP TABLE IF EXISTS additionServiceTable;
-- CREATE TABLE IF NOT EXISTS additionServiceTable(
-- no  TEXT,
-- descriptin TEXT,
-- feeStr TEXT,
-- PRIMARY KEY (no)
-- )
-- go
