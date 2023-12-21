USE DENTAL

--find an user by username
CREATE OR ALTER PROCEDURE GetUserByUsername
    @UserName NVARCHAR(20)
AS
BEGIN
    SELECT  UI.[User_ID], U.UserName, U.[Password], U.Email, R.Role_ID, R.RoleName
    FROM [USER] U 
    JOIN [ROLE] R ON U.Role_ID = R.Role_ID 
    JOIN [USER_INFOR] UI ON  UI.UserName = U.UserName
    WHERE U.UserName = @UserName;
END;
GO




--Update userinfor

--update an user by username
CREATE OR ALTER PROCEDURE UpdateUserInfor
    @User_ID NVARCHAR(20),
    @FullName NVARCHAR(70),
    @BirthDay DATE,
    @Sex NVARCHAR(3), 
    @Mail VARCHAR(50),
    @Address NVARCHAR(100),
    @Phone CHAR(10),
    @Banking VARCHAR(20)
AS
BEGIN
    IF NOT EXISTS  (SELECT * FROM [USER_INFOR] WHERE [USER_ID] =@User_ID)
    BEGIN
        RAISERROR('Không tồn tại User', 16,1);
        RETURN;
    END
    DECLARE @Username NVARCHAR(20);
    SELECT @Username = UI.UserName FROM [USER_INFOR] UI WHERE UI.[USER_ID] =@User_ID;

    DECLARE @age INT = DATEDIFF(YEAR, @BirthDay, GETDATE());

    UPDATE [USER_INFOR]
    SET 
    [FullName] = @FullName, 
    [BirthDay] = @BirthDay, 
    [Sex] = @Sex,
    [Age] = @age,
    [Address] = @Address, 
    [Phone] =@Phone, 
    [Banking] = @Banking
    WHERE [USER_ID] = @User_ID;

    UPDATE [USER]
    SET [Email] = @Mail
    WHERE [UserName] = @Username;
END;
GO



--read an userinfor by userId
CREATE OR ALTER PROCEDURE ReadUserInfoByUserId
    @UserID VARCHAR(5)
AS
BEGIN
    DECLARE @role INT;
    SELECT @role = U.Role_ID
    FROM [USER_INFOR] UI 
    JOIN [USER] U ON U.UserName = UI.UserName
    WHERE UI.[USER_ID] = @UserID;

    IF @role = 1 --usser
    BEGIN
        SELECT U.Role_ID, UI.*, CI.*
        FROM [USER] U
        JOIN [USER_INFOR] UI ON UI.UserName = U.UserName
        JOIN [CUSTOMER_INFROR] CI ON CI.Customer_ID = UI.User_ID
        WHERE UI.User_ID = @UserID;
    END 

    IF @role = 2 OR @role = 4 -- staft, admin
    BEGIN
        SELECT U.Role_ID, UI.*, CS.*
        FROM [USER] U
        JOIN [USER_INFOR] UI ON UI.UserName = U.UserName
        JOIN [CLINIC_STAFF] CS ON CS.Staff_ID  = UI.User_ID
        WHERE UI.User_ID = @UserID;
    END 

    IF @role = 3 -- dentist
    BEGIN
        SELECT U.Role_ID, UI.*, CS.*, D.*
        FROM [USER] U
        JOIN [USER_INFOR] UI ON UI.UserName = U.UserName
        JOIN [CLINIC_STAFF] CS ON CS.Staff_ID  = UI.User_ID
        JOIN [DENTIST] D ON D.Dentist_ID = CS.Staff_ID
        WHERE UI.User_ID = @UserID;
    END 
END;
GO


--get all medicine info
CREATE OR ALTER PROCEDURE GetMedicineInformation
AS
BEGIN
    SELECT *
    FROM [MEDICINE_WAREHOUSES];
END;
GO

--- add schedule foR dentist
CREATE OR ALTER PROCEDURE AddDentistSchedule
    @DentistID VARCHAR(5),
    @Day DATE
AS
BEGIN
    DECLARE @ScheduleID VARCHAR(5);
    DECLARE @s_shift INT = 1;
    IF EXISTS (SELECT * FROM [SCHEDULE] WHERE [Day] = @Day AND [Dentist_ID] = @DentistID)
       RAISERROR('Lịch đã tồn tại', 16, 1);
    ELSE 
        WHILE @s_shift < 18
        BEGIN 
                SET @ScheduleID = 'SD' + RIGHT('0000' + CAST((SELECT COUNT(*) FROM [SCHEDULE] WHERE [Day] = @Day) + 1 AS NVARCHAR(3)), 3);
                INSERT INTO [SCHEDULE] ([Schedule_ID], [Day], [Dentist_ID], [Shift_ID], [Status])
                VALUES (@ScheduleID, @Day, @DentistID, @s_shift, 0);
                SET @s_shift = @s_shift + 1;
        END
        RETURN 1;
END
GO

--get dentist's schedule by id
CREATE OR ALTER PROCEDURE GetDentistSchedule
    @Dentist_ID VARCHAR(5),
    @Day DATE
AS
BEGIN
    SELECT SD.*, S.Time_Frame
    FROM [SCHEDULE] SD
    JOIN [SHIFT] S ON S.Shift_ID = SD.Shift_ID
    WHERE [Dentist_ID] = @Dentist_ID AND SD.[Status] = 0 AND SD.[Day] =@Day
END;
GO

--add an user
CREATE OR ALTER PROCEDURE AddUser
    @UserName NVARCHAR(20),
    @Password VARCHAR(300),
    @Email VARCHAR(50),
    @Role_ID CHAR(5)
AS
BEGIN
    INSERT INTO [USER] ([UserName], [Password], [Email], [Role_ID])
    VALUES (@UserName, @Password, @Email, @Role_ID);
    DECLARE @ID VARCHAR(5);
    IF @Role_ID = 1 
    BEGIN
        SET @ID = 'U' + RIGHT('0000' + CAST((SELECT COUNT(*) FROM [USER_INFOR] WHERE [USER_ID] LIKE 'U%') + 1 AS NVARCHAR(4)), 4);
        INSERT INTO [USER_INFOR] (User_ID, UserName)
        VALUES (@ID, @UserName);
        INSERT INTO [CUSTOMER_INFROR] ([Customer_ID])
        VALUES (@ID);
    END
    IF @Role_ID = 2
    BEGIN
        SET @ID = 'A' + RIGHT('0000' + CAST((SELECT COUNT(*) FROM [USER_INFOR] WHERE [USER_ID] LIKE 'C%') + 1 AS NVARCHAR(4)), 4);
        INSERT INTO [USER_INFOR] (User_ID, UserName)
        VALUES (@ID, @UserName);
        INSERT INTO [CLINIC_STAFF] ([Staff_ID], [Postition_ID])
        VALUES (@ID, 2);
    END
    IF @Role_ID = 3
    BEGIN
        SET @ID = 'D' + RIGHT('0000' + CAST((SELECT COUNT(*) FROM [USER_INFOR] WHERE [USER_ID] LIKE 'C%') + 1 AS NVARCHAR(4)), 4);
        INSERT INTO [USER_INFOR] (User_ID, UserName)
        VALUES (@ID, @UserName);
        INSERT INTO [CLINIC_STAFF] ([Staff_ID], [Postition_ID])
        VALUES (@ID, 3);
        INSERT INTO [DENTIST] (Dentist_ID)
        VALUES (@ID);
    END
    IF @Role_ID = 4
    BEGIN
        SET @ID = 'S' + RIGHT('0000' + CAST((SELECT COUNT(*) FROM [USER_INFOR] WHERE [USER_ID] LIKE 'S%') + 1 AS NVARCHAR(4)), 4);
        INSERT INTO [USER_INFOR] (User_ID, UserName)
        VALUES (@ID, @UserName);
        INSERT INTO [CLINIC_STAFF] ([Staff_ID], [Postition_ID])
        VALUES (@ID, 1);  
    END
END;
GO

--
CREATE OR ALTER PROCEDURE MakeAppointment
    @Customer_ID VARCHAR(5),
    @Dentist_ID VARCHAR(5),
    @Date DATE,
    @Ship_ID INT
AS
BEGIN
    DECLARE @SdID VARCHAR(5);
    DECLARE @ID VARCHAR(5);
    DECLARE @KT BIT;
    DECLARE @Month VARCHAR(2);
    SELECT @SdID = SD.Schedule_ID
    FROM [SCHEDULE] SD
    JOIN [SHIFT] S ON S.Shift_ID = SD.Shift_ID
    WHERE SD.[Day] = @Date AND S.Shift_ID = @Ship_ID;

    SELECT @KT = [Status] FROM [SCHEDULE] WHERE [Schedule_ID] = @SdID
    IF @KT = 1
    BEGIN
       RAISERROR('Lịch không còn trống', 16,1);
       RETURN;
    END
    ELSE
    BEGIN
        DECLARE @MR_ID VARCHAR(5);
        SET @MR_ID = 'MR' + RIGHT('0000' + CAST((SELECT COUNT(*) FROM [MEDICAL_RECORD]) + 1 AS NVARCHAR(3)), 3);
        INSERT INTO [MEDICAL_RECORD] ([Medical_ID], [Customer_ID], [DentistResponsible], [Day])
        VALUES (@MR_ID, @Customer_ID, @Dentist_ID, @Date);
        UPDATE [SCHEDULE]
        SET [Status] = 1
        WHERE [Schedule_ID] = @SdID;
        SET @Month = MONTH(GETDATE());
        SET @ID = @Month +'T' + RIGHT('000' + CAST((SELECT COUNT(*) FROM [APPOINTMENT] WHERE MONTH(@Date) = @Month) + 1 AS VARCHAR(3)), 3);
        INSERT INTO [APPOINTMENT] ([Appointment_ID], [Customer_ID], Schedule_ID, [Day])
        VALUES (@ID, @Customer_ID, @SdID, @Date);
        RETURN;
    END
END;
GO


CREATE OR ALTER PROCEDURE GetAppointmentCard
    @Customer_ID VARCHAR(5)
AS
BEGIN
    SELECT C.*, D.FullName AS 'Dentist', SD.[Day], S.Shift_ID AS 'STT', S.Time_Frame 'Time'
    FROM [APPOINTMENT] AP 
    JOIN [USER_INFOR] C ON C.User_ID = AP.Customer_ID
    JOIN [SCHEDULE] SD ON SD.Schedule_ID = AP.Schedule_ID
    JOIN [SHIFT] S ON S.Shift_ID = SD.Shift_ID
    JOIN [USER_INFOR] D ON D.User_ID = SD.Dentist_ID
    WHERE AP.Customer_ID = @Customer_ID;
END;

------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX----------------------------------------------------------
------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX----------------------------------------------------------




--read all user
CREATE OR ALTER PROCEDURE ReadUser
AS
BEGIN
    SELECT * FROM [USER];
END;
GO

--update an user by username
CREATE OR ALTER PROCEDURE UpdateUser
    @UserName NVARCHAR(20),
    @NewPassword VARCHAR(150),
    @NewEmail VARCHAR(50),
    @NewRole_ID CHAR(5)
AS
BEGIN
    UPDATE [USER]
    SET [Password] = @NewPassword, [Email] = @NewEmail, [Role_ID] = @NewRole_ID
    WHERE [UserName] = @UserName;
END;
GO

--delete an user by username
CREATE OR ALTER PROCEDURE DeleteUser
    @UserName NVARCHAR(20)
AS
BEGIN
    DELETE FROM [USER] WHERE [UserName] = @UserName;
END;
GO

--read all user info
CREATE OR ALTER PROCEDURE ReadUserInfo
AS
BEGIN
    SELECT * FROM [USER_INFOR];
END;
GO
 
 --add an user info
CREATE OR ALTER PROCEDURE AddUserInfo
    @User_ID CHAR(5),
    @UserName NVARCHAR(20),
    @FullName NVARCHAR(70),
    @BirthDay DATETIME,
    @Sex NVARCHAR(3),
    @Address VARCHAR(100),
    @Phone CHAR(10),
    @Banking NVARCHAR(20)
AS
BEGIN
    DECLARE @Age INT
    SET @Age = DATEDIFF(YEAR, @BirthDay, GETDATE())
    INSERT INTO [USER_INFOR] ([User_ID], [UserName], [FullName], [BirthDay], [Sex], [Age], [Address], [Phone], [Banking]) 
    VALUES (@User_ID, @UserName, @FullName, @BirthDay, @Sex, @Age, @Address, @Phone, @Banking)
END
GO



--delete an user info by username
CREATE OR ALTER PROCEDURE DeleteUserInfo
    @UserName NVARCHAR(20)
AS
BEGIN
    DELETE FROM [USER_INFOR] WHERE [UserName] = @UserName;
END;
GO

--find a dentist by id
CREATE OR ALTER PROCEDURE GetDoctorInformation
    @Dentist_ID VARCHAR(5)
AS
BEGIN
    SELECT *
    FROM [DENTIST]
    WHERE [Dentist_ID] = @Dentist_ID;
END;
GO


--get dentist's schedule by id
CREATE OR ALTER PROCEDURE GetDoctorSchedule
    @Dentist_ID VARCHAR(5)
AS
BEGIN
    SELECT *
    FROM [SCHEDULE]
    WHERE [Dentist_ID] = @Dentist_ID;
END;
GO


--find medicine by name
CREATE OR ALTER PROCEDURE GetMedicineByName
    @MedicineName NVARCHAR(100)
AS
BEGIN
    SELECT *
    FROM [MEDICINE_WAREHOUSES]
    WHERE [MedicineName] = @MedicineName;
END;
GO

--get prescription by customer
CREATE OR ALTER PROCEDURE GetPrescriptionsByCustomerID
    @Customer_ID VARCHAR(5)
AS
BEGIN
    SELECT *
    FROM [MEDICAL_RECORD]
    WHERE [Customer_ID] = @Customer_ID;
END;
GO

-- Calculate Total Payment By Invoice ID
CREATE OR ALTER PROCEDURE CalculateTotalPaymentByInvoiceID
    @Invoice_ID VARCHAR(5)
AS
BEGIN
    SELECT SUM([TotalPayment]) AS TotalPayment
    FROM [PAYMENT_INVOICE]
    WHERE [Invoice_ID] = @Invoice_ID;
END;
GO

-- Get Service Details By Name Or ID
CREATE OR ALTER PROCEDURE GetServiceDetailsByNameOrID
    @ServiceIdentifier NVARCHAR(100)
AS
BEGIN
    SELECT *
    FROM [SERVICE]
    WHERE [Service_ID] = @ServiceIdentifier OR [ServiecName] = @ServiceIdentifier;
END;
GO

-- Get Prescription Details By Prescription ID
CREATE OR ALTER PROCEDURE GetPrescriptionDetailsByPrescriptionID
    @Prescription_ID VARCHAR(5)
AS
BEGIN
    SELECT *
    FROM [PRESCRIPTION_DETAIL]
    WHERE [Prescription_ID] = @Prescription_ID;
END;
GO

-- Get Patients Examined OnDate
CREATE OR ALTER PROCEDURE GetPatientsExaminedOnDate
    @ExaminationDate DATE
AS
BEGIN
    SELECT *
    FROM [MEDICAL_RECORD]
    WHERE CONVERT(DATE, [Day]) = @ExaminationDate;
END;
GO

