-- Tạo login và cơ sở dữ liệu
CREATE LOGIN admin WITH PASSWORD='admin', CHECK_POLICY = OFF;
GO
-- Tạo cơ sở dữ liệu
CREATE DATABASE RESTAURANT_MANAGEMENT;
GO
-- Sử dụng cơ sở dữ liệu
USE RESTAURANT_MANAGEMENT;
GO

-- Thay đổi chủ sở hữu của cơ sở dữ liệu
sp_changedbowner 'admin';
GO

-- Xóa các bảng nếu đã tồn tại
DROP TABLE IF EXISTS BILL_DETAIL;
DROP TABLE IF EXISTS MENU_ITEM;
DROP TABLE IF EXISTS DETAIL_CATEGORY;
DROP TABLE IF EXISTS BILL;
DROP TABLE IF EXISTS ASSIGN;
DROP TABLE IF EXISTS USERS;
DROP TABLE IF EXISTS TABLES;
DROP TABLE IF EXISTS RESTAURANT_BRANCH;
DROP TABLE IF EXISTS CATEGORY;
DROP TABLE IF EXISTS ROLE;
GO

SELECT * FROM BILL_DETAIL;
SELECT * FROM MENU_ITEM;
SELECT * FROM DETAIL_CATEGORY;
SELECT * FROM BILL;
SELECT * FROM ASSIGN;
SELECT * FROM USERS;
SELECT * FROM TABLES;
SELECT * FROM RESTAURANT_BRANCH;
SELECT * FROM CATEGORY;
SELECT * FROM ROLE;
GO

-- Tạo bảng ROLE
CREATE TABLE ROLE (
    id INT IDENTITY(0,1) PRIMARY KEY,
    role_name NVARCHAR(30) NOT NULL,
    salary MONEY NOT NULL
);
GO

-- Tạo bảng RESTAURANT_BRANCH
CREATE TABLE RESTAURANT_BRANCH (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    address NVARCHAR(255) NOT NULL,
    phone NVARCHAR(15) NOT NULL,
    img VARCHAR(50)
);
GO

-- Tạo bảng USERS
CREATE TABLE USERS (
    id INT PRIMARY KEY IDENTITY(1,1),
    role_id INT,
    cccd CHAR(12) NOT NULL UNIQUE,
    name NVARCHAR(50) NOT NULL,
    dob DATE,
    gender CHAR(1),
    address NVARCHAR(255),
    phone NVARCHAR(15) NOT NULL UNIQUE,
    password NVARCHAR(20) NOT NULL CHECK (LEN(password) BETWEEN 6 AND 16),
    FOREIGN KEY (role_id) REFERENCES ROLE(id) ON UPDATE CASCADE ON DELETE CASCADE
);
GO

-- Tạo bảng ASSIGN
CREATE TABLE ASSIGN (
    u_id INT,
    branch_id INT,
    PRIMARY KEY (u_id, branch_id),
    UNIQUE (u_id),
    FOREIGN KEY (u_id) REFERENCES USERS(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (branch_id) REFERENCES RESTAURANT_BRANCH(id) ON UPDATE CASCADE ON DELETE CASCADE
);
GO

-- Tạo bảng CATEGORY
CREATE TABLE CATEGORY (
    id INT PRIMARY KEY IDENTITY,
    name NVARCHAR(50) NOT NULL,
    describe NVARCHAR(50) DEFAULT N'this is delicious'
);
GO

-- Tạo bảng DETAIL_CATEGORY
CREATE TABLE DETAIL_CATEGORY (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(50) NOT NULL,
    describe NVARCHAR(50),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES CATEGORY(id)
);
GO

-- Tạo bảng TABLES
CREATE TABLE TABLES (
    id INT PRIMARY KEY IDENTITY(1,1),
    display_name NVARCHAR(10) NOT NULL,
    branch_id INT,
    status INT DEFAULT 0,
    FOREIGN KEY (branch_id) REFERENCES RESTAURANT_BRANCH(id) ON UPDATE CASCADE ON DELETE CASCADE
);
GO

-- Tạo bảng MENU_ITEM
CREATE TABLE MENU_ITEM (
    id INT PRIMARY KEY,
    price MONEY NOT NULL,
    name NVARCHAR(50),
    describe NVARCHAR(255),
    img NVARCHAR(255),
    category_id INT,
    CONSTRAINT fk1 FOREIGN KEY (category_id) REFERENCES DETAIL_CATEGORY(id) ON UPDATE CASCADE ON DELETE CASCADE
);
GO

-- Tạo bảng BILL
CREATE TABLE BILL (
    id INT PRIMARY KEY IDENTITY(1,1),
    checkin_date DATE NOT NULL,
    discount INT DEFAULT 0,
    total MONEY NOT NULL,
    table_id INT,
    status INT NOT NULL,
    FOREIGN KEY (table_id) REFERENCES TABLES(id) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- Tạo bảng BILL_DETAIL
CREATE TABLE BILL_DETAIL (
    id INT PRIMARY KEY IDENTITY(1,1),
    bill_id INT,
    item_id INT,
    quantity INT NOT NULL,
    FOREIGN KEY (bill_id) REFERENCES BILL(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES MENU_ITEM(id) ON UPDATE CASCADE ON DELETE CASCADE
);
GO

-- Chèn dữ liệu vào bảng ROLE
INSERT INTO ROLE (role_name, salary) VALUES
(N'Admin', 30000000),
(N'Quản lý', 20000000),
(N'Nhân viên', 10000000),
(N'Bếp trưởng', 15000000),
(N'Bảo vệ', 4000000),
(N'Phục vụ', 7000000);
GO

-- Chèn dữ liệu vào bảng CATEGORY
INSERT INTO CATEGORY (name, describe) VALUES
(N'Món khai vị', N'Những món ăn nhẹ để bắt đầu bữa ăn'),
(N'Món chính', N'Những món ăn chủ yếu để no bụng'),
(N'Món tráng miệng', N'Những món ăn ngọt để kết thúc bữa ăn'),
(N'Đồ uống', N'Những loại nước giải khát hoặc rượu');
GO

-- Chèn dữ liệu vào bảng RESTAURANT_BRANCH
INSERT INTO RESTAURANT_BRANCH (name, address, phone, img) VALUES
(N'BRANCH 1', N'123 Đường 30/4, Q. Ninh Kiều, TP. Cần Thơ', N'0123456789', 'branch1.jpg'),
(N'BRANCH 2', N'456 Nguyễn Văn Cừ, Q. Bình Thủy, TP. Cần Thơ', N'0987654321', 'branch2.jpg'),
(N'BRANCH 3', N'789 Lê Hồng Phong, Q. Cái Răng, TP. Cần Thơ', N'0123456789', 'branch3.jpg'),
(N'BRANCH 4 in the dark', N'147 Phan Đình Phùng, Q. O Môn, TP. Cần Thơ', N'0987654321', 'branch4.jpg'),
(N'BRANCH 5.', N'258A Nguyễn Văn Linh, Q. Ninh Kiều, TP. Cần Thơ', N'0123456789', 'branch5.jpg');
GO

-- Chèn dữ liệu vào bảng USERS
INSERT INTO USERS (role_id, cccd, name, dob, gender, address, phone, password) VALUES
(0, N'0918199533', N'Nhật Hào', '2003-11-13', N'M', N'123 Trần Hưng Đạo, Quận 1, TP. Hồ Chí Minh', N'0763735467', N'admin123'),
(1, N'0917199533', N'Hoài Thương', '2003-11-13', N'M', N'123 Trần Hưng Đạo, Quận 1, TP. Hồ Chí Minh', N'0123456789', N'user123'),
(2, N'234567890123', N'Đình Thông', '1991-02-02', N'F', N'456 Nguyễn Trãi, Quận 5, TP. Hồ Chí Minh', N'0912345678', N'pass456word'),
(3, N'345678901234', N'Phú Thịnh', '1992-03-03', N'M', N'789 Lê Duẩn, Quận 3, TP. Hồ Chí Minh', N'0965432189', N'securepass'),
(4, N'456789012345', N'Tiến Anh', '1993-04-04', N'F', N'147 Phan Đình Phùng, Quận Phú Nhuận, TP. Hồ Chí Minh', N'0934567890', N'admin@123'),
(5, N'567890123456', N'Nhật Quang', '1994-05-05', N'M', N'258 Nguyễn Văn Cừ, Quận 10, TP. Hồ Chí Minh', N'0978123456', N'userpass123');
GO
select * from USERS;
-- Chèn dữ liệu vào bảng ASSIGN
INSERT INTO ASSIGN (u_id, branch_id) VALUES
(1, 1),
(2, 2),
(3, 1),
(4, 1),
(5, 1),
(6, 1);
GO

-- Chèn dữ liệu vào bảng TABLES
DECLARE @i INT = 1;
WHILE @i <= 20
BEGIN 
    INSERT INTO TABLES (display_name, branch_id) 
    VALUES ('A' + CONVERT(VARCHAR(10), @i), 1),
           ('B' + CONVERT(VARCHAR(10), @i), 2),
           ('C' + CONVERT(VARCHAR(10), @i), 3);
    SET @i = @i + 1;
END
GO

-- Chèn dữ liệu vào bảng DETAIL_CATEGORY
INSERT INTO DETAIL_CATEGORY (describe, name, category_id) VALUES
(N'Các loại bánh ngọt, bánh mặn', N'Món Bánh', 2),
(N'Các món hủ tiếu, bún....', N'Món nước', 2),
(N'Cơm các loại', N'Cơm', 2),
(N'Các loại thịt, hải sản', N'Đồ nướng', 2),
(N'Lẩu các loại', N'Lẩu', 2),
(N'Sữa chua', N'Sữa chua', 3),
(N'Trái cây theo mùa', N'Trái cây', 3),
(N'Pepsi, coca....', N'Nước uống có gas', 4),
(N'Trà sữa', N'Trà sữa', 4),
(N'Nước cam ép, ....', N'Nước trái cây', 4);
GO

-- Chèn dữ liệu vào bảng MENU_ITEM
INSERT INTO MENU_ITEM (id, price, name, describe, category_id, img) VALUES
(1, 50000, N'Bánh mì pate', N'Bánh mì ăn kèm pate và rau sống', 1, 'food.png'),
(2, 35000, N'Bún riêu', N'Bún nước dùng riêu cay nồng', 2, 'food1.png'),
(3, 60000, N'Cơm gà xối mỡ', N'Cơm gà ăn kèm xối mỡ thơm ngon', 3, 'food2.png'),
(4, 80000, N'Sò điệp nướng mỡ hành', N'Sò điệp nướng mỡ hành ngon tuyệt', 4, 'food3.png'),
(5, 50000, N'Lẩu canh chua cá', N'Lẩu canh chua cá hấp dẫn', 5, 'food4.png'),
(6, 15000, N'Sữa chua đào', N'Sữa chua ăn kèm đào tươi', 6, 'food5.png'),
(7, 25000, N'Trái cây hỗn hợp', N'Hỗn hợp trái cây tươi ngon', 7, 'food6.png'),
(8, 10000, N'Pepsi', N'Đồ uống có gas - Pepsi', 8, 'food7.png'),
(9, 20000, N'Trà sữa matcha', N'Trà sữa thơm ngon vị matcha', 9, 'food8.png'),
(10, 30000, N'Nước cam ép', N'Nước trái cây tươi ngon', 10, 'food9.png'),
(11, 45000, N'Bánh tráng trộn', N'Bánh tráng trộn ăn kèm gia vị', 1, 'food10.png'),
(12, 28000, N'Phở bò', N'Phở bò nấu chín với nước dùng đậm đà', 2, 'food11.png'),
(13, 55000, N'Cơm chiên hải sản', N'Cơm chiên hải sản hấp dẫn', 3, 'food12.png'),
(14, 75000, N'Mực nước dừa xanh', N'Mực nước dừa xanh nướng mỡ hành', 4, 'food13.png'),
(15, 48000, N'Lẩu thái', N'Lẩu thái nồng ấm', 5, 'food14.png'),
(16, 18000, N'Sữa chua dâu', N'Sữa chua ăn kèm dâu tươi', 6, 'food15.png'),
(17, 22000, N'Trái cây tươi', N'Hỗn hợp trái cây tươi ngon', 7, 'food16.png'),
(18, 12000, N'Coca Cola', N'Đồ uống có gas - Coca Cola', 8, 'food17.png'),
(19, 21000, N'Trà sữa hòa quyện', N'Trà sữa hòa quyện vị thơm', 9, 'food18.png'),
(20, 32000, N'Nước lựu tươi', N'Nước trái cây lựu tươi ngon', 10, 'food19.png');
GO

-- Step 1: Insert Bills into the BILL table for the past few months
INSERT INTO BILL (checkin_date, discount, total, table_id, status) VALUES
-- January 2025
('2025-01-05', 0, 0, 1, 1), -- Bill 1, Table A1, Branch 1
('2025-01-10', 10, 0, 2, 1), -- Bill 2, Table A2, Branch 1
('2025-01-15', 0, 0, 21, 1), -- Bill 3, Table B1, Branch 2
('2025-01-20', 5, 0, 41, 1), -- Bill 4, Table C1, Branch 3
-- February 2025
('2025-02-01', 0, 0, 1, 1), -- Bill 5, Table A1, Branch 1
('2025-02-07', 0, 0, 3, 1), -- Bill 6, Table A3, Branch 1
('2025-02-14', 15, 0, 22, 1), -- Bill 7, Table B2, Branch 2
('2025-02-20', 0, 0, 42, 1), -- Bill 8, Table C2, Branch 3
-- March 2025
('2025-03-01', 0, 0, 1, 1), -- Bill 9, Table A1, Branch 1
('2025-03-05', 0, 0, 4, 1), -- Bill 10, Table A4, Branch 1
('2025-03-10', 10, 0, 23, 1), -- Bill 11, Table B3, Branch 2
('2025-03-15', 0, 0, 43, 1), -- Bill 12, Table C3, Branch 3
('2025-03-20', 5, 0, 2, 1), -- Bill 13, Table A2, Branch 1
('2025-03-22', 0, 0, 24, 1), -- Bill 14, Table B4, Branch 2
('2025-03-25', 0, 0, 44, 1); -- Bill 15, Table C4, Branch 3
GO

-- Step 2: Insert Bill Details into the BILL_DETAIL table
INSERT INTO BILL_DETAIL (bill_id, item_id, quantity) VALUES
-- Bill 1 (January 5, 2025)
(1, 1, 2), -- 2 Bánh mì pate (50,000 each)
(1, 8, 3), -- 3 Pepsi (10,000 each)
-- Bill 2 (January 10, 2025)
(2, 2, 1), -- 1 Bún riêu (35,000)
(2, 9, 2), -- 2 Trà sữa matcha (20,000 each)
-- Bill 3 (January 15, 2025)
(3, 3, 2), -- 2 Cơm gà xối mỡ (60,000 each)
(3, 10, 1), -- 1 Nước cam ép (30,000)
-- Bill 4 (January 20, 2025)
(4, 4, 1), -- 1 Sò điệp nướng mỡ hành (80,000)
(4, 6, 2), -- 2 Sữa chua đào (15,000 each)
-- Bill 5 (February 1, 2025)
(5, 5, 1), -- 1 Lẩu canh chua cá (50,000)
(5, 8, 4), -- 4 Pepsi (10,000 each)
-- Bill 6 (February 7, 2025)
(6, 12, 2), -- 2 Phở bò (28,000 each)
(6, 18, 2), -- 2 Coca Cola (12,000 each)
-- Bill 7 (February 14, 2025)
(7, 13, 3), -- 3 Cơm chiên hải sản (55,000 each)
(7, 19, 3), -- 3 Trà sữa hòa quyện (21,000 each)
-- Bill 8 (February 20, 2025)
(8, 14, 1), -- 1 Mực nước dừa xanh (75,000)
(8, 7, 2), -- 2 Trái cây hỗn hợp (25,000 each)
-- Bill 9 (March 1, 2025)
(9, 15, 1), -- 1 Lẩu thái (48,000)
(9, 8, 3), -- 3 Pepsi (10,000 each)
-- Bill 10 (March 5, 2025)
(10, 1, 3), -- 3 Bánh mì pate (50,000 each)
(10, 9, 2), -- 2 Trà sữa matcha (20,000 each)
-- Bill 11 (March 10, 2025)
(11, 2, 2), -- 2 Bún riêu (35,000 each)
(11, 10, 2), -- 2 Nước cam ép (30,000 each)
-- Bill 12 (March 15, 2025)
(12, 3, 1), -- 1 Cơm gà xối mỡ (60,000)
(12, 6, 1), -- 1 Sữa chua đào (15,000)
-- Bill 13 (March 20, 2025)
(13, 4, 2), -- 2 Sò điệp nướng mỡ hành (80,000 each)
(13, 7, 1), -- 1 Trái cây hỗn hợp (25,000)
-- Bill 14 (March 22, 2025)
(14, 5, 1), -- 1 Lẩu canh chua cá (50,000)
(14, 18, 2), -- 2 Coca Cola (12,000 each)
-- Bill 15 (March 25, 2025)
(15, 12, 1), -- 1 Phở bò (28,000)
(15, 19, 1); -- 1 Trà sữa hòa quyện (21,000)
GO
-- Tạo stored procedure CalculateBillTotal
CREATE PROC CalculateBillTotal 
    @b_id INT
AS
BEGIN
    DECLARE @total INT;

    SELECT @total = SUM(quantity * price) 
    FROM BILL_DETAIL AS b 
    JOIN MENU_ITEM AS m ON b.item_id = m.id 
    WHERE bill_id = @b_id;
    
    UPDATE BILL 
    SET total = @total 
    WHERE id = @b_id;
END
GO

-- Gọi CalculateBillTotal cho các bill từ 1 đến 15
DECLARE @c INT = 1;
WHILE @c <= 15
BEGIN 
    EXEC CalculateBillTotal @b_id = @c;
    SET @c = @c + 1;
END
GO

-- Tạo stored procedure getBranchID
CREATE PROC getBranchID 
    @user_id INT
AS
BEGIN
    SELECT branch_id 
    FROM ASSIGN 
    WHERE u_id = @user_id;
END
GO

-- Gọi stored procedure getBranchID
EXEC getBranchID @user_id = 1;
GO

-- Tạo stored procedure getTableWithBranch
CREATE PROC getTableWithBranch
    @branch_id INT
AS
BEGIN
    SELECT * 
    FROM TABLES 
    WHERE branch_id = @branch_id;
END
GO

-- Tạo stored procedure getBranchName
CREATE PROC getBranchName
    @user_id INT
AS
BEGIN
    SELECT RESTAURANT_BRANCH.name  
    FROM ASSIGN
    JOIN RESTAURANT_BRANCH ON ASSIGN.branch_id = RESTAURANT_BRANCH.id
    WHERE ASSIGN.u_id = @user_id;
END
GO

-- Tạo stored procedure PAY
CREATE PROCEDURE PAY
    @table_id INT,
    @discount FLOAT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @bill_id INT;
            DECLARE @final_total MONEY;

            IF (@table_id IS NOT NULL)
            BEGIN
                UPDATE TABLES 
                SET status = 0 
                WHERE id = @table_id;

                SELECT @bill_id = id 
                FROM BILL 
                WHERE table_id = @table_id AND status = 0;

                UPDATE BILL 
                SET status = 1 
                WHERE id = @bill_id;
            END
            ELSE
            BEGIN
                SELECT @bill_id = id 
                FROM BILL 
                WHERE table_id IS NULL AND status = 0;

                UPDATE BILL 
                SET status = 1 
                WHERE id = @bill_id;
            END

            SELECT @final_total = total * (1 - @discount / 100) 
            FROM BILL 
            WHERE id = @bill_id;

            UPDATE BILL 
            SET total = @final_total, discount = @discount 
            WHERE id = @bill_id;

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        THROW;
    END CATCH
END
GO

-- Tạo stored procedure ORDER_BILL
CREATE PROC ORDER_BILL
    @table_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO BILL (checkin_date, table_id, total, status) 
            VALUES (GETDATE(), @table_id, 0, 0);

            UPDATE TABLES 
            SET status = 1 
            WHERE id = @table_id;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        THROW;
    END CATCH
END
GO

-- Tạo stored procedure addBillDetail
CREATE PROC addBillDetail
    @bill_id INT, 
    @item_id INT, 
    @quantity INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @isExist INT;
            DECLARE @currentQuantity INT;

            SELECT @isExist = id, @currentQuantity = quantity 
            FROM BILL_DETAIL 
            WHERE bill_id = @bill_id AND item_id = @item_id;

            IF (@isExist > 0)
            BEGIN
                DECLARE @newQuantity INT = @quantity + @currentQuantity;
                IF (@newQuantity > 0)
                BEGIN
                    UPDATE BILL_DETAIL 
                    SET quantity = @newQuantity 
                    WHERE bill_id = @bill_id AND item_id = @item_id;
                END
                ELSE
                BEGIN
                    DELETE FROM BILL_DETAIL 
                    WHERE bill_id = @bill_id AND item_id = @item_id;
                END
            END
            ELSE
            BEGIN
                IF (@quantity > 0)
                BEGIN
                    INSERT INTO BILL_DETAIL (bill_id, item_id, quantity) 
                    VALUES (@bill_id, @item_id, @quantity);
                END
            END
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        THROW;
    END CATCH
END
GO

-- Tạo stored procedure getBillId
CREATE PROC getBillId
    @table_id INT
AS
BEGIN
    IF (@table_id IS NOT NULL)
    BEGIN
        SELECT * 
        FROM BILL 
        WHERE status = 0 AND table_id = @table_id;
    END
    ELSE
    BEGIN
        SELECT * 
        FROM BILL 
        WHERE status = 0 AND table_id IS NULL;
    END
END
GO

-- Tạo stored procedure changeTable
CREATE PROC changeTable
    @table1 INT, 
    @table2 INT
AS 
BEGIN 
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @bill1 INT, @bill2 INT;

            SELECT @bill1 = id 
            FROM BILL 
            WHERE status = 0 AND table_id = @table1;

            SELECT @bill2 = id 
            FROM BILL 
            WHERE status = 0 AND table_id = @table2;

            IF (@bill1 IS NOT NULL AND @bill2 IS NULL)
            BEGIN
                UPDATE BILL 
                SET table_id = @table2 
                WHERE id = @bill1;

                UPDATE TABLES 
                SET status = 1 
                WHERE id = @table2;

                UPDATE TABLES 
                SET status = 0 
                WHERE id = @table1;
            END
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        THROW;
    END CATCH
END
GO