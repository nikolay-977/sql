-- Найти всех сотрудников, которые занимают роль менеджера и имеют подчиненных (то есть число подчиненных больше 0). Для каждого такого сотрудника вывести следующую информацию:
-- 
-- EmployeeID: идентификатор сотрудника.
-- Имя сотрудника.
-- Идентификатор менеджера.
-- Название отдела, к которому он принадлежит.
-- Название роли, которую он занимает.
-- Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
-- Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
-- Общее количество подчиненных у каждого сотрудника (включая их подчиненных).
-- Если у сотрудника нет назначенных проектов или задач, отобразить NULL.

WITH RECURSIVE subordinate_count AS (
    -- Начинаем с сотрудников, которые занимают роль менеджера
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID,
        1 AS Level
    FROM employees e
    INNER JOIN roles r ON e.RoleID = r.RoleID
    WHERE r.RoleName = 'Менеджер'
    UNION ALL
    -- Рекурсивно выбираем всех подчиненных сотрудников
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID,
        sc.Level + 1
    FROM employees e
    INNER JOIN subordinate_count sc ON e.ManagerID = sc.EmployeeID
)
SELECT
    sc.EmployeeID,
    sc.Name,
    sc.ManagerID,
    d.DepartmentName,
    r.RoleName,
    COALESCE(STRING_AGG(DISTINCT p.ProjectName, ', ' ORDER BY p.ProjectName), 'NULL') AS Projects,
    COALESCE(STRING_AGG(DISTINCT t.TaskName, ', ' ORDER BY t.TaskName), 'NULL') AS Tasks,
    COUNT(DISTINCT sub.EmployeeID) AS TotalSubordinates
FROM subordinate_count sc
LEFT JOIN departments d ON sc.DepartmentID = d.DepartmentID
LEFT JOIN roles r ON sc.RoleID = r.RoleID
LEFT JOIN projects p ON p.DepartmentID = sc.DepartmentID
LEFT JOIN tasks t ON t.AssignedTo = sc.EmployeeID
LEFT JOIN employees sub ON sub.ManagerID = sc.EmployeeID  -- Подсчет подчиненных
GROUP BY sc.EmployeeID, sc.Name, sc.ManagerID, d.DepartmentName, r.RoleName
HAVING COUNT(DISTINCT sub.EmployeeID) > 0  -- Провекра, что есть подчиненные
ORDER BY sc.Name;
