USE university;

ALTER SEQUENCE seq_teacher_id RESTART;
ALTER SEQUENCE seq_department_id RESTART;




delete from DepartmentFaculty;
delete from Department;
delete from Teacher;

select * from Department;


SELECT * FROM Teacher;

-- 1.��� ���� ������ � ���� SQL Server �������� ��� ����� �� ������ ������� ������ �������������� ����. 
ALTER TABLE Teacher
ADD PositionHierarchy HIERARCHYID;

-- ��������� ��������� ���������� ����������� (3. ������� ���������, ������� ������� ����������� ���� (�������� � �������� ����))
GO
CREATE OR ALTER PROCEDURE AddTeacher
    @FullName NVARCHAR(200),
    @DepartmentID INT,
    @Role NVARCHAR(200),
    @ParentTeacherID INT = NULL
AS
BEGIN
    DECLARE @NewTeacherID INT = NEXT VALUE FOR seq_teacher_id;
    DECLARE @PositionHierarchy HIERARCHYID;
    DECLARE @LastChild HIERARCHYID;
    DECLARE @ParentHierarchy HIERARCHYID;

    IF @ParentTeacherID IS NULL
    BEGIN
        SET @PositionHierarchy = HIERARCHYID::GetRoot();
    END
    ELSE
    BEGIN
        SELECT @ParentHierarchy = PositionHierarchy
        FROM Teacher
        WHERE TeacherID = @ParentTeacherID;

        SELECT @LastChild = MAX(PositionHierarchy)
        FROM Teacher
        WHERE PositionHierarchy.GetAncestor(1) = @ParentHierarchy;

        SET @PositionHierarchy = @ParentHierarchy.GetDescendant(@LastChild, NULL);
    END

    INSERT INTO Teacher (TeacherID, FullName, DepartmentID, Role, PositionHierarchy)
    VALUES (@NewTeacherID, @FullName, @DepartmentID, @Role, @PositionHierarchy);
END;


DECLARE @NewDepartmentID INT;

INSERT INTO Department (DepartmentID, DepartmentName)
VALUES 
    (NEXT VALUE FOR seq_department_id, '������� ����������'),
    (NEXT VALUE FOR seq_department_id, '������� ������'),
    (NEXT VALUE FOR seq_department_id, '������� �����������'),
    (NEXT VALUE FOR seq_department_id, '������� �����'),
    (NEXT VALUE FOR seq_department_id, '������� ��������'),
    (NEXT VALUE FOR seq_department_id, '������� �������'),
    (NEXT VALUE FOR seq_department_id, '������� ���������');

SELECT * FROM Department;

GO
DECLARE @DepartmentID INT;
DECLARE @ParentTeacherID INT;

EXEC AddTeacher @FullName = '������ ���� ������', @DepartmentID = NULL, @Role = '������', @ParentTeacherID = NULL;

-- ������� ���������� (��������� 1)
SET @DepartmentID = 1;
EXEC AddTeacher @FullName = '����� ������� ����� ����������', @DepartmentID = @DepartmentID, @Role = '�����', @ParentTeacherID = 1;
EXEC AddTeacher @FullName = '������� ���� ���������', @DepartmentID = @DepartmentID, @Role = '������', @ParentTeacherID = 2;
EXEC AddTeacher @FullName = '������� ������� ��������', @DepartmentID = @DepartmentID, @Role = '���������', @ParentTeacherID = 3;

-- ������� ������ (��������� 2)
SET @DepartmentID = 2;
EXEC AddTeacher @FullName = '����� ������� ���� ����������', @DepartmentID = @DepartmentID, @Role = '�����', @ParentTeacherID = 1;
EXEC AddTeacher @FullName = '�������� ������� ��������', @DepartmentID = @DepartmentID, @Role = '������', @ParentTeacherID = 5;
EXEC AddTeacher @FullName = '������� ����� ����������', @DepartmentID = @DepartmentID, @Role = '������� �������������', @ParentTeacherID = 6;

-- ������� ����������� (��������� 3)
SET @DepartmentID = 3;
EXEC AddTeacher @FullName = '����� �������� �������� ����������', @DepartmentID = @DepartmentID, @Role = '�����', @ParentTeacherID = 1;
EXEC AddTeacher @FullName = '������� �������� ����������', @DepartmentID = @DepartmentID, @Role = '������', @ParentTeacherID = 8;
EXEC AddTeacher @FullName = '�������� ����� ���������', @DepartmentID = @DepartmentID, @Role = '���������', @ParentTeacherID = 9;
DECLARE @DepartmentID INT;
DECLARE @ParentTeacherID INT;
EXEC AddTeacher @FullName = '�������� ����� ���������', @DepartmentID = @DepartmentID, @Role = '���������', @ParentTeacherID = 13;


-- 2.������� ���������, ������� ��������� ��� ����������� ���� � ��������� ������ �������� (�������� � �������� ����).
GO
CREATE PROCEDURE GetTeacherHierarchy
    @TeacherID INT
AS
BEGIN
    DECLARE @HierarchyID HIERARCHYID;

    SELECT @HierarchyID = PositionHierarchy FROM Teacher WHERE TeacherID = @TeacherID;

    SELECT 
        T.TeacherID,
        T.FullName,
        T.Role,
        T.DepartmentID,
        T.PositionHierarchy.ToString() AS HierarchyPath,
        T.PositionHierarchy.GetLevel() AS HierarchyLevel
    FROM Teacher T
    WHERE T.PositionHierarchy.IsDescendantOf(@HierarchyID) = 1
    ORDER BY T.PositionHierarchy;
END;


EXEC GetTeacherHierarchy @TeacherID = 1;


-- 4.������� ���������, ������� ���������� ��� ����������� ����� (������ �������� � �������� �������� ������������� ����,
-- ������ �������� � �������� ����, � ������� ���������� �����������).
GO
CREATE OR ALTER PROCEDURE MoveTeacherBranch (
    @SourceTeacherID INT,
    @TargetTeacherID INT 
)
AS
BEGIN
    DECLARE @SourceHierarchy HIERARCHYID;
    DECLARE @TargetHierarchy HIERARCHYID;
    DECLARE @NewHierarchy HIERARCHYID;

    SELECT @SourceHierarchy = PositionHierarchy FROM Teacher WHERE TeacherID = @SourceTeacherID;

    SELECT @TargetHierarchy = PositionHierarchy FROM Teacher WHERE TeacherID = @TargetTeacherID;

    IF @TargetHierarchy.IsDescendantOf(@SourceHierarchy) = 1
    BEGIN
        RAISERROR('���������� ����������� ���� � ��� �������', 16, 1);
        RETURN;
    END

    DECLARE @LastChild HIERARCHYID;
    SELECT @LastChild = MAX(PositionHierarchy) FROM Teacher WHERE PositionHierarchy.GetAncestor(1) = @TargetHierarchy;

    SET @NewHierarchy = @TargetHierarchy.GetDescendant(@LastChild, NULL);

    WITH CTE_Teachers AS (
        SELECT TeacherID, PositionHierarchy 
        FROM Teacher 
        WHERE PositionHierarchy.IsDescendantOf(@SourceHierarchy) = 1
    )

    UPDATE T 
    SET T.PositionHierarchy = CTE.PositionHierarchy.GetReparentedValue(@SourceHierarchy, @NewHierarchy) 
    FROM Teacher T 
    JOIN CTE_Teachers CTE ON T.TeacherID = CTE.TeacherID;
END;

EXEC MoveTeacherBranch @SourceTeacherID = 5, @TargetTeacherID = 11;
EXEC GetTeacherHierarchy @TeacherID = 1;