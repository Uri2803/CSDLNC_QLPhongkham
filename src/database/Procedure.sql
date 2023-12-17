
--read all user
CREATE OR ALTER PROCEDURE ReadUser
AS
BEGIN
    SELECT * FROM [USER];
END;
GO

--find an user by username
CREATE PROCEDURE GetUserByUsername
    @UserName NVARCHAR(20)
AS
BEGIN
    SELECT UI.User_ID, UI.UserName, [Password], [Email], [RoleName]
    FROM [USER] U JOIN [ROLE] R ON U.Role_ID = R.Role_ID JOIN [USER_INFOR] UI ON  UI.UserName = U.UserName
    WHERE UI.UserName = @UserName;
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
    @Age INT
AS
BEGIN
    INSERT INTO [USER_INFOR] ([User_ID], [UserName], [FullName], [BirthDay], [Sex], [Age])
    VALUES (@User_ID, @UserName, @FullName, @BirthDay, @Sex, @Age);
END;
GO

--update an user info by username
CREATE OR ALTER PROCEDURE UpdateUserInfo
    @UserName NVARCHAR(20),
    @NewFullName NVARCHAR(50),
    @NewBirthDay DATETIME,
    @NewSex NVARCHAR(3),
    @NewAge INT
AS
BEGIN
    UPDATE [USER_INFOR]
    SET [FullName] = @NewFullName, [BirthDay] = @NewBirthDay, [Sex] = @NewSex, [Age] = @NewAge
    WHERE [UserName] = @UserName;
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

--get all medicine info
CREATE OR ALTER PROCEDURE GetMedicineInformation
AS
BEGIN
    SELECT *
    FROM [MEDICINE_WAREHOUSES];
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

