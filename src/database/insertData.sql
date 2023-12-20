USE DENTAL
---medical
-- Inserting data into [MEDICINE_WAREHOUSES] table
INSERT INTO [MEDICINE_WAREHOUSES] ([Medicine_ID], [MedicineName], [Quantity], [MedicineType], [MedicineEffect], [MedicineDescri], [Unit])
VALUES 
  ('M001', N'Toothache Relief', 100, N'Dental Care', N'Pain relief for gums', N'Medication for alleviating pain after tooth extraction', N'Box'),
  ('M002', N'Antibacterial Mouthwash', 150, N'Dental Care', N'Bacterial protection', N'Mouthwash for bacterial protection', N'Bottle'),
  ('M003', N'Teeth Whitening Gel', 200, N'Dental Care', N'Teeth whitening', N'Teeth whitening gel', N'Box'),
  ('M004', N'Gum Inflammation Relief', 80, N'Dental Care', N'Anti-inflammatory for gums', N'Medication for reducing gum inflammation', N'Sachet'),
  ('M005', N'Tooth Enamel Restorer', 120, N'Dental Care', N'Restores tooth enamel', N'Medication for supplementing tooth enamel', N'Box'),
  ('M006', N'Dental Floss', 180, N'Dental Care', N'Plaque removal', N'Dental floss for effective plaque removal', N'Pack'),
  ('M007', N'Cavity Protection Toothpaste', 220, N'Dental Care', N'Cavity prevention', N'Toothpaste for cavity protection', N'Tube'),
  ('M008', N'Orthodontic Wax', 90, N'Dental Care', N'Brace discomfort relief', N'Wax for relieving discomfort caused by braces', N'Jar'),
  ('M009', N'Tongue Cleaner', 130, N'Dental Care', N'Tongue hygiene', N'Device for cleaning the tongue and promoting oral hygiene', N'Piece'),
  ('M010', N'Denture Adhesive', 110, N'Dental Care', N'Secure denture fit', N'Adhesive for securing dentures in place', N'Tube'),
  ('M011', N'Mouth Ulcer Gel', 70, N'Dental Care', N'Ulcer pain relief', N'Gel for relieving pain caused by mouth ulcers', N'Tube'),
  ('M012', N'Fluoride Rinse', 160, N'Dental Care', N'Fluoride supplementation', N'Mouth rinse for supplementing fluoride', N'Bottle'),
  ('M013', N'Dental Pain Gel', 100, N'Dental Care', N'Effective pain relief', N'Gel for immediate relief from dental pain', N'Tube'),
  ('M014', N'Breath Freshener Spray', 180, N'Dental Care', N'Freshens breath', N'Mouth spray for instant breath freshening', N'Bottle'),
  ('M015', N'Tooth Sensitivity Toothpaste', 120, N'Dental Care', N'Sensitivity relief', N'Toothpaste for reducing tooth sensitivity', N'Tube'),
  ('M016', N'Dental Rubber Bands', 200, N'Dental Care', N'Orthodontic use', N'Rubber bands for orthodontic treatments', N'Pack'),
  ('M017', N'Gingivitis Mouthwash', 150, N'Dental Care', N'Gum disease prevention', N'Mouthwash for preventing gingivitis', N'Bottle'),
  ('M018', N'Dental Crown Cement', 80, N'Dental Care', N'Crown fixation', N'Cement for fixing dental crowns', N'Tube'),
  ('M019', N'Toothbrush Replacement Heads', 120, N'Dental Care', N'Hygienic brushing', N'Replacement heads for electric toothbrushes', N'Pack'),
  ('M020', N'Dental Mirror', 90, N'Dental Care', N'Oral examination', N'Mirror for dental professionals to examine the oral cavity', N'Piece');



---
INSERT INTO [ROLE]
VALUES
  (1, 'user', 'Tài khoản người dùng'),
  (2, 'admin', 'Tài khoản quản trị viên'),
  (3, 'doctor', ' Tài khoản nha sĩ'),
  (4, 'staft', 'Tài khoản cho nhân viên');

INSERT INTO [POSTITION]
VALUES 
  (1, 'Nhân viên phòng khám'),
  (2, 'Quản trị viên'),
  (3, 'Nha sĩ');

EXECUTE AddUser 'minhquang', '$2b$10$C0Fw2PUDfrU3KIqkeP0ZMe9aV1CORlv2kpYqF.FA0s2alZF2gDj3a', 'huynhminhquang@gmail.com', 1;
EXECUTE AddUser 'admin', '$2b$10$C0Fw2PUDfrU3KIqkeP0ZMe9aV1CORlv2kpYqF.FA0s2alZF2gDj3a', 'admin@gmail.com', 2;
EXECUTE AddUser 'doctor', '$2b$10$C0Fw2PUDfrU3KIqkeP0ZMe9aV1CORlv2kpYqF.FA0s2alZF2gDj3a', 'doctor@gmail.com', 3;
EXECUTE AddUser 'staft', '$2b$10$C0Fw2PUDfrU3KIqkeP0ZMe9aV1CORlv2kpYqF.FA0s2alZF2gDj3a', 'staft@gmail.com', 4;

--innser shift 
DECLARE @StartTime TIME = '07:00';
DECLARE @ShiftID INT = 1;
--- Thời gian bắt đầu buổi sáng 7h30
SET @StartTime = '07:30';
WHILE @StartTime < '11:00'
BEGIN
  INSERT INTO [SHIFT] ([Shift_ID], [Time_Frame])
  VALUES (@ShiftID, CONVERT(VARCHAR(5), @StartTime) + ' - ' + CONVERT(VARCHAR(5), DATEADD(MINUTE, 30, @StartTime)));
  SET @ShiftID = @ShiftID + 1;
  SET @StartTime = DATEADD(MINUTE, 30, @StartTime);
END;

--Thời gian bắt đầu từ chiều 1h30
SET @StartTime = '13:30';
WHILE @StartTime < '16:00'
BEGIN
  INSERT INTO [SHIFT] ([Shift_ID], [Time_Frame])
  VALUES (@ShiftID, CONVERT(VARCHAR(5), @StartTime) + ' - ' + CONVERT(VARCHAR(5), DATEADD(MINUTE, 30, @StartTime)));
  SET @ShiftID = @ShiftID + 1;
  SET @StartTime = DATEADD(MINUTE, 30, @StartTime);
END;

--Thời gian bắt đầu buổi tối 
SET @StartTime = '18:00';
WHILE @StartTime < '20:30'
BEGIN
  INSERT INTO [SHIFT] ([Shift_ID], [Time_Frame])
  VALUES (@ShiftID, CONVERT(VARCHAR(5), @StartTime) + ' - ' + CONVERT(VARCHAR(5), DATEADD(MINUTE, 30, @StartTime)));
  SET @ShiftID = @ShiftID + 1;
  SET @StartTime = DATEADD(MINUTE, 30, @StartTime);
END;

--DECLARE @Day DATE = GETDATE();
--EXECUTE AddDentistSchedule 'D0001', @Day;



