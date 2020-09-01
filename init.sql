create table amazing_report_3 as
select id,
       md5(random()::text) as uuid,
       floor(random() * 9 + 1) as user_id,
       floor(random() * 9 + 1) as place_id,
       random() * 2.0000 + -25.000 as latitude,
       random() * 2 + 15 as longitude,
       (array[True, False, null])[floor(random() * 3 + 1)] as successful,
       (array['MethodA', 'MethodB', 'MethodC'])[floor(random() * 3 + 1)] as method,
       NOW() + (random() * (NOW()+'90 days' - NOW())) + '30 days' as timestamp,
       null as address
from generate_Series(1, 150000) id;