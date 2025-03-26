-- Найти всех сотрудников, подчиняющихся Ивану Иванову с EmployeeID = 1, включая их подчиненных и подчиненных подчиненных. Для каждого сотрудника вывести следующую информацию:
-- 
-- EmployeeID: идентификатор сотрудника.
-- Имя сотрудника.
-- Идентификатор менеджера.
-- Название отдела, к которому он принадлежит.
-- Название роли, которую он занимает.
-- Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
-- Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
-- Общее количество задач, назначенных этому сотруднику.
-- Общее количество подчиненных у каждого сотрудника (не включая подчиненных их подчиненных).
-- Если у сотрудника нет назначенных проектов или задач, отобразить NULL.

WITH RECURSIVE employee_hierarchy AS (
    -- Начинаем с Ивана Иванова
    SELECT
        EmployeeID,
        Name,
        ManagerID,
        DepartmentID,
        RoleID
    FROM employees
    WHERE EmployeeID = 1
    UNION ALL
    -- Рекурсивно выбираем всех подчиненных сотрудников
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM employees e
    INNER JOIN employee_hierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT
    eh.EmployeeID,
    eh.Name,
    eh.ManagerID,
    d.DepartmentName,
    r.RoleName,
    COALESCE(STRING_AGG(DISTINCT p.ProjectName, ', ' ORDER BY p.ProjectName), 'NULL') AS Projects,
    COALESCE(STRING_AGG(DISTINCT t.TaskName, ', ' ORDER BY t.TaskName), 'NULL') AS Tasks,
    COUNT(DISTINCT t.TaskID) AS TotalTasks,
    (SELECT COUNT(*)
     FROM employees e2
     WHERE e2.ManagerID = eh.EmployeeID) AS TotalSubordinates
FROM employee_hierarchy eh
LEFT JOIN departments d ON eh.DepartmentID = d.DepartmentID
LEFT JOIN roles r ON eh.RoleID = r.RoleID
LEFT JOIN projects p ON p.DepartmentID = eh.DepartmentID
LEFT JOIN tasks t ON t.AssignedTo = eh.EmployeeID
GROUP BY eh.EmployeeID, eh.Name, eh.ManagerID, d.DepartmentName, r.RoleName
ORDER BY eh.Name;
