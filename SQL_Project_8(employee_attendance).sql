use college13;
select * from employee_attendance;

-- 1. Count of Present, Absent, and Leave per Employee
select employee_id, employee_name,
sum(case
    when status= 'present' then 1 else 0 end ) as Total_present,
sum(case
    when status= 'absent' then 1 else 0 end ) as total_absent,
sum(case
    when status= 'leave' then 1 else 0 end ) as total_leave
from employee_attendance
group by employee_id, employee_name
order by total_present desc;    



-- 2. Average Overtime Hours per Department
select department, round(avg(overtime_hours),2) as avg_overtime
from employee_attendance
where status='present'
group by department
order by avg_overtime desc;



-- 3. Employees with More Than 5 Late Records
select employee_id, employee_name, count(*) as late_count from employee_attendance
where late =1
group by employee_id, employee_name
having count(*) > 5
order by late_count desc;



-- 4. Average Productivity and Engagement by Department
select department, round(avg(productivity_score),2) as avg_productivity,
round(avg(engagement_score),2) as avg_engagement from employee_attendance
group by department order by avg_productivity desc;



-- 5. Top 5 Employees with Highest Overtime Hours
select employee_id, employee_name, sum(overtime_hours) as total_overtime 
from employee_attendance group by employee_id, employee_name
order by total_overtime desc limit 5;


-- 6. Productivity Comparison between Work Locations
select work_location, round(avg(productivity_score),2) as avg_productivity,
round(avg(engagement_score),2) as avg_engagement, count(distinct employee_id) as total_employees
from employee_attendance 
group by work_location;



-- 7. Rank Employees by Productivity using Window Function
select employee_id, employee_name, department, round(avg(productivity_score),2) as avg_productivity,
rank() over(partition by department order by avg(productivity_score) desc) as rank_in_dept
from employee_attendance group by employee_id, employee_name,department;



-- 8. Identify Consistently Late Employees
select employee_id, employee_name, count(*) as total_days, 
sum(case
    when late=1 then 1 else 0 end) as days_late,
round(100 * sum(case when late =1 then 1 else 0 end) / count(*),2) as late_percentage
from employee_attendance 
group by employee_id, employee_name
having late_percentage > 15
order by late_percentage desc;
    


-- 9. Employees with Productivity Below Department Average
select a.employee_id, a.employee_name, a.department, a.productivity_score, dept.avg_dept_productivity 
from employee_attendance a inner join 
(select department, avg(productivity_score) as avg_dept_productivity
from employee_attendance group by department) as dept 
on a.department = dept.department
where a.productivity_score < dept.avg_dept_productivity;



-- 10. Average Salary by Role and Work Location
select role, work_location, round(avg(salary),2) as avg_salary
from employee_attendance group by role, work_location 
order by avg_salary desc;


-- 11. Find Employees with Highest Engagement and Lowest Pending Tasks
select employee_id, employee_name, round(avg(engagement_score),2) as avg_engagement,
round(avg(pending_tasks),2) as avg_pending from employee_attendance
group by employee_id, employee_name
order by avg_engagement desc, avg_pending asc limit 10;



-- 12. Monthly Overtime Summary using Date Functions
select date_format(date,'%Y-%m') as month, department, 
round(sum(overtime_hours),2) as total_overtime,
round(avg(productivity_score),2) as avg_productivity
from employee_attendance
group by month, department
order by total_overtime desc;



-- 13. Using CTE: Most Productive Employee per Department
with deptproductivity as
(select department, employee_id, employee_name, round(avg(productivity_score),2) as avg_productivity,
rank() over (partition by department order by avg(productivity_score) desc) as rnk 
from employee_attendance group by department, employee_id, employee_name)
select * from deptproductivity
where rnk=1;



-- 14. Employee Performance Trend (Compare Current vs Previous Month Productivity)
select employee_id, employee_name,date_format(date,'%Y-%m') as month, round(avg(productivity_score),2) as avg_productivity,
lag(round(avg(productivity_score),2)) over (partition by employee_id order by date_format(date,'%Y-%m')) as prev_month_productivity,
round((avg(productivity_score) - lag(avg(productivity_score)) over (partition by employee_id order by date_format(date,'%Y-%m'))),2) as productivity_change
from employee_attendance group by employee_id, employee_name, date_format(date,'%Y-%m')
order by employee_id, month;




-- 15. Department Productivity vs Average Overtime Correlation
select department, round(avg(productivity_score),2) as avg_productivity, round(avg(overtime_hours),2) as avg_overtime,
round(avg(productivity_score) / nullif(avg(overtime_hours),0), 2) as productivity_efficiency
from employee_attendance group by department
order by productivity_efficiency desc;












































