FUNCTION cnv_2010c_get_domain_fixed_val.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_DOMNAME) TYPE  DOMNAME
*"  EXPORTING
*"     VALUE(EV_DOMNAME) TYPE  DOMNAME
*"  TABLES
*"      ET_DOMAIN_FIXED_VAL TYPE  CNV_2010C_T_DOMAIN_FIXED_VALUE
*"       OPTIONAL
*"      RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"----------------------------------------------------------------------

* Data Decleration
  DATA ls_bapi_ret TYPE bapiret2.

* Check if iv_domname is empty
  IF iv_domname IS INITIAL.
*   fill bapiret2
    CALL FUNCTION 'CNV_2010C_FILL_BAPIRET2'
      EXPORTING
        type   = 'E'
        cl     = 'CNV_2010C'
        number = '000'
      IMPORTING
        return = ls_bapi_ret.

    ls_bapi_ret-message = text-012.

    APPEND ls_bapi_ret TO return.
    RETURN.
  ENDIF.

* Select data from table DD07T
  SELECT ddlanguage valpos domvalue_l ddtext
    FROM dd07t INTO CORRESPONDING FIELDS OF TABLE et_domain_fixed_val
    WHERE domname = iv_domname AND ddlanguage EQ sy-langu AND as4local EQ 'A'.

  IF sy-subrc EQ 0.
    SORT et_domain_fixed_val ASCENDING BY valpos.
    ev_domname = iv_domname.
  ELSE.
* Select data from table DD07T for langu eq EN
    SELECT ddlanguage valpos domvalue_l ddtext
      FROM dd07t INTO CORRESPONDING FIELDS OF TABLE et_domain_fixed_val
      WHERE domname = iv_domname AND ddlanguage EQ 'E' AND as4local EQ 'A'.
    IF sy-subrc EQ 0 .
      SORT et_domain_fixed_val ASCENDING BY valpos.
      ev_domname = iv_domname.
    ELSE.
*   fill bapiret2
      CALL FUNCTION 'CNV_2010C_FILL_BAPIRET2'
        EXPORTING
          type   = 'E'
          cl     = 'CNV_2010C'
          number = '000'
        IMPORTING
          return = ls_bapi_ret.

      ls_bapi_ret-message = text-013.

      APPEND ls_bapi_ret TO return.
    ENDIF.
  ENDIF.

ENDFUNCTION.
