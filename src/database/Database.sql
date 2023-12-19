USE [master]
GO

IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'DENTAL')
BEGIN    
    DROP DATABASE DENTAL;
END;
GO

CREATE DATABASE [DENTAL] 
GO

USE [DENTAL]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ROLE] (
  [Role_ID] INT PRIMARY KEY,
  [RoleName] NVARCHAR(20),
  [RoleDescription] NVARCHAR(100)
)
GO

CREATE TABLE [USER] (
  [UserName] NVARCHAR(20) PRIMARY KEY,
  [Password] VARCHAR(150),
  [Email] VARCHAR(50),
  [Role_ID] INT
)
GO

CREATE TABLE [USER_INFOR] (
  [User_ID] VARCHAR(5) PRIMARY KEY,
  [UserName] NVARCHAR(20),
  [FullName] NVARCHAR(70),
  [BirthDay] DATETIME,
  [Sex] NVARCHAR(3),
  [Age] INT,
  [Address] VARCHAR(100),
  [Phone] CHAR(10),
  [Banking] NVARCHAR(20)
)
GO

CREATE TABLE [CUSTOMER_INFROR] (
  [Customer_ID] VARCHAR(5) PRIMARY KEY,
  [RecentDateMedicalExam] DATETIME,
  [ReDateMedicalExam] DATETIME,
  [MedicalHistory] TEXT
)
GO

CREATE TABLE [POSTITION] (
  [Postition_ID] INT PRIMARY KEY,
  [PostitionName] NVARCHAR(50)
)
GO

CREATE TABLE [CLINIC_STAFF] (
  [Staff_ID] VARCHAR(5) PRIMARY KEY,
  [Salary] INT,
  [Postition_ID] INT
)
GO

CREATE TABLE [SHIFT] (
  [Shift_ID] VARCHAR(5) PRIMARY KEY,
  [Time_Frame] VARCHAR(15)
)
GO

CREATE TABLE [SCHEDULE] (
  [Schedule_ID] VARCHAR(5),
  [Day] DATETIME,
  [Dentist_ID] VARCHAR(5),
  [Shift_ID] VARCHAR(5),
  [Status] BIT,
  PRIMARY KEY ([Schedule_ID], [Day])
)
GO

CREATE TABLE [APPOINTMENT] (
  [Appointment_ID] VARCHAR(5) PRIMARY KEY,
  [Customer_ID] VARCHAR(5),
  [Schedule_ID] VARCHAR(5),
  [Day] DATETIME
)
GO

CREATE TABLE [DENTIST] (
  [Dentist_ID] VARCHAR(5) PRIMARY KEY,
  [Degree] NVARCHAR(30),
  [Experience] INT
)
GO

CREATE TABLE [MEDICAL_RECORD] (
  [Medical_ID] VARCHAR(5) PRIMARY KEY,
  [Customer_ID] VARCHAR(5),
  [Day] DATETIME,
  [DentistResponsible] VARCHAR(5),
  [Diagnostic] TEXT,
  [Prescription_ID] VARCHAR(5),
  [ServiceForm_ID] VARCHAR(5),
  [Invoice_ID] VARCHAR(5)
)
GO

CREATE TABLE [PRESCRIPTION] (
  [Prescription_ID] VARCHAR(5) PRIMARY KEY,
  [Customer_ID] VARCHAR(5),
  [DentistPrescribe] VARCHAR(5),
  [Advice] TEXT,
  [TotalMoneyPrescription] INT
)
GO

CREATE TABLE [PRESCRIPTION_DETAIL] (
  [PrescriptionDetail_ID] VARCHAR(5) PRIMARY KEY,
  [Prescription_ID] VARCHAR(5),
  [Medicine_ID] VARCHAR(5),
  [MedicineName] NVARCHAR(100),
  [Unit] NVARCHAR(15),
  [Quantity] INT,
  [Dosage] NVARCHAR(100),
  [TotalMoney] INT
)
GO

CREATE TABLE [SERVICE] (
  [Service_ID] VARCHAR(5) PRIMARY KEY,
  [ServiecName] NVARCHAR(100),
  [ServiceDiscri] TEXT,
  [Price] INT
)
GO

CREATE TABLE [SERVICE_FORM_DETAIL] (
  [ServiceFormDetail_ID] VARCHAR(5) PRIMARY KEY,
  [ServiceForm_ID] VARCHAR(5),
  [Service_ID] VARCHAR(5),
  [DentistResponsible] VARCHAR(5)
)
GO

CREATE TABLE [SERVICE_FORM] (
  [ServiceForm_ID] VARCHAR(5) PRIMARY KEY,
  [Customer_ID] VARCHAR(5),
  [TotalMoneyService] INT
)
GO

CREATE TABLE [MEDICINE_WAREHOUSES] (
  [Medicine_ID] VARCHAR(5) PRIMARY KEY,
  [MedicineName] NVARCHAR(100),
  [Quantity] INT,
  [MedicineType] NVARCHAR(50),
  [MedicineEffect] TEXT,
  [MedicineDescri] TEXT,
  [Unit] NVARCHAR(15)
)
GO

CREATE TABLE [PAYMENT_INVOICE] (
  [Invoice_ID] VARCHAR(5) PRIMARY KEY,
  [StaffPrescribe] VARCHAR(5),
  [ServiceForm_ID] VARCHAR(5),
  [Prescription_ID] VARCHAR(5),
  [PaymentStatus] BIT,
  [InvoiceDate] DATETIME,
  [Note] TEXT,
  [TotalPayment] INT
)
GO

ALTER TABLE [USER] ADD FOREIGN KEY ([Role_ID]) REFERENCES [ROLE] ([Role_ID])
GO

ALTER TABLE [USER_INFOR] ADD FOREIGN KEY ([UserName]) REFERENCES [USER] ([UserName])
GO

ALTER TABLE [CUSTOMER_INFROR] ADD FOREIGN KEY ([Customer_ID]) REFERENCES [USER_INFOR] ([User_ID])
GO

ALTER TABLE [CLINIC_STAFF] ADD FOREIGN KEY ([Staff_ID]) REFERENCES [USER_INFOR] ([User_ID])
GO

ALTER TABLE [DENTIST] ADD FOREIGN KEY ([Dentist_ID]) REFERENCES [CLINIC_STAFF] ([Staff_ID])
GO

ALTER TABLE [SCHEDULE] ADD FOREIGN KEY ([Dentist_ID]) REFERENCES [DENTIST] ([Dentist_ID])
GO

ALTER TABLE [SCHEDULE] ADD FOREIGN KEY ([Shift_ID]) REFERENCES [SHIFT] ([Shift_ID])
GO

ALTER TABLE [APPOINTMENT] ADD FOREIGN KEY ([Customer_ID]) REFERENCES [CUSTOMER_INFROR] ([Customer_ID])
GO

ALTER TABLE [APPOINTMENT] 
ADD CONSTRAINT FK_Schedule_ScheduleID 
FOREIGN KEY ([Schedule_ID], [Day]) 
REFERENCES [SCHEDULE] ([Schedule_ID], [Day]);
GO

ALTER TABLE [CLINIC_STAFF] ADD FOREIGN KEY ([Postition_ID]) REFERENCES [POSTITION] ([Postition_ID])
GO

ALTER TABLE [MEDICAL_RECORD] ADD FOREIGN KEY ([Customer_ID]) REFERENCES [CUSTOMER_INFROR] ([Customer_ID])
GO

ALTER TABLE [MEDICAL_RECORD] ADD FOREIGN KEY ([DentistResponsible]) REFERENCES [DENTIST] ([Dentist_ID])
GO

ALTER TABLE [PRESCRIPTION_DETAIL] ADD FOREIGN KEY ([Prescription_ID]) REFERENCES [PRESCRIPTION] ([Prescription_ID])
GO

ALTER TABLE [MEDICAL_RECORD]ADD FOREIGN KEY ([Prescription_ID]) REFERENCES [PRESCRIPTION]  ([Prescription_ID])
GO

ALTER TABLE [PRESCRIPTION] ADD FOREIGN KEY ([DentistPrescribe]) REFERENCES [DENTIST] ([Dentist_ID])
GO

ALTER TABLE [MEDICAL_RECORD] ADD FOREIGN KEY ([ServiceForm_ID]) REFERENCES [SERVICE_FORM] ([ServiceForm_ID])
GO

ALTER TABLE [SERVICE_FORM_DETAIL] ADD FOREIGN KEY ([ServiceFormDetail_ID]) REFERENCES [SERVICE_FORM] ([ServiceForm_ID])
GO

ALTER TABLE [SERVICE_FORM_DETAIL] ADD FOREIGN KEY ([Service_ID]) REFERENCES [SERVICE] ([Service_ID])
GO

ALTER TABLE [PRESCRIPTION_DETAIL] ADD FOREIGN KEY ([Medicine_ID]) REFERENCES [MEDICINE_WAREHOUSES] ([Medicine_ID])
GO

ALTER TABLE [MEDICAL_RECORD] ADD FOREIGN KEY ([Invoice_ID]) REFERENCES [PAYMENT_INVOICE] ([Invoice_ID])
GO

ALTER TABLE [PAYMENT_INVOICE] ADD FOREIGN KEY ([Prescription_ID]) REFERENCES [PRESCRIPTION] ([Prescription_ID])
GO

ALTER TABLE [PAYMENT_INVOICE] ADD FOREIGN KEY ([ServiceForm_ID]) REFERENCES  [SERVICE_FORM] ([ServiceForm_ID])
GO

ALTER TABLE [PAYMENT_INVOICE] ADD FOREIGN KEY ([StaffPrescribe]) REFERENCES [CLINIC_STAFF] ([Staff_ID])
GO
