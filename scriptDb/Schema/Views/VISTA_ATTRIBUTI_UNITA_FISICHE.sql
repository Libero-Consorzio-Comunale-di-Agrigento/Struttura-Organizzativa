CREATE OR REPLACE FORCE VIEW VISTA_ATTRIBUTI_UNITA_FISICHE
(PROGR_UNITA_FISICA)
BEQUEATH DEFINER
AS 
select progr_unita_fisica 
  from anagrafe_unita_fisiche
 where trunc(sysdate) between dal and nvl(al,to_date(3333333,'j'));


