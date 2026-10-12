-- Preserve the previous values before changing the role vocabulary.
create table app_user_role_backup as
select id as user_id, role as previous_role, display_name as previous_display_name
from app_user;

-- Map both roles in one statement: the old counter role must not gain management rights.
update app_user
set role = case role
    when 'ADMIN' then 'LIBRARIAN'
    when 'LIBRARIAN' then 'STAFF'
    else role
end,
display_name = case
    when role = 'ADMIN' and email = 'admin@library.local' and display_name = 'Quản trị viên' then 'Thủ thư'
    when role = 'LIBRARIAN' and email = 'librarian@library.local' and display_name = 'Thủ thư' then 'Nhân viên'
    else display_name
end;
