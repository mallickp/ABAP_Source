FUNCTION CNV_2010C_FILL_BAPIRET2 .
*"---------------------------------------------------------------------- *
"*"Local Interface: *"  IMPORTING *"
VALUE(TYPE) LIKE  BAPIRETURN-TYPE *"
 VALUE(CL) LIKE  SY-MSGID *"
 VALUE(NUMBER) LIKE  SY-MSGNO *"
   VALUE(PAR1) LIKE  SY-MSGV1 DEFAULT SPACE *"
   VALUE(PAR2) LIKE  SY-MSGV2 DEFAULT SPACE *"
   VALUE(PAR3) LIKE  SY-MSGV3 DEFAULT SPACE *"
   VALUE(PAR4) LIKE  SY-MSGV4 DEFAULT SPACE *"
   VALUE(LOG_NO) LIKE  BAPIRETURN-LOG_NO DEFAULT SPACE *"
VALUE(LOG_MSG_NO) LIKE  BAPIRETURN-LOG_MSG_NO DEFAULT SPACE *"
VALUE(PARAMETER) LIKE  BAPIRET2-PARAMETER DEFAULT SPACE *"
VALUE(ROW) LIKE  BAPIRET2-ROW DEFAULT 0 *"
VALUE(FIELD) LIKE  BAPIRET2-FIELD DEFAULT SPACE *"
EXPORTING *"
REFERENCE(RETURN) LIKE  BAPIRET2 STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------
****** Copied from  BALW_BAPIRETURN_GET2 and BCA_API_BAPIRET2_FILL *****
****** Copied from FS_BAPI_BAPIRET2_FILL
**----------------------------------------------------------------------
 TABLES: T100.   CLEAR RETURN.
 * PROCESS FIELD RETURN-TYPE.
 RETURN-TYPE = TYPE.
 * PROCESS FIELD ID, NUMBER   RETURN-ID = CL.
 RETURN-NUMBER = NUMBER.
 * PROCESS MESSAGE VARIABLES
 RETURN-MESSAGE_V1 = PAR1.
 RETURN-MESSAGE_V2 = PAR2.
 RETURN-MESSAGE_V3 = PAR3.
 RETURN-MESSAGE_V4 = PAR4.
 * Field DESCRIPTION
 RETURN-PARAMETER = PARAMETER.
 RETURN-ROW       = ROW.
 RETURN-FIELD     = FIELD.
 * LOGICAL SYSTEM-ID
 CALL FUNCTION OWN_LOGICAL_SYSTEM_GET_STABLE'
IMPORTING       OWN_LOGICAL_SYSTEM = RETURN-SYSTEM.
*============================================================
* THE ABAP command message ... into SUPPORT only THE standard * message types (A,E,I,W,S,X) no other
TYPES ARE SUPPORTED   MESSAGE ID     CL
TYPE   TYPE           NUMBER NUMBER
 WITH   PAR1                  PAR2
 PAR3                  PAR4
 INTO   RETURN-MESSAGE.
*=============================================================
 * PROCESS FIELD RETURN LOG_NO
 RETURN-LOG_NO = LOG_NO.
 * PROCESS FIELD RETURN LOG_MSG_NO
 RETURN-LOG_MSG_NO = LOG_MSG_NO.
 ENDFUNCTION.
 AND FUNCTION CNV_2010C_GET_DOMAIN_FIXED_VAL.
*"---------------------------------------------------------------------- *
"*"Local Interface: *"
 IMPORTING *"
 VALUE(IV_DOMNAME) TYPE  DOMNAME *"
 EXPORTING *"     VALUE(EV_DOMNAME) TYPE  DOMNAME
 *"  TABLES *"      ET_DOMAIN_FIXED_VAL TYPE
CNV_2010C_T_DOMAIN_FIXED_VALUE *"       OPTIONAL *"
      RETURN STRUCTURE  BAPIRET2 OPTIONAL
      *"----------------------------------------------------------------------
      * Data Decleration   DATA LS_BAPI_RET TYPE BAPIRET2.
      * Check IF IV_DOMNAME IS EMPTY   IF
IV_DOMNAME IS INITIAL. *
FILL BAPIRET2
 CALL FUNCTION 'CNV_2010C_FILL_BAPIRET2'
 EXPORTING
 TYPE   = 'E'
 CL     = 'CNV_2010C'
 NUMBER = '000'
 IMPORTING
 RETURN = LS_BAPI_RET.
 LS_BAPI_RET-MESSAGE = TEXT-012.
    APPEND LS_BAPI_RET TO RETURN.
    RETURN.   ENDIF.
    * Select DATA FROM TABLE DD07T
    SELECT DDLANGUAGE VALPOS DOMVALUE_L DDTEXT
    FROM DD07T INTO CORRESPONDING FIELDS OF TABLE ET_DOMAIN_FIXED_VAL
    WHERE DOMNAME = IV_DOMNAME
    AND DDLANGUAGE EQ
SY-LANGU AND AS4LOCAL EQ 'A'.
 IF SY-SUBRC EQ 0.
 SORT ET_DOMAIN_FIXED_VAL ASCENDING BY VALPOS.
 EV_DOMNAME = IV_DOMNAME.
 ELSE. * Select DATA FROM TABLE DD07T FOR LANGU EQ EN
 SELECT DDLANGUAGE VALPOS DOMVALUE_L DDTEXT       FROM DD07T INTO
CORRESPONDING FIELDS OF TABLE ET_DOMAIN_FIXED_VAL
 WHERE DOMNAME = IV_DOMNAME AND DDLANGUAGE EQ 'E' AND AS4LOCAL EQ 'A'.
 IF SY-SUBRC EQ 0 .
 SORT ET_DOMAIN_FIXED_VAL ASCENDING BY VALPOS.
    EV_DOMNAME = IV_DOMNAME.     ELSE. *   FILL
BAPIRET2       CALL FUNCTION 'CNV_2010C_FILL_BAPIRET2'
       EXPORTING
       TYPE   = 'E'
       CL     = 'CNV_2010C'
       NUMBER = '000'
       IMPORTING
       RETURN = LS_BAPI_RET.
       LS_BAPI_RET-MESSAGE = TEXT-013.
       APPEND LS_BAPI_RET TO RETURN.
       ENDIF.   ENDIF. ENDFUNCTION.
