-- =========================================================================
-- StudySwap: Campus Peer-to-Peer Academic Marketplace & Resource Exchange
-- Complete Database Setup Script (Schema + Seed Data)
-- =========================================================================

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'StudySwap')
BEGIN
    CREATE DATABASE [StudySwap];
END
GO

USE [StudySwap];
GO

-- 1. DROP EXISTING CONSTRAINTS & TABLES IN REVERSE ORDER
IF OBJECT_ID('dbo.ReplyNotifications', 'U') IS NOT NULL DROP TABLE dbo.ReplyNotifications;
IF OBJECT_ID('dbo.Complaints', 'U') IS NOT NULL DROP TABLE dbo.Complaints;
IF OBJECT_ID('dbo.Payments', 'U') IS NOT NULL DROP TABLE dbo.Payments;
IF OBJECT_ID('dbo.ListingRequests', 'U') IS NOT NULL DROP TABLE dbo.ListingRequests;
IF OBJECT_ID('dbo.PurchaseRequests', 'U') IS NOT NULL DROP TABLE dbo.PurchaseRequests;
IF OBJECT_ID('dbo.Listings', 'U') IS NOT NULL DROP TABLE dbo.Listings;
IF OBJECT_ID('dbo.ContactMessages', 'U') IS NOT NULL DROP TABLE dbo.ContactMessages;
IF OBJECT_ID('dbo.AdminLogin', 'U') IS NOT NULL DROP TABLE dbo.AdminLogin;
IF OBJECT_ID('dbo.app_settings', 'U') IS NOT NULL DROP TABLE dbo.app_settings;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
IF OBJECT_ID('dbo.Courses', 'U') IS NOT NULL DROP TABLE dbo.Courses;
IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL DROP TABLE dbo.Departments;
IF OBJECT_ID('dbo.Colleges', 'U') IS NOT NULL DROP TABLE dbo.Colleges;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
GO

-- 2. CREATE MASTER TABLES
CREATE TABLE [dbo].[Colleges] (
    [CollegeID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [CollegeName] NVARCHAR(200) NOT NULL,
    [EmailDomain] NVARCHAR(100) NOT NULL,
    [City] NVARCHAR(100) NULL,
    [State] NVARCHAR(100) NULL,
    [IsActive] BIT NULL DEFAULT 1,
    [CreatedDate] DATETIME NULL DEFAULT GETDATE()
);

CREATE TABLE [dbo].[Departments] (
    [DepartmentID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [CollegeID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Colleges]([CollegeID]),
    [DepartmentName] NVARCHAR(100) NOT NULL,
    [DepartmentCode] NVARCHAR(20) NULL,
    [IsActive] BIT NULL DEFAULT 1
);

CREATE TABLE [dbo].[Courses] (
    [CourseID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [DepartmentID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Departments]([DepartmentID]),
    [CourseName] NVARCHAR(150) NOT NULL,
    [CourseCode] NVARCHAR(20) NULL,
    [Semester] INT NULL CHECK ([Semester] >= 1 AND [Semester] <= 8),
    [IsActive] BIT NULL DEFAULT 1
);

CREATE TABLE [dbo].[Categories] (
    [CategoryID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [CategoryName] NVARCHAR(50) NOT NULL,
    [Description] NVARCHAR(255) NULL,
    [IconPath] NVARCHAR(255) NULL,
    [DisplayOrder] INT NULL,
    [IsActive] BIT NULL DEFAULT 1
);

CREATE TABLE [dbo].[AdminLogin] (
    [username] NVARCHAR(200) NULL,
    [password] NVARCHAR(200) NULL
);

CREATE TABLE [dbo].[app_settings] (
    [setting_id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [setting_key] NVARCHAR(100) NOT NULL,
    [setting_value] NVARCHAR(MAX) NULL,
    [setting_description] NVARCHAR(MAX) NULL,
    [updated_at] DATETIME2 NULL DEFAULT GETDATE()
);

CREATE TABLE [dbo].[Users] (
    [UserID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [FullName] NVARCHAR(100) NOT NULL,
    [Email] NVARCHAR(100) NOT NULL UNIQUE,
    [PasswordHash] NVARCHAR(256) NOT NULL,
    [Phone] NVARCHAR(15) NOT NULL,
    [College] NVARCHAR(150) NOT NULL,
    [Department] NVARCHAR(100) NOT NULL,
    [YearOfStudy] INT NOT NULL CHECK ([YearOfStudy] >= 1 AND [YearOfStudy] <= 4),
    [RollNumber] NVARCHAR(50) NOT NULL,
    [ProfilePicture] NVARCHAR(255) NULL,
    [Bio] NVARCHAR(500) NULL,
    [IsVerified] BIT NULL DEFAULT 0,
    [StudentIDProofPath] NVARCHAR(255) NULL,
    [VerificationDate] DATETIME NULL,
    [VerifiedBy] NVARCHAR(100) NULL,
    [UserRole] NVARCHAR(20) NULL DEFAULT 'Student' CHECK ([UserRole] IN ('Admin', 'Student')),
    [AccountStatus] NVARCHAR(30) NULL DEFAULT 'Active' 
        CONSTRAINT [CK_Users_AccountStatus] CHECK ([AccountStatus] IN ('Active', 'Inactive', 'Suspended', 'PendingVerification', 'Rejected')),
    [SuspensionReason] NVARCHAR(500) NULL,
    [TotalSales] INT NULL DEFAULT 0,
    [TotalPurchases] INT NULL DEFAULT 0,
    [AverageRating] DECIMAL(3,2) NULL DEFAULT 0.0 CHECK ([AverageRating] >= 0 AND [AverageRating] <= 5),
    [TotalReviews] INT NULL DEFAULT 0,
    [ResponseRate] DECIMAL(5,2) NULL DEFAULT 100.0 CHECK ([ResponseRate] >= 0 AND [ResponseRate] <= 100),
    [PreferredContactMethod] NVARCHAR(20) NULL DEFAULT 'Both' CHECK ([PreferredContactMethod] IN ('Both', 'Phone', 'Email')),
    [EmailNotifications] BIT NULL DEFAULT 1,
    [NotifyNewOffers] BIT NULL DEFAULT 1,
    [NotifyPriceDrops] BIT NULL DEFAULT 1,
    [NotifyNewListings] BIT NULL DEFAULT 1,
    [ShowPhoneToVerified] BIT NULL DEFAULT 1,
    [FailedLoginAttempts] INT NULL DEFAULT 0,
    [LastLoginDate] DATETIME NULL,
    [AccountLockedUntil] DATETIME NULL,
    [MemberSince] DATETIME NULL DEFAULT GETDATE(),
    [LastModified] DATETIME NULL DEFAULT GETDATE(),
    [CourseID] INT NULL
);

CREATE TABLE [dbo].[Listings] (
    [ListingID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UserID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Users]([UserID]),
    [CategoryID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Categories]([CategoryID]),
    [CourseID] INT NULL,
    [Title] NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(1000) NOT NULL,
    [Condition] NVARCHAR(50) NULL CHECK ([Condition] IN ('New', 'Like New', 'Good', 'Fair')),
    [ListingType] NVARCHAR(50) NULL CHECK ([ListingType] IN ('ForSale', 'ForSwap', 'Both', 'Exchange', 'Sell')),
    [Price] DECIMAL(10,2) NULL,
    [OriginalPrice] DECIMAL(10,2) NULL,
    [Edition] NVARCHAR(50) NULL,
    [Author] NVARCHAR(100) NULL,
    [Publisher] NVARCHAR(100) NULL,
    [ISBN] NVARCHAR(20) NULL,
    [Image1Path] NVARCHAR(255) NULL,
    [Image2Path] NVARCHAR(255) NULL,
    [Image3Path] NVARCHAR(255) NULL,
    [Status] NVARCHAR(50) NULL CHECK ([Status] IN ('Active', 'Deactive', 'Sold', 'Swapped', 'Expired', 'Inactive', 'Removed')),
    [CreatedDate] DATETIME NULL DEFAULT GETDATE(),
    [LastModified] DATETIME NULL DEFAULT GETDATE(),
    [ViewsCount] INT NULL DEFAULT 0
);

CREATE TABLE [dbo].[ListingRequests] (
    [RequestID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [RequestedListingID] INT NOT NULL,
    [RequesterStudentID] INT NOT NULL,
    [RequestType] VARCHAR(10) NULL,
    [ExchangeListingID] INT NULL,
    [RequestDate] DATETIME NULL DEFAULT GETDATE(),
    [Status] VARCHAR(20) NULL
);

CREATE TABLE [dbo].[PurchaseRequests] (
    [PurchaseRequestID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [RequesterUserID] INT NOT NULL,
    [ItemName] NVARCHAR(150) NOT NULL,
    [CategoryID] INT NOT NULL,
    [Description] NVARCHAR(1000) NULL,
    [Status] NVARCHAR(20) NULL,
    [Reaction] NVARCHAR(50) NULL,
    [CreatedDate] DATETIME NULL DEFAULT GETDATE()
);

CREATE TABLE [dbo].[Payments] (
    [PaymentID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [RequestID] INT NULL,
    [ListingID] INT NOT NULL,
    [PayerUserID] INT NOT NULL,
    [Amount] DECIMAL(10,2) NOT NULL,
    [PaymentMethod] VARCHAR(50) NOT NULL,
    [TransactionRef] VARCHAR(100) NULL,
    [PaymentStatus] VARCHAR(20) NOT NULL,
    [PaymentDate] DATETIME NULL DEFAULT GETDATE()
);

CREATE TABLE [dbo].[Complaints] (
    [ComplaintID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UserID] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Users]([UserID]),
    [Category] NVARCHAR(50) NOT NULL,
    [Subject] NVARCHAR(200) NOT NULL,
    [Description] NVARCHAR(2000) NOT NULL,
    [RelatedListingID] INT NULL FOREIGN KEY REFERENCES [dbo].[Listings]([ListingID]),
    [Priority] NVARCHAR(20) NOT NULL CHECK ([Priority] IN ('Urgent', 'High', 'Medium', 'Low')),
    [Status] NVARCHAR(20) NOT NULL CHECK ([Status] IN ('Pending', 'In Progress', 'Completed', 'Rejected')),
    [AdminNotes] NVARCHAR(1000) NULL,
    [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
    [ResolvedDate] DATETIME NULL
);

CREATE TABLE [dbo].[ReplyNotifications] (
    [NotificationID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UserID] INT NOT NULL,
    [ListingID] INT NOT NULL,
    [PurchaseRequestID] INT NOT NULL,
    [IsRead] BIT NOT NULL DEFAULT 0,
    [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE [dbo].[ContactMessages] (
    [MessageID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(100) NOT NULL,
    [Email] NVARCHAR(100) NOT NULL,
    [Subject] NVARCHAR(50) NULL CHECK ([Subject] IN ('Other', 'Suggestion', 'Complaint', 'Technical', 'General')),
    [Message] NVARCHAR(2000) NOT NULL,
    [Status] NVARCHAR(20) NULL CHECK ([Status] IN ('Closed', 'Replied', 'Read', 'New')),
    [AdminResponse] NVARCHAR(2000) NULL,
    [RespondedBy] INT NULL FOREIGN KEY REFERENCES [dbo].[Users]([UserID]),
    [RespondedAt] DATETIME NULL,
    [CreatedDate] DATETIME NULL DEFAULT GETDATE()
);
GO

-- =========================================================================
-- 3. SEED INITIAL DATA
-- =========================================================================
-- SEED DATA: Colleges
SET IDENTITY_INSERT [dbo].[Colleges] ON;
INSERT INTO [dbo].[Colleges] ([CollegeID], [CollegeName], [EmailDomain], [City], [State], [IsActive], [CreatedDate]) VALUES (1, N'ABC Engineering College', N'abc.edu', N'Mumbaiv', N'Maharashtra', 1, N'19-01-2026 11:10:08');
INSERT INTO [dbo].[Colleges] ([CollegeID], [CollegeName], [EmailDomain], [City], [State], [IsActive], [CreatedDate]) VALUES (2, N'XYZ Institute of Technology', N'xyz.edu', N'Pune', N'Maharashtra', 1, N'19-01-2026 11:10:08');
INSERT INTO [dbo].[Colleges] ([CollegeID], [CollegeName], [EmailDomain], [City], [State], [IsActive], [CreatedDate]) VALUES (3, N'National Science College', N'nsc.edu', N'Delhi', N'Delhi', 1, N'19-01-2026 11:10:08');
SET IDENTITY_INSERT [dbo].[Colleges] OFF;
GO

-- SEED DATA: Departments
SET IDENTITY_INSERT [dbo].[Departments] ON;
INSERT INTO [dbo].[Departments] ([DepartmentID], [CollegeID], [DepartmentName], [DepartmentCode], [IsActive]) VALUES (1, 1, N'Computer Engineering', N'CSE', 1);
INSERT INTO [dbo].[Departments] ([DepartmentID], [CollegeID], [DepartmentName], [DepartmentCode], [IsActive]) VALUES (2, 1, N'Information Technology', N'IT', 1);
INSERT INTO [dbo].[Departments] ([DepartmentID], [CollegeID], [DepartmentName], [DepartmentCode], [IsActive]) VALUES (3, 1, N'Electronics Engineering', N'EXTC', 1);
INSERT INTO [dbo].[Departments] ([DepartmentID], [CollegeID], [DepartmentName], [DepartmentCode], [IsActive]) VALUES (4, 2, N'Computer Science', N'CSE', 1);
INSERT INTO [dbo].[Departments] ([DepartmentID], [CollegeID], [DepartmentName], [DepartmentCode], [IsActive]) VALUES (5, 2, N'Mechanical Engineering', N'ME', 1);
INSERT INTO [dbo].[Departments] ([DepartmentID], [CollegeID], [DepartmentName], [DepartmentCode], [IsActive]) VALUES (6, 3, N'Computer Applications', N'MCA', 1);
INSERT INTO [dbo].[Departments] ([DepartmentID], [CollegeID], [DepartmentName], [DepartmentCode], [IsActive]) VALUES (7, 3, N'Data Science', N'DS', 1);
SET IDENTITY_INSERT [dbo].[Departments] OFF;
GO

-- SEED DATA: Courses
SET IDENTITY_INSERT [dbo].[Courses] ON;
INSERT INTO [dbo].[Courses] ([CourseID], [DepartmentID], [CourseName], [CourseCode], [Semester], [IsActive]) VALUES (1, 1, N'B.E Computer Engineering', N'BE-COMP', 8, 1);
INSERT INTO [dbo].[Courses] ([CourseID], [DepartmentID], [CourseName], [CourseCode], [Semester], [IsActive]) VALUES (2, 1, N'B.Tech Computer Engineering', N'BTECH-COMP', 8, 1);
INSERT INTO [dbo].[Courses] ([CourseID], [DepartmentID], [CourseName], [CourseCode], [Semester], [IsActive]) VALUES (3, 2, N'B.Sc Information Technology', N'BSC-IT', 6, 1);
INSERT INTO [dbo].[Courses] ([CourseID], [DepartmentID], [CourseName], [CourseCode], [Semester], [IsActive]) VALUES (4, 2, N'B.Tech IT', N'BTECH-IT', 8, 1);
INSERT INTO [dbo].[Courses] ([CourseID], [DepartmentID], [CourseName], [CourseCode], [Semester], [IsActive]) VALUES (5, 3, N'B.E Electronics & Telecommunication', N'BE-EXTC', 8, 1);
INSERT INTO [dbo].[Courses] ([CourseID], [DepartmentID], [CourseName], [CourseCode], [Semester], [IsActive]) VALUES (6, 4, N'B.Tech Computer Science', N'BTECH-CSE', 8, 1);
INSERT INTO [dbo].[Courses] ([CourseID], [DepartmentID], [CourseName], [CourseCode], [Semester], [IsActive]) VALUES (7, 6, N'Master of Computer Applications', N'MCA', 6, 1);
INSERT INTO [dbo].[Courses] ([CourseID], [DepartmentID], [CourseName], [CourseCode], [Semester], [IsActive]) VALUES (8, 7, N'B.Sc Data Science', N'BSC-DS', 6, 1);
SET IDENTITY_INSERT [dbo].[Courses] OFF;
GO

-- SEED DATA: Categories
SET IDENTITY_INSERT [dbo].[Categories] ON;
INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [Description], [IconPath], [DisplayOrder], [IsActive]) VALUES (1, N'Books', N'Academic books, reference books, guides', N'icons/books.png', 1, 1);
INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [Description], [IconPath], [DisplayOrder], [IsActive]) VALUES (2, N'Electronics', N'Calculators, laptops, gadgets', N'icons/electronics.png', 2, 1);
INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [Description], [IconPath], [DisplayOrder], [IsActive]) VALUES (3, N'Stationery', N'Pens, notebooks, files', N'icons/stationery.png', 3, 1);
INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [Description], [IconPath], [DisplayOrder], [IsActive]) VALUES (4, N'Furniture', N'Study tables, chairs, shelves', N'icons/furniture.png', 4, 1);
INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [Description], [IconPath], [DisplayOrder], [IsActive]) VALUES (5, N'Notes & Study Material', N'Handwritten notes, PDFs, printouts', N'icons/notes.png', 5, 1);
INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [Description], [IconPath], [DisplayOrder], [IsActive]) VALUES (6, N'Lab Equipment', N'Practical lab tools and kits', N'icons/lab.png', 6, 1);
INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [Description], [IconPath], [DisplayOrder], [IsActive]) VALUES (7, N'Bags & Accessories', N'Backpacks, laptop bags, accessories', N'icons/bag.png', 7, 1);
INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [Description], [IconPath], [DisplayOrder], [IsActive]) VALUES (8, N'Sports Items', N'Sports gear and equipment', N'icons/sports.png', 8, 1);
INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [Description], [IconPath], [DisplayOrder], [IsActive]) VALUES (9, N'Calculators', N'Scientific and graphing calculators', N'icons/calculator.png', 9, 1);
INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [Description], [IconPath], [DisplayOrder], [IsActive]) VALUES (10, N'Others', N'Miscellaneous student items', N'icons/others.png', 10, 1);
SET IDENTITY_INSERT [dbo].[Categories] OFF;
GO

-- SEED DATA: AdminLogin
INSERT INTO [dbo].[AdminLogin] ([username], [password]) VALUES (N'admin@gmail.com', N'admin123');
GO

-- SEED DATA: app_settings
SET IDENTITY_INSERT [dbo].[app_settings] ON;
INSERT INTO [dbo].[app_settings] ([setting_id], [setting_key], [setting_value], [setting_description], [updated_at]) VALUES (1, N'app_version', N'1.0.0', N'Current version', N'04-02-2026 11:24:08');
INSERT INTO [dbo].[app_settings] ([setting_id], [setting_key], [setting_value], [setting_description], [updated_at]) VALUES (2, N'maintenance_mode', N'false', N'Maintenance flag', N'04-02-2026 11:24:08');
SET IDENTITY_INSERT [dbo].[app_settings] OFF;
GO

-- SEED DATA: Users
SET IDENTITY_INSERT [dbo].[Users] ON;
INSERT INTO [dbo].[Users] ([UserID], [FullName], [Email], [PasswordHash], [Phone], [College], [Department], [YearOfStudy], [RollNumber], [ProfilePicture], [Bio], [IsVerified], [StudentIDProofPath], [VerificationDate], [VerifiedBy], [UserRole], [AccountStatus], [SuspensionReason], [TotalSales], [TotalPurchases], [AverageRating], [TotalReviews], [ResponseRate], [PreferredContactMethod], [EmailNotifications], [NotifyNewOffers], [NotifyPriceDrops], [NotifyNewListings], [ShowPhoneToVerified], [FailedLoginAttempts], [LastLoginDate], [AccountLockedUntil], [MemberSince], [LastModified], [CourseID]) VALUES (8, N'Ram Rathi', N's@gmail.com', N'5b1d5dd29b0045e8d8293415b1bd94c3a4b56dfd132a4c50631713f8b686a823', N'8208642915', N'1', N'1', 3, N'1001', NULL, NULL, 1, N'~/Uploads/StudentID/StudentID_8.png', N'17-09-2026 15:44:55', NULL, N'Student', N'Active', NULL, 0, 0, NULL, 0, NULL, N'Both', 1, 1, 1, 1, 1, 0, NULL, NULL, N'17-09-2026 15:38:08', N'17-09-2026 15:38:08', 1);
INSERT INTO [dbo].[Users] ([UserID], [FullName], [Email], [PasswordHash], [Phone], [College], [Department], [YearOfStudy], [RollNumber], [ProfilePicture], [Bio], [IsVerified], [StudentIDProofPath], [VerificationDate], [VerifiedBy], [UserRole], [AccountStatus], [SuspensionReason], [TotalSales], [TotalPurchases], [AverageRating], [TotalReviews], [ResponseRate], [PreferredContactMethod], [EmailNotifications], [NotifyNewOffers], [NotifyPriceDrops], [NotifyNewListings], [ShowPhoneToVerified], [FailedLoginAttempts], [LastLoginDate], [AccountLockedUntil], [MemberSince], [LastModified], [CourseID]) VALUES (9, N'raj', N'h@gmail.com', N'1d622460ebce57c35328b3dbf11bf20a82d45e314a09c83ef0bc5c37a1169880', N'8208642915', N'3', N'6', 3, N'1002', NULL, NULL, 1, N'~/Uploads/StudentID/StudentID_9.png', N'17-09-2026 15:48:29', NULL, N'Student', N'Active', NULL, 0, 0, NULL, 0, NULL, N'Both', 1, 1, 1, 1, 1, 0, NULL, NULL, N'17-09-2026 15:47:06', N'27-10-2026 18:33:08', 7);
INSERT INTO [dbo].[Users] ([UserID], [FullName], [Email], [PasswordHash], [Phone], [College], [Department], [YearOfStudy], [RollNumber], [ProfilePicture], [Bio], [IsVerified], [StudentIDProofPath], [VerificationDate], [VerifiedBy], [UserRole], [AccountStatus], [SuspensionReason], [TotalSales], [TotalPurchases], [AverageRating], [TotalReviews], [ResponseRate], [PreferredContactMethod], [EmailNotifications], [NotifyNewOffers], [NotifyPriceDrops], [NotifyNewListings], [ShowPhoneToVerified], [FailedLoginAttempts], [LastLoginDate], [AccountLockedUntil], [MemberSince], [LastModified], [CourseID]) VALUES (12, N'Aarohi Sharma', N'demo@studyswap.com', N'd3ad9315b7be5dd53b31a273b3b3aba5defe700808305aa16a3062b76658a791', N'9876543210', N'1', N'1', 3, N'23BTCS1045', N'~/Uploads/StudentPhoto/student_8.jpg', N'Third-year Computer Engineering student. Avid reader and coding enthusiast. Open for book exchanges and tech gadgets swap!', 1, N'~/Uploads/StudentID/StudentID_2.png', N'14-09-2026 00:46:31', N'Admin', N'Student', N'Active', NULL, 3, 1, 4.80, 5, 95.00, N'Both', 1, 1, 1, 1, 1, 0, NULL, NULL, N'30-08-2026 00:46:31', N'29-10-2026 00:46:31', 1);
SET IDENTITY_INSERT [dbo].[Users] OFF;
GO

-- SEED DATA: Listings
SET IDENTITY_INSERT [dbo].[Listings] ON;
INSERT INTO [dbo].[Listings] ([ListingID], [UserID], [CategoryID], [CourseID], [Title], [Description], [Condition], [ListingType], [SellingPrice], [IsPriceNegotiable], [Status], [ViewsCount], [PostedDate], [LastModified], [Image1Path], [Image2Path], [Image3Path], [ReplyID]) VALUES (17, 8, 1, NULL, N'python book', N'xdd', N'Like New', N'Both', 2500.00, 1, N'Active', 0, N'17-09-2026 15:53:34', N'17-09-2026 15:53:34', N'~/Uploads/ListingImages/User_8_Listing_20260917155334_Img1.png', N'~/Uploads/ListingImages/User_8_Listing_20260917155334_Img2.png', N'~/Uploads/ListingImages/User_8_Listing_20260917155334_Img3.png', NULL);
INSERT INTO [dbo].[Listings] ([ListingID], [UserID], [CategoryID], [CourseID], [Title], [Description], [Condition], [ListingType], [SellingPrice], [IsPriceNegotiable], [Status], [ViewsCount], [PostedDate], [LastModified], [Image1Path], [Image2Path], [Image3Path], [ReplyID]) VALUES (18, 9, 2, NULL, N'c', N'ss', N'New', N'Both', 2500.00, 1, N'Deactive', 0, N'17-09-2026 17:17:07', N'17-09-2026 17:29:22', N'~/Uploads/ListingImages/User_9_Listing_20260917171707_Img1.png', N'~/Uploads/ListingImages/User_9_Listing_20260917171707_Img2.png', N'~/Uploads/ListingImages/User_9_Listing_20260917171707_Img3.png', 8);
INSERT INTO [dbo].[Listings] ([ListingID], [UserID], [CategoryID], [CourseID], [Title], [Description], [Condition], [ListingType], [SellingPrice], [IsPriceNegotiable], [Status], [ViewsCount], [PostedDate], [LastModified], [Image1Path], [Image2Path], [Image3Path], [ReplyID]) VALUES (24, 12, 1, 1, N'Data Structures & Algorithms in C++ (CLRS)', N'Standard textbook in pristine condition. No pen markings or torn pages. Ideal for 2nd and 3rd year engineering students.', N'Like New', N'Sell', 650.00, 1, N'Active', 42, N'24-10-2026 00:46:31', N'29-10-2026 00:46:31', N'~/Uploads/ListingImages/User_2_Listing_20260129120357_Img1.jpg', N'~/Uploads/ListingImages/User_2_Listing_20260129120357_Img2.jpg', N'~/Uploads/ListingImages/User_2_Listing_20260129120357_Img3.jpg', NULL);
INSERT INTO [dbo].[Listings] ([ListingID], [UserID], [CategoryID], [CourseID], [Title], [Description], [Condition], [ListingType], [SellingPrice], [IsPriceNegotiable], [Status], [ViewsCount], [PostedDate], [LastModified], [Image1Path], [Image2Path], [Image3Path], [ReplyID]) VALUES (25, 12, 9, 1, N'Casio FX-991EX Classwiz Calculator', N'Original scientific calculator with solar dual power. Battery replaced last month. Includes original slip-on hard case.', N'Like New', N'Both', 1100.00, 0, N'Active', 89, N'17-10-2026 00:46:31', N'29-10-2026 00:46:31', N'~/Uploads/ListingImages/User_2_Listing_20260130124309_Img1.jpg', N'~/Uploads/ListingImages/User_2_Listing_20260130124309_Img2.jpg', N'~/Uploads/ListingImages/User_2_Listing_20260130124309_Img3.jpg', NULL);
INSERT INTO [dbo].[Listings] ([ListingID], [UserID], [CategoryID], [CourseID], [Title], [Description], [Condition], [ListingType], [SellingPrice], [IsPriceNegotiable], [Status], [ViewsCount], [PostedDate], [LastModified], [Image1Path], [Image2Path], [Image3Path], [ReplyID]) VALUES (26, 12, 6, 1, N'Arduino Uno IoT Sensor Starter Lab Kit', N'Complete breadboard, jumper wires, ultrasonic sensor, temperature sensor, and servo motor. Looking to swap for a Raspberry Pi Pico or Python books.', N'Good', N'Exchange', 850.00, 1, N'Active', 31, N'27-10-2026 00:46:31', N'29-10-2026 00:46:31', N'~/Uploads/ListingImages/User_2_Listing_20260129120357_Img2.jpg', N'~/Uploads/ListingImages/User_2_Listing_20260129120357_Img3.jpg', N'~/Uploads/ListingImages/User_2_Listing_20260129120357_Img1.jpg', NULL);
INSERT INTO [dbo].[Listings] ([ListingID], [UserID], [CategoryID], [CourseID], [Title], [Description], [Condition], [ListingType], [SellingPrice], [IsPriceNegotiable], [Status], [ViewsCount], [PostedDate], [LastModified], [Image1Path], [Image2Path], [Image3Path], [ReplyID]) VALUES (27, 12, 1, 1, N'Higher Engineering Mathematics by B.S. Grewal', N'Sold to fellow student. Clean book with all formula sheets included.', N'Good', N'Sell', 550.00, 0, N'Sold', 120, N'04-10-2026 00:46:31', N'19-10-2026 00:46:31', N'~/Uploads/ListingImages/User_2_Listing_20260130124309_Img1.jpg', N'~/Uploads/ListingImages/User_2_Listing_20260130124309_Img2.jpg', N'~/Uploads/ListingImages/User_2_Listing_20260130124309_Img3.jpg', NULL);
INSERT INTO [dbo].[Listings] ([ListingID], [UserID], [CategoryID], [CourseID], [Title], [Description], [Condition], [ListingType], [SellingPrice], [IsPriceNegotiable], [Status], [ViewsCount], [PostedDate], [LastModified], [Image1Path], [Image2Path], [Image3Path], [ReplyID]) VALUES (28, 12, 3, 1, N'Engineering Graphics Mini Drafter & Sheet Container', N'Swapped for 2nd semester physics lab notes. Successfully completed exchange.', N'Good', N'Exchange', 400.00, 0, N'Swapped', 65, N'19-09-2026 00:46:31', N'09-10-2026 00:46:31', N'~/Uploads/ListingImages/User_2_Listing_20260129120357_Img1.jpg', N'~/Uploads/ListingImages/User_2_Listing_20260129120357_Img2.jpg', N'~/Uploads/ListingImages/User_2_Listing_20260129120357_Img3.jpg', NULL);
INSERT INTO [dbo].[Listings] ([ListingID], [UserID], [CategoryID], [CourseID], [Title], [Description], [Condition], [ListingType], [SellingPrice], [IsPriceNegotiable], [Status], [ViewsCount], [PostedDate], [LastModified], [Image1Path], [Image2Path], [Image3Path], [ReplyID]) VALUES (29, 8, 1, 1, N'Database System Concepts (6th Edition) - Silberschatz', N'Essential reference book for DBMS subject. Hardcover edition in pristine condition with zero highlights.', N'Like New', N'Sell', 580.00, 1, N'Active', 34, N'28-10-2026 17:15:38', N'29-10-2026 01:15:38', N'~/Uploads/ListingImages/User_3_Listing_20260122175047_Img1.jpg', N'~/Uploads/ListingImages/User_3_Listing_20260122175047_Img2.jpg', N'~/Uploads/ListingImages/User_3_Listing_20260122175047_Img3.jpg', NULL);
INSERT INTO [dbo].[Listings] ([ListingID], [UserID], [CategoryID], [CourseID], [Title], [Description], [Condition], [ListingType], [SellingPrice], [IsPriceNegotiable], [Status], [ViewsCount], [PostedDate], [LastModified], [Image1Path], [Image2Path], [Image3Path], [ReplyID]) VALUES (30, 9, 2, 1, N'Logitech K380 Multi-Device Bluetooth Wireless Keyboard', N'Super compact keyboard, pairs with up to 3 devices (laptop, tablet, phone). Fresh AAA batteries included.', N'Good', N'Both', 1450.00, 1, N'Active', 56, N'28-10-2026 11:15:38', N'29-10-2026 01:15:38', N'~/Uploads/ListingImages/User_3_Listing_20260202105259_Img1.jpg', N'~/Uploads/ListingImages/User_3_Listing_20260202105259_Img2.jpg', N'~/Uploads/ListingImages/User_3_Listing_20260202105259_Img3.jpg', NULL);
INSERT INTO [dbo].[Listings] ([ListingID], [UserID], [CategoryID], [CourseID], [Title], [Description], [Condition], [ListingType], [SellingPrice], [IsPriceNegotiable], [Status], [ViewsCount], [PostedDate], [LastModified], [Image1Path], [Image2Path], [Image3Path], [ReplyID]) VALUES (31, 8, 5, 1, N'Operating Systems & Computer Networks Handwritten Notes', N'Complete semester 5 handwritten notes covering process scheduling, memory management, TCP/IP protocol stack, and solved university papers.', N'Like New', N'Exchange', 250.00, 0, N'Active', 78, N'28-10-2026 01:15:38', N'29-10-2026 01:15:38', N'~/Uploads/ListingImages/User_2_Listing_20260129120357_Img2.jpg', N'~/Uploads/ListingImages/User_2_Listing_20260129120357_Img1.jpg', N'~/Uploads/ListingImages/User_2_Listing_20260129120357_Img3.jpg', NULL);
INSERT INTO [dbo].[Listings] ([ListingID], [UserID], [CategoryID], [CourseID], [Title], [Description], [Condition], [ListingType], [SellingPrice], [IsPriceNegotiable], [Status], [ViewsCount], [PostedDate], [LastModified], [Image1Path], [Image2Path], [Image3Path], [ReplyID]) VALUES (32, 9, 9, 1, N'Texas Instruments TI-30XS MultiView Scientific Calculator', N'Approved for college and competitive examinations. 4-line display, excellent condition, solar powered.', N'New', N'Sell', 850.00, 1, N'Active', 92, N'27-10-2026 01:15:38', N'29-10-2026 01:15:38', N'~/Uploads/ListingImages/User_2_Listing_20260130124309_Img2.jpg', N'~/Uploads/ListingImages/User_2_Listing_20260130124309_Img1.jpg', N'~/Uploads/ListingImages/User_2_Listing_20260130124309_Img3.jpg', NULL);
INSERT INTO [dbo].[Listings] ([ListingID], [UserID], [CategoryID], [CourseID], [Title], [Description], [Condition], [ListingType], [SellingPrice], [IsPriceNegotiable], [Status], [ViewsCount], [PostedDate], [LastModified], [Image1Path], [Image2Path], [Image3Path], [ReplyID]) VALUES (34, 8, 7, 1, N'Wildcraft Water-Resistant Laptop College Backpack (30L)', N'Spacious college backpack with dedicated 15.6 inch padded laptop compartment. Clean and sturdy.', N'Good', N'Sell', 750.00, 1, N'Active', 41, N'25-10-2026 01:15:38', N'29-10-2026 01:15:38', N'~/Uploads/ListingImages/User_3_Listing_20260122175047_Img3.jpg', N'~/Uploads/ListingImages/User_3_Listing_20260122175047_Img1.jpg', N'~/Uploads/ListingImages/User_3_Listing_20260122175047_Img2.jpg', NULL);
INSERT INTO [dbo].[Listings] ([ListingID], [UserID], [CategoryID], [CourseID], [Title], [Description], [Condition], [ListingType], [SellingPrice], [IsPriceNegotiable], [Status], [ViewsCount], [PostedDate], [LastModified], [Image1Path], [Image2Path], [Image3Path], [ReplyID]) VALUES (36, 9, 1, 1, N'Core Java: An Integrated Approach - R. Nageswara Rao', N'Comprehensive guide for Java and OOP programming. Covers all fundamentals, collections, multithreading and JDBC.', N'Good', N'Both', 380.00, 1, N'Active', 115, N'23-10-2026 01:15:38', N'29-10-2026 01:15:38', N'~/Uploads/ListingImages/User_3_Listing_20260202105259_Img2.jpg', N'~/Uploads/ListingImages/User_3_Listing_20260202105259_Img1.jpg', N'~/Uploads/ListingImages/User_3_Listing_20260202105259_Img3.jpg', NULL);
SET IDENTITY_INSERT [dbo].[Listings] OFF;
GO

-- SEED DATA: ListingRequests
SET IDENTITY_INSERT [dbo].[ListingRequests] ON;
INSERT INTO [dbo].[ListingRequests] ([RequestID], [RequestedListingID], [RequesterStudentID], [RequestType], [ExchangeListingID], [RequestDate], [Status], [FinalStatus]) VALUES (3, 25, 8, N'Exchange', 17, N'28-10-2026 00:46:31', N'Pending', N'UnderReview');
INSERT INTO [dbo].[ListingRequests] ([RequestID], [RequestedListingID], [RequesterStudentID], [RequestType], [ExchangeListingID], [RequestDate], [Status], [FinalStatus]) VALUES (4, 17, 12, N'Buy', NULL, N'25-10-2026 00:46:31', N'Completed', N'Approved');
SET IDENTITY_INSERT [dbo].[ListingRequests] OFF;
GO

-- SEED DATA: PurchaseRequests
SET IDENTITY_INSERT [dbo].[PurchaseRequests] ON;
INSERT INTO [dbo].[PurchaseRequests] ([PurchaseRequestID], [RequesterUserID], [ItemName], [CategoryID], [Description], [Status], [Reaction], [CreatedDate]) VALUES (8, 8, N'calculator', 2, N'fff', N'Active', N'Purchased', N'17-09-2026 15:53:59');
SET IDENTITY_INSERT [dbo].[PurchaseRequests] OFF;
GO

-- SEED DATA: Payments
SET IDENTITY_INSERT [dbo].[Payments] ON;
INSERT INTO [dbo].[Payments] ([PaymentID], [RequestID], [ListingID], [PayerUserID], [Amount], [PaymentMethod], [TransactionRef], [PaymentStatus], [PaymentDate]) VALUES (17, 8, 18, 8, 2500.00, N'DemoPayment', N'28f21163-f8e7-4af3-8140-0c6e96d00d85', N'Success', N'17-09-2026 17:29:22');
INSERT INTO [dbo].[Payments] ([PaymentID], [RequestID], [ListingID], [PayerUserID], [Amount], [PaymentMethod], [TransactionRef], [PaymentStatus], [PaymentDate]) VALUES (21, NULL, 27, 8, 550.00, N'DemoPayment', N'TXN-SS-F3B79FA9-F49C-4C52-96C8-DBE743D52C9D', N'Success', N'19-10-2026 00:46:31');
INSERT INTO [dbo].[Payments] ([PaymentID], [RequestID], [ListingID], [PayerUserID], [Amount], [PaymentMethod], [TransactionRef], [PaymentStatus], [PaymentDate]) VALUES (22, NULL, 24, 8, 650.00, N'DemoPayment', N'TXN-SS-3C442EA6-19EF-4F52-A716-8FC3BEFE28AF', N'Success', N'14-10-2026 00:46:31');
INSERT INTO [dbo].[Payments] ([PaymentID], [RequestID], [ListingID], [PayerUserID], [Amount], [PaymentMethod], [TransactionRef], [PaymentStatus], [PaymentDate]) VALUES (23, NULL, 17, 12, 2500.00, N'DemoPayment', N'TXN-SS-BUY-13FFF20F-59D8-4EF6-B215-D8FCB9D95B61', N'Success', N'26-10-2026 00:46:31');
SET IDENTITY_INSERT [dbo].[Payments] OFF;
GO

-- SEED DATA: Complaints
SET IDENTITY_INSERT [dbo].[Complaints] ON;
INSERT INTO [dbo].[Complaints] ([ComplaintID], [UserID], [Category], [Subject], [Description], [RelatedListingID], [Priority], [Status], [AdminResponse], [ResolvedBy], [ResolvedDate], [CreatedDate], [LastModified]) VALUES (2, 12, N'Campus Support', N'Clarification on safe exchange pickup zones', N'Could the college administration confirm if the student center or central library lobby are official safe exchange zones for book swaps?', 25, N'Medium', N'Completed', N'Yes, the Central Library reception area and Student Activity Center lounge are officially monitored and designated as recommended safe student exchange zones.', 1, N'15-10-2026 00:46:31', N'13-10-2026 00:46:31', N'15-10-2026 00:46:31');
SET IDENTITY_INSERT [dbo].[Complaints] OFF;
GO

-- SEED DATA: ReplyNotifications
SET IDENTITY_INSERT [dbo].[ReplyNotifications] ON;
INSERT INTO [dbo].[ReplyNotifications] ([NotificationID], [UserID], [ListingID], [PurchaseRequestID], [IsRead], [CreatedDate]) VALUES (1, 8, 18, 8, 1, N'17-09-2026 17:17:07');
INSERT INTO [dbo].[ReplyNotifications] ([NotificationID], [UserID], [ListingID], [PurchaseRequestID], [IsRead], [CreatedDate]) VALUES (3, 12, 25, 1, 1, N'28-10-2026 21:46:31');
SET IDENTITY_INSERT [dbo].[ReplyNotifications] OFF;
GO

-- SEED DATA: ContactMessages
SET IDENTITY_INSERT [dbo].[ContactMessages] ON;
INSERT INTO [dbo].[ContactMessages] ([MessageID], [Name], [Email], [Subject], [Message], [Status], [AdminResponse], [RespondedBy], [ReceivedDate], [ResponseDate]) VALUES (3, N'Sanjay Rathi', N's@gmail.com', N'General', N'kj', N'New', NULL, NULL, N'19-01-2026 10:44:15', NULL);
SET IDENTITY_INSERT [dbo].[ContactMessages] OFF;
GO


