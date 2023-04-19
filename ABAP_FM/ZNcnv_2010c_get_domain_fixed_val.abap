FUNCTION cnv_2010c_get_domain_fixed_val.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(V_DOMNAME) TYPE  DOMNAME
*"  EXPORTING
*"     VALUE(V_DOMNAME_1) TYPE  DOMNAME
*"  TABLES
*"      ET_DOMAIN_FIXED_VAL TYPE  CNV_2010C_T_DOMAIN_FIXED_VALUE
*"       OPTIONAL
*"      RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"----------------------------------------------------------------------

 

* Data Decleration
  DATA s_bapi_ret TYPE bapiret2.

 

* Check if v_domname is empty
  IF v_domname IS INITIAL.
*   fill bapiret2
    CALL FUNCTION 'CNV_2010C_FILL_BAPIRET2'
      EXPORTING
        type   = 'E'
        cl     = 'CNV_2010C'
        number = '000'
      IMPORTING
        return = s_bapi_ret.

 

    s_bapi_ret-message = text-012.

 

    APPEND s_bapi_ret TO return.
    RETURN.
  ENDIF.

 

* Select data from table DD07T
  SELECT ddlanguage valpos domvalue_l ddtext
    FROM dd07t INTO CORRESPONDING FIELDS OF TABLE et_domain_fixed_val
    WHERE domname = v_domname AND ddlanguage EQ sy-langu AND as4local EQ 'A'.

 

  IF sy-subrc EQ 0.
    SORT et_domain_fixed_val ASCENDING BY valpos.
    v_domname_1 = v_domname.
  ELSE.
* Select data from table DD07T for langu eq EN
    SELECT ddlanguage valpos domvalue_l ddtext
      FROM dd07t INTO CORRESPONDING FIELDS OF TABLE et_domain_fixed_val
      WHERE domname = v_domname AND ddlanguage EQ 'E' AND as4local EQ 'A'.
    IF sy-subrc EQ 0 .
      SORT et_domain_fixed_val ASCENDING BY valpos.
      v_domname_1 = v_domname.
    ELSE.
*   fill bapiret2
      CALL FUNCTION 'CNV_2010C_FILL_BAPIRET2'
        EXPORTING
          type   = 'E'
          cl     = 'CNV_2010C'
          number = '000'
        IMPORTING
          return = s_bapi_ret.

 

      s_bapi_ret-message = text-013.

 

      APPEND s_bapi_ret TO return.
    ENDIF.
  ENDIF.

 

ENDFUNCTION.
