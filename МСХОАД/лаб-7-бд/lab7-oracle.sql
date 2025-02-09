select * from grades;

TRUNCATE TABLE Grades;
ALTER SEQUENCE seq_grade_id RESTART;

DECLARE
    v_Grade NUMBER(3,2); 
    v_Date DATE;
    v_StudentID NUMBER;
    v_StudentSubjectID NUMBER;

    CURSOR c_Students IS 
        SELECT StudentID 
        FROM Student;

    CURSOR c_StudentSubjects(p_StudentID NUMBER) IS 
        SELECT StudentSubjectID 
        FROM StudentSubject 
        WHERE StudentID = p_StudentID;
BEGIN
    FOR v_Student IN c_Students LOOP
        FOR v_StudentSubject IN c_StudentSubjects(v_Student.StudentID) LOOP
            FOR year_offset IN -2..0 LOOP
                v_Date := TO_DATE('01-09-2023', 'DD-MM-YYYY') + (year_offset * 12 * 30) 
                          + FLOOR(DBMS_RANDOM.VALUE(0, 60));
                v_Grade := ROUND(DBMS_RANDOM.VALUE(1, 10), 2);
                AddStudentGrade(
                    p_StudentSubjectID => v_StudentSubject.StudentSubjectID, 
                    p_Grade => v_Grade, 
                    p_Date => v_Date
                );

                -- ¬есной (1 феврал€)
                v_Date := TO_DATE('01-02-2023', 'DD-MM-YYYY') + ((year_offset + 1) * 12 * 30) 
                          + FLOOR(DBMS_RANDOM.VALUE(0, 60));
                v_Grade := ROUND(DBMS_RANDOM.VALUE(1, 10), 2);
                AddStudentGrade(
                    p_StudentSubjectID => v_StudentSubject.StudentSubjectID, 
                    p_Grade => v_Grade, 
                    p_Date => v_Date
                );
            END LOOP;
        END LOOP;
    END LOOP;
END;


-- ѕостройте при помощи конструкции MODEL запросы, которые разрабатывают план успеваемости дл€ каждого студента на следующий год
-- с учетом успеваемости за предыдущие годы (предложить варианты зависимостей).
WITH AvgGrades AS (
    SELECT 
        s.StudentID,
        EXTRACT(YEAR FROM g."Date") AS GradeYear,
        ROUND(AVG(g.Grade), 2) AS AvgGrade
    FROM Student s
    JOIN StudentSubject ss ON s.StudentID = ss.StudentID
    JOIN Grades g ON ss.StudentSubjectID = g.StudentSubjectID
    GROUP BY 
        s.StudentID, 
        EXTRACT(YEAR FROM g."Date")
),
GradePlan AS (
    SELECT * 
    FROM AvgGrades
    MODEL
        PARTITION BY (StudentID)
        DIMENSION BY (GradeYear)
        MEASURES (AvgGrade)
        RULES (
            -- ѕрогноз на 2025 год: если в 2024 году улучшение, то увеличиваем, если ухудшение - уменьшаем
            AvgGrade[2025] = 
                CASE
                    WHEN AvgGrade[2024] > AvgGrade[2023] THEN 
                        AvgGrade[2024] + (AvgGrade[2024] - AvgGrade[2023]) * 0.5
                    WHEN AvgGrade[2024] < AvgGrade[2023] THEN 
                        AvgGrade[2024] - (AvgGrade[2023] - AvgGrade[2024]) * 0.3
                    ELSE AvgGrade[2024]
                END
        )
)
SELECT 
    StudentID, 
    -- —редний балл за 2023 год, 2024 год и прогноз на 2025 год
    MAX(CASE WHEN GradeYear = 2023 THEN AvgGrade END) AS AvgGrade_2023,
    MAX(CASE WHEN GradeYear = 2024 THEN AvgGrade END) AS AvgGrade_2024,
    MAX(CASE WHEN GradeYear = 2025 THEN AvgGrade END) AS AvgGrade_2025
FROM GradePlan
GROUP BY StudentID
ORDER BY StudentID;


-- Ќайдите при помощи конструкции MATCH_RECOGNIZE() данные, которые соответствуют шаблону: ѕадение, рост, падение успеваемости дл€ каждой группы
WITH MonthlyGradeChanges AS (
    SELECT 
        s.GroupID,
        EXTRACT(YEAR FROM g."Date") AS GradeYear,
        EXTRACT(MONTH FROM g."Date") AS GradeMonth,
        ROUND(AVG(g.Grade), 2) AS AvgGrade
    FROM Student s
    JOIN StudentSubject ss ON s.StudentID = ss.StudentID
    JOIN Grades g ON ss.StudentSubjectID = g.StudentSubjectID
    GROUP BY 
        s.GroupID, 
        EXTRACT(YEAR FROM g."Date"),
        EXTRACT(MONTH FROM g."Date")
)
SELECT *
FROM MonthlyGradeChanges
MATCH_RECOGNIZE (
    PARTITION BY GroupID
    ORDER BY GradeYear, GradeMonth
    MEASURES 
        STRT.GradeYear AS start_year,
        STRT.GradeMonth AS start_month,
        STRT.AvgGrade AS start_grade,
        LAST(UP.GradeYear) AS up_year,
        LAST(UP.GradeMonth) AS up_month,
        LAST(UP.AvgGrade) AS up_grade,
        LAST(DOWN.GradeYear) AS down_year,
        LAST(DOWN.GradeMonth) AS down_month,
        LAST(DOWN.AvgGrade) AS down_grade
    ONE ROW PER MATCH
    AFTER MATCH SKIP TO LAST DOWN
    PATTERN (STRT DOWN+ UP+ DOWN+)
    DEFINE
        DOWN AS DOWN.AvgGrade < PREV(DOWN.AvgGrade),
        UP AS UP.AvgGrade > PREV(UP.AvgGrade)
) MR
ORDER BY MR.GroupID, MR.start_year, MR.start_month;



