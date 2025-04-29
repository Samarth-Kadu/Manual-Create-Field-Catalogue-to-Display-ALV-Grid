REPORT ZPRG3_ALV.

TYPES: BEGIN OF lty_vbak,
  VBELN TYPE VBELN_VA,
  ERDAT TYPE ERDAT,
  ERZET TYPE ERZET,
  ERNAM TYPE ERNAM,
  VBTYP TYPE VBTYP,
  end of lty_vbak.

DATA int_table type TABLE OF lty_vbak.
DATA warea TYPE lty_vbak.

TYPES: BEGIN OF lty_vbap,
  VBELN TYPE VBELN_VA,
  POSNR TYPE POSNR_VA,
  MATNR TYPE MATNR,
  end of lty_vbap.

DATA int_table1 type  TABLE OF lty_vbap.
data warea1 type lty_vbap.
DATA LV_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV.
DATA : LS_FIELDCAT TYPE slis_fieldcat_alv.
DATA: LT_FINAL TYPE TABLE OF ZSTR_ALV.
DATA : WA_FINAL TYPE ZSTR_ALV.
DATA : LT_SORT TYPE slis_t_sortinfo_alv.
DATA : WA_SORT TYPE  slis_sortinfo_alv.


data lv_vbeln TYPE VBELN_VA.

SELECT-OPTIONS : s_vbeln for lv_vbeln.

SELECT VBELN ERDAT ERZET ERNAM VBTYP
from vbak
into table int_table
where VBELN in s_vbeln.

if int_table is not initial.
select  VBELN POSNR  MATNR
from VBAP
INTO TABLE int_table1
for all ENTRIES IN int_table
where VBELN = int_table-VBELN.
ENDIF.

LOOP AT INT_TABLE INTO WAREA.
LOOP AT INT_TABLE1 INTO WAREA1 WHERE VBELN = WAREA-VBELN.
WA_FINAL-VBELN = WAREA-VBELN.
WA_FINAL-ERDAT = WAREA-ERDAT.
WA_FINAL-ERZET = WAREA-ERZET.
WA_FINAL-ERNAM = WAREA-ERNAM.
WA_FINAL-VBTYP = WAREA-VBTYP.
WA_FINAL-POSNR = WAREA1-POSNR.
WA_FINAL-MATNR = WAREA1-MATNR.
APPEND WA_FINAL TO LT_FINAL.
CLEAR WA_FINAL.
ENDLOOP.
ENDLOOP.

LS_FIELDCAT-col_pos = '1'.
LS_FIELDCAT-fieldname = 'VBELN'.
LS_FIELDCAT-tabname = 'LT_FINAL'.
LS_FIELDCAT-seltext_L = 'Sales Document Number'.
APPEND LS_FIELDCAT TO  LV_FIELDCAT.
CLEAR LS_FIELDCAT.

LS_FIELDCAT-col_pos = '3'.
LS_FIELDCAT-fieldname = 'ERZET'.
LS_FIELDCAT-tabname = 'LT_FINAL'.
LS_FIELDCAT-seltext_L = ' TIME '.
APPEND LS_FIELDCAT TO  LV_FIELDCAT.
CLEAR LS_FIELDCAT.

LS_FIELDCAT-col_pos = '4'.
LS_FIELDCAT-fieldname = 'ERNAM'.
LS_FIELDCAT-tabname = 'LT_FINAL'.
LS_FIELDCAT-seltext_L = 'NAME'.
APPEND LS_FIELDCAT TO  LV_FIELDCAT.
CLEAR LS_FIELDCAT.

LS_FIELDCAT-col_pos = '5'.
LS_FIELDCAT-fieldname = 'VBTYP'.
LS_FIELDCAT-tabname = 'LT_FINAL'.
LS_FIELDCAT-seltext_L = 'CATEGORY'.
APPEND LS_FIELDCAT TO  LV_FIELDCAT.
CLEAR LS_FIELDCAT.

LS_FIELDCAT-col_pos = '6'.
LS_FIELDCAT-fieldname = 'POSNR'.
LS_FIELDCAT-tabname = 'LT_FINAL'.
LS_FIELDCAT-seltext_L = 'Item Number'.
APPEND LS_FIELDCAT TO  LV_FIELDCAT.
CLEAR LS_FIELDCAT.

LS_FIELDCAT-col_pos = '7'.
LS_FIELDCAT-fieldname = ' MATNR'.
LS_FIELDCAT-tabname = 'LT_FINAL'.
LS_FIELDCAT-seltext_L = 'Material  Number'.
APPEND LS_FIELDCAT TO  LV_FIELDCAT.
CLEAR LS_FIELDCAT.


WA_SORT-fieldname = 'VBELN'.
WA_SORT-DOWN = 'X'.
APPEND WA_SORT TO LT_SORT.



CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
*   I_CALLBACK_PROGRAM                = ' '
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
   I_STRUCTURE_NAME                  = 'zstr_alv'
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
*   IS_LAYOUT                         =
   IT_FIELDCAT                       =  LV_FIELDCAT
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
   IT_SORT                           =  LT_SORT
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
*   I_SAVE                            = ' '
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
    T_OUTTAB                          = LT_FINAL
 EXCEPTIONS
   PROGRAM_ERROR                     = 1
   OTHERS                            = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.