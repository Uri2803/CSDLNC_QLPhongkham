USE DENTAL

--find an user by username
CREATE OR ALTER PROCEDURE GetUserByUsername
    @UserName NVARCHAR(20)
AS
BEGIN
    SELECT UI.User_ID, UI.UserName, [Password], [Email], [RoleName], [Address], [Phone], [Banking]
    FROM [USER] U JOIN [ROLE] R ON U.Role_ID = R.Role_ID JOIN [USER_INFOR] UI ON  UI.UserName = U.UserName
    WHERE UI.UserName = @UserName;
END;
GO


--read an userinfor by userId
CREATE OR ALTER PROCEDURE ReadUserInfoByUserId
    @UserID VARCHAR(5)
AS
BEGIN
    SELECT *
    FROM [USER_INFOR] UI
    JOIN [USER] U ON  U.UserName = UI.UserName
    JOIN [ROLE] R ON R.Role_ID = U.Role_ID
    WHERE UI.User_ID = @UserID;
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


--get dentist's schedule by id
CREATE OR ALTER PROCEDURE GetDoctorSchedule
    @Dentist_ID VARCHAR(5)
AS
BEGIN
    SELECT *
    FROM [SCHEDULE] SD
    JOIN [SHIFT] S ON S.Shift_ID = SD.Shift_ID
    WHERE [Dentist_ID] = @Dentist_ID AND SD.[Status] = 0; 
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
    JOIN [SHIFT] S ON S.Shift_ID = @Ship_ID
    WHERE SD.[Day] = @Date;
    SELECT @KT = [Status] FROM [SCHEDULE] WHERE [Schedule_ID] = @SdID
    IF @KT = 1
        RETURN -1; 
    ELSE
    BEGIN
        UPDATE [SCHEDULE]
        SET [Status] = 1
        WHERE [Schedule_ID] = @SdID;
        SET @Month = MONTH(GETDATE());
        SET @ID = @Month +'T' + RIGHT('000' + CAST((SELECT COUNT(*) FROM [APPOINTMENT] WHERE MONTH(@Date) = @Month) + 1 AS VARCHAR(3)), 3);
        INSERT INTO [APPOINTMENT] ([Appointment_ID], [Customer_ID], Schedule_ID, [Day])
        VALUES (@ID, @Customer_ID, @SdID, @Date);
        RETURN 1;
    END
END;
GO




CREATE OR ALTER PROCEDURE AddSchedule
AS
BEGIN
    DECLARE @StartDate DATE = GETDATE(); 
    DECLARE @EndDate DATE = DATEADD(DAY, 7, @StartDate);
    DECLARE @DentistCursor CURSOR;
    SET @DentistCursor = CURSOR FOR SELECT [Dentist_ID] FROM [DENTIST];
    OPEN @DentistCursor;
    FETCH NEXT FROM @DentistCursor INTO @Dentist_ID;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @CurrentDate DATETIME = @StartDate;

        WHILE @CurrentDate < @EndDate
        BEGIN
            DECLARE @IDSD VARCHAR(5);
            SET @IDSD = 'SD' + RIGHT('000' + CAST((SELECT COUNT(*) FROM [SCHEDULE] WHERE [DAY] = @CurrentDate) + 1 AS VARCHAR(3)), 3);

            -- Kiểm tra xem lịch đã tồn tại hay chưa
            IF NOT EXISTS (SELECT 1 FROM [SCHEDULE] WHERE [Schedule_ID] = @IDSD AND [Day] = @CurrentDate)
            BEGIN
                DECLARE @ShiftCursor CURSOR;
                SET @ShiftCursor = CURSOR FOR SELECT [Shift_ID] FROM [SHIFT];

                OPEN @ShiftCursor;
                FETCH NEXT FROM @ShiftCursor INTO @Shift_ID;

                WHILE @@FETCH_STATUS = 0
                BEGIN
                    INSERT INTO [SCHEDULE] ([Schedule_ID], [Day], [Dentist_ID], [Shift_ID], [Status])
                    VALUES (@IDSD , @CurrentDate, @Dentist_ID, @Shift_ID, 0); 

                    FETCH NEXT FROM @ShiftCursor INTO @Shift_ID;
                END

                CLOSE @ShiftCursor;
                DEALLOCATE @ShiftCursor;
            SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
        END

        FETCH NEXT FROM @DentistCursor INTO @Dentist_ID;
    END

    CLOSE @DentistCursor;
    DEALLOCATE @DentistCursor;

END;



------------------------------------------------------------------------------




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

--update an user info by username
CREATE OR ALTER PROCEDURE UpdateUserInfo
    @UserId VARCHAR(5),
    @UserName NVARCHAR(20),
    @NewFullName NVARCHAR(50),
    @NewBirthDay DATETIME,
    @NewSex NVARCHAR(3),
    @NewAddress VARCHAR(100),
    @NewPhone CHAR(10),
    @NewBanking NVARCHAR(20)
AS
BEGIN
    DECLARE @NewAge INT
    SET @NewAge = DATEDIFF(YEAR, @NewBirthDay, GETDATE())
    UPDATE [USER_INFOR]
    SET [FullName] = @NewFullName, [BirthDay] = @NewBirthDay, [Sex] = @NewSex, [Age] = @NewAge, [Address] = @NewAddress, [Phone] = @NewPhone, [Banking] = @NewBanking
    WHERE [USER_ID] = @UserId;
END;
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

