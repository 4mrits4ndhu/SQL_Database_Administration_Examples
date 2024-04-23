-- Create the Customer Group User
CREATE LOGIN customer_group_Alpha WITH PASSWORD = 'customer';
CREATE USER customer_group_Alpha FOR LOGIN customer_group_Alpha;

-- Grant privilege to customer_group_Alpha
GRANT SELECT ON Customer TO customer_group_Alpha;
GRANT SELECT ON Account TO customer_group_Alpha;
GRANT SELECT ON Loan TO customer_group_Alpha;
GRANT SELECT ON Payment TO customer_group_Alpha;

-- Create the Accountant Group User
CREATE LOGIN accountant_group_Alpha WITH PASSWORD = 'accountant';
CREATE USER accountant_group_Alpha FOR LOGIN accountant_group_Alpha;

-- Grant privilege to accountant_group_Alpha
GRANT SELECT ON Customer TO accountant_group_Alpha;
GRANT SELECT ON Account TO accountant_group_Alpha;
GRANT SELECT ON Loan TO accountant_group_Alpha;
GRANT SELECT ON Payment TO accountant_group_Alpha;

-- Deny UPDATE privilege to accountant_group_Alpha
DENY UPDATE ON Account TO accountant_group_Alpha;
DENY UPDATE ON Payment TO accountant_group_Alpha;
DENY UPDATE ON Loan TO accountant_group_Alpha;

-- Simulate login as customer_group_Alpha
EXECUTE AS LOGIN = 'customer_group_Alpha';

-- Test SELECT privileges
SELECT * FROM Customer;  
SELECT * FROM Account;   
SELECT * FROM Loan;     
SELECT * FROM Payment;   

-- Test UPDATE privilege (should fail)
UPDATE Account SET Balance = Balance + 1000;

REVERT;

-- Simulate login as accountant_group_Alpha
EXECUTE AS LOGIN = 'accountant_group_Alpha';

-- Test SELECT privileges
SELECT * FROM Customer; 
SELECT * FROM Account; 
SELECT * FROM Loan; 
SELECT * FROM Payment;

-- Test UPDATE privilege (should fail)
UPDATE Account SET Balance = Balance + 1000;

REVERT;



CREATE TABLE Audit
(
    ID INT PRIMARY KEY IDENTITY,
    Message NVARCHAR(MAX),
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
GO

--Trigger for the Customer table
CREATE TRIGGER trg_AfterInsert_Customer
ON Customer
AFTER INSERT
AS
BEGIN
    INSERT INTO Audit (Message)
    VALUES ('A new customer was added.')
END;
GO

--Trigger for the Payment table
CREATE TRIGGER trg_AfterInsert_Payment
ON Payment
AFTER INSERT
AS
BEGIN
    INSERT INTO Audit (Message)
    VALUES ('A loan payment was made.')
END;
GO

--Trigger for the Account table
CREATE TRIGGER trg_AfterInsert_Account
ON Account
AFTER INSERT
AS
BEGIN
    INSERT INTO Audit (Message)
    VALUES ('A new account was opened.')
END;
GO

--Make new customer to see if the audit log works
INSERT INTO Customer ([CustomerID], [Name], [HomeAddress])
VALUES ('123623', 'Fuse', '107 test street');
GO
--View the audit log to see if it worked
SELECT * FROM Audit

-- Replace the default clustered index with a new clustered index using a non-key attribute:
CREATE CLUSTERED INDEX IX_NewClusteredIndex
ON Account(AccountID);

--Replace the default clustered index with a new composite clustered index:

-- Drop the existing clustered index if it exists
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('Branch') AND index_id = 1)
    DROP INDEX PK_Branch ON Branch WITH (ONLINE = OFF);


-- Create a new composite clustered index
CREATE CLUSTERED INDEX IX_NewCompositeClusteredIndex
ON Branch(BranchID, BranchName);

-- Create a new composite nonclustered index
CREATE NONCLUSTERED INDEX IX_NewCompositeNonClusteredIndex
ON Branch(City, TotalDeposits);




--step4
ALTER TABLE dbo.account
ADD JsonAccount NVARCHAR(MAX);

UPDATE dbo.Account
SET JsonAccount = '{"key": "value"}';

--step5
ALTER TABLE branch
ADD SpatialColumn GEOMETRY;
