
-- Adnan Ahmed Layek

-- Creating EliteBooks database
CREATE DATABASE EliteBooks;
GO

USE EliteBooks;
GO

-- Publisher Table
CREATE TABLE Publisher (
    PublisherID INT IDENTITY(1,1) PRIMARY KEY,
    PublisherName NVARCHAR(100) NOT NULL UNIQUE
);

-- Book Table
CREATE TABLE Book (
    ISBN CHAR(13) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Category NVARCHAR(50) NOT NULL,
    Format NVARCHAR(20) NOT NULL,
    PageCount INT CHECK (PageCount > 0),
    Price DECIMAL(10,2) CHECK (Price >= 0),
    PublisherID INT FOREIGN KEY REFERENCES Publisher(PublisherID)
);

-- Branch Table
CREATE TABLE Branch (
    BranchID INT IDENTITY(1,1) PRIMARY KEY,
    BranchName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255) NOT NULL
);

-- Schedule Table (Opening Hours)
CREATE TABLE Schedule (
    ScheduleID INT IDENTITY(1,1) PRIMARY KEY,
    BranchID INT NOT NULL FOREIGN KEY REFERENCES Branch(BranchID),
    StartDay NVARCHAR(3) NOT NULL CHECK (StartDay IN ('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun')),
    EndDay NVARCHAR(3) NOT NULL CHECK (EndDay IN ('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun')),
    OpenTime TIME NOT NULL,
    CloseTime TIME NOT NULL
);

-- Staff Table
CREATE TABLE Staff (
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Role NVARCHAR(50) NOT NULL CHECK (Role IN ('Sales Assistant', 'Stock Manager', 'Supervisor')),
    EmploymentType NVARCHAR(10) NOT NULL CHECK (EmploymentType IN ('Permanent', 'Casual')),
    AnnualSalary DECIMAL(10,2),
    HourlyRate DECIMAL(5,2),
    SupervisorID INT FOREIGN KEY REFERENCES Staff(StaffID),
    BranchID INT NOT NULL FOREIGN KEY REFERENCES Branch(BranchID),
    CHECK (
        (EmploymentType = 'Permanent' AND AnnualSalary IS NOT NULL AND HourlyRate IS NULL) OR
        (EmploymentType = 'Casual' AND HourlyRate IS NOT NULL AND AnnualSalary IS NULL)
    )
);

-- Member Table
CREATE TABLE Member (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    MembershipType NVARCHAR(10) NOT NULL CHECK (MembershipType IN ('Platinum', 'Gold', 'Silver')),
    ExpiryDate DATE NOT NULL,
    BranchID INT NOT NULL FOREIGN KEY REFERENCES Branch(BranchID)
);

-- Book_Branch Table (Inventory)
CREATE TABLE Book_Branch (
    ISBN CHAR(13) FOREIGN KEY REFERENCES Book(ISBN),
    BranchID INT FOREIGN KEY REFERENCES Branch(BranchID),
    StockLevel INT NOT NULL CHECK (StockLevel >= 0),
    PRIMARY KEY (ISBN, BranchID)
);








-- Generated random data for convinience
-- Insert Publishers
INSERT INTO Publisher (PublisherName) VALUES
('Penguin Random House'),
('Bloomsbury'),
('HarperCollins'),
('Scholastic'),
('Macmillan');

-- Insert Books (Harry Potter uses ISBN from Part A)
INSERT INTO Book (ISBN, Title, Category, Format, PageCount, Price, PublisherID) VALUES
('9780747532743', 'Harry Potter and the Philosopher’s Stone', 'Fiction', 'Hardcover', 223, 20.99, 2),
('9780061120084', 'To Kill a Mockingbird', 'Fiction', 'Paperback', 281, 12.99, 3),
('9780141182636', '1984', 'Fiction', 'eBook', 328, 9.99, 1),
('9780544003415', 'The Hobbit', 'Fiction', 'Hardcover', 310, 18.99, 4),
('9780141439518', 'Pride and Prejudice', 'Fiction', 'Paperback', 279, 10.99, 1);

-- Insert Branches
INSERT INTO Branch (BranchName, Address) VALUES
('Melbourne CBD', '123 Collins St'),
('Richmond', '45 Bridge Rd'),
('St Kilda', '78 Acland St'),
('Fitzroy', '22 Brunswick St'),
('Southbank', '1 Southbank Blvd');

-- Insert Book_Branch (Ensure 5 copies of Harry Potter)
INSERT INTO Book_Branch (ISBN, BranchID, StockLevel) VALUES
('9780747532743', 1, 5),  -- Melbourne CBD has 5 copies
('9780747532743', 2, 3),
('9780061120084', 1, 10),
('9780141182636', 3, 7),
('9780544003415', 4, 4);

-- Insert Members with Expiry Dates
INSERT INTO Member (FirstName, LastName, Email, MembershipType, ExpiryDate, BranchID) VALUES
('John', 'Doe', 'john@email.com', 'Gold', '2026-01-15', 1),
('Jane', 'Smith', 'jane@email.com', 'Platinum', '2026-01-20', 1),
('Bob', 'Brown', 'bob@email.com', 'Silver', '2025-12-01', 2),
('Alice', 'White', 'alice@email.com', 'Gold', '2025-05-02', 3),
('Charlie', 'Green', 'charlie@email.com', 'Silver', '2025-05-12', 1);



-- Query 1: Branches with >=5 copies of "Harry Potter (ISBN Specified)"
SELECT B.BranchID, B.BranchName
FROM Book_Branch BB
JOIN Branch B ON BB.BranchID = B.BranchID
WHERE BB.ISBN = '9780747532743' AND BB.StockLevel >= 5;


-- Query 2: Emails of members expiring next month (relative to current date)
SELECT M.BranchID, M.ExpiryDate, M.Email
FROM Member AS M
WHERE YEAR(M.ExpiryDate) = YEAR(DATEADD(month, 1, GETDATE()))
  AND MONTH(M.ExpiryDate) = MONTH(DATEADD(month, 1, GETDATE()))
ORDER BY M.BranchID ASC, M.ExpiryDate ASC, M.Email ASC;
