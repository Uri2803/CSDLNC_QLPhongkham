--Trigger xóa thông tin người dùng:
--Mục đích: Xóa thông tin người dùng tương ứng từ bảng USER_INFOR khi một người dùng bị xóa khỏi bảng USER.

CREATE OR ALTER TRIGGER trg_delete_user_info
ON [USER] 
AFTER DELETE
AS
BEGIN
    DELETE FROM [USER_INFOR] 
    WHERE [UserName] IN (SELECT [UserName] FROM deleted)
END
GO

--Trigger kiểm tra việc thêm thông tin đơn thuốc mới:
--Mục đích: Kiểm tra và thêm thông tin chi tiết của đơn thuốc vào bảng PRESCRIPTION_DETAIL khi có một đơn thuốc mới được thêm vào bảng PRESCRIPTION.

CREATE TRIGGER trg_insert_prescription_detail
ON PRESCRIPTION
AFTER INSERT 
AS
BEGIN
  INSERT INTO PRESCRIPTION_DETAIL (Prescription_ID, Medicine_ID, MedicineName, Unit, Quantity, Dosage, TotalMoney)
    SELECT 
        i.Prescription_ID, m.Medicine_ID, m.MedicineName, m.Unit, 10, N'Uống 1 viên/ngày', m.Price * 10
    FROM
        inserted i 
        INNER JOIN MEDICINE_WAREHOUSES m ON i.Customer_ID = m.Medicine_ID
    WHERE
        i.Prescription_ID NOT IN (SELECT Prescription_ID 
                                  FROM PRESCRIPTION_DETAIL)
END
GO

--Trigger kiểm tra việc thay đổi số lượng thuốc trong kho:
--Mục đích: Cập nhật thông tin số lượng thuốc trong kho khi có một đơn thuốc mới được thêm vào hoặc cập nhật trong bảng PRESCRIPTION_DETAIL.

CREATE OR ALTER TRIGGER trg_update_medicine_quantity
ON PRESCRIPTION_DETAIL
AFTER INSERT, UPDATE 
AS
BEGIN
    UPDATE m
    SET m.Quantity = m.Quantity - i.Quantity
    FROM MEDICINE_WAREHOUSES m JOIN
         inserted i ON m.Medicine_ID = i.Medicine_ID
    WHERE m.Quantity - i.Quantity < 0

    IF @@ROWCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION
        RAISERROR ('The quantity of medicine is not enough', 16, 1) 
        RETURN
    END
END