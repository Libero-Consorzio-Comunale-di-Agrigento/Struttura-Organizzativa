CREATE OR REPLACE FORCE VIEW VISTA_OGGETTI_INVALIDI
(OBJECT_NAME, OBJECT_TYPE, STATUS, TABLE_NAME, TRIGGER_STATUS)
BEQUEATH DEFINER
AS 
SELECT user_objects.object_name,
          user_objects.object_type,
          user_objects.status,
          user_triggers.table_name,
          user_triggers.status trigger_status
     FROM user_objects, user_triggers
    WHERE     (user_objects.object_name = user_triggers.trigger_name(+))
          AND (   (user_triggers.status = 'DISABLED')
               OR (user_objects.status = 'INVALID'))
          AND user_objects.object_name NOT LIKE 'BIN$%'
   UNION
   SELECT user_constraints.constraint_name,
          'CONSTRAINT',
          '',
          user_constraints.table_name,
          user_constraints.status
     FROM user_constraints
    WHERE     user_constraints.status = 'DISABLED'
          AND user_constraints.constraint_name NOT LIKE 'BIN$%';


