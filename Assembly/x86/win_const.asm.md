```c
 ;	Licencia Apache, Versión 2.0 con Modificación
 ;	
 ;	Copyright 2023 Desmon (David)
 ;	
 ;	Se concede permiso, de forma gratuita, a cualquier persona que obtenga una copia de 
 ;	este software y archivos de documentación asociados (el "Software"), para tratar el 
 ;	Software sin restricciones, incluidos, entre otros, los derechos de uso, copia, 
 ;	modificación, fusión, publicación, distribución, sublicencia y/o venta de copias del 
 ;	Software, y para permitir a las personas a quienes se les proporcione el Software 
 ;	hacer lo mismo, sujeto a las siguientes condiciones:
 ;	
 ;	El anterior aviso de copyright y este aviso de permiso se incluirán en todas las 
 ;	copias o partes sustanciales del Software.
 ;	
 ;	EL SOFTWARE SE PROPORCIONA "TAL CUAL", SIN GARANTÍA DE NINGÚN TIPO, EXPRESA O 
 ;	IMPLÍCITA, INCLUYENDO PERO NO LIMITADO A LAS GARANTÍAS DE COMERCIABILIDAD, IDONEIDAD 
 ;	PARA UN PROPÓSITO PARTICULAR Y NO INFRACCIÓN. EN NINGÚN CASO LOS TITULARES DEL 
 ;	COPYRIGHT O LOS TITULARES DE LOS DERECHOS DE AUTOR SERÁN RESPONSABLES DE NINGÚN 
 ;	RECLAMO, DAÑO U OTRA RESPONSABILIDAD, YA SEA EN UNA ACCIÓN DE CONTRATO, AGRAVIO O DE 
 ;	OTRA MANERA, QUE SURJA DE, FUERA DE O EN CONEXIÓN CON EL SOFTWARE O EL USO U OTRO TIPO
 ;	DE ACCIONES EN EL SOFTWARE.
 ;	
 ;	Además, cualquier modificación realizada por terceros se considerará propiedad del 
 ;	titular original de los derechos de autor. Los titulares de derechos de autor 
 ;	originales no se responsabilizan de las modificaciones realizadas por terceros.
 ;	
 ;	Queda explícitamente establecido que no es obligatorio especificar ni notificar los 
 ;	cambios realizados entre versiones, ni revelar porciones específicas de código 
 ;	modificado.
 ;

%define CC_RGBINIT	0x00000001	 
%define CC_FULLOPEN	0x00000002	 
%define CC_PREVENTFULLOPEN	0x00000004	 
%define CC_SHOWHELP	0x00000008	 
%define CC_ENABLEHOOK	0x00000010	 
%define CC_ENABLETEMPLATE	0x00000020	 
%define CC_ENABLETEMPLATEHANDLE	0x00000040	 
%define CC_SOLIDCOLOR	0x00000080	 
%define CC_ANYCOLOR	0x00000100	 
%define MF_INSERT	0x00000000	 
%define MF_CHANGE	0x00000080	 
%define MF_APPEND	0x00000100	 
%define MF_DELETE	0x00000200	 
%define MF_REMOVE	0x00001000	 
%define MF_BYCOMMAND	0x00000000	 
%define MF_BYPOSITION	0x00000400	 
%define MF_SEPARATOR	0x00000800	 
%define MF_ENABLED	0x00000000	 
%define MF_GRAYED	0x00000001	 
%define MF_DISABLED	0x00000002	 
%define MF_UNCHECKED	0x00000000	 
%define MF_CHECKED	0x00000008	 
%define MF_USECHECKBITMAPS	0x00000200	 
%define MF_STRING	0x00000000	 
%define MF_BITMAP	0x00000004	 
%define MF_OWNERDRAW	0x00000100	 
%define MF_POPUP	0x00000010	 
%define MF_MENUBARBREAK	0x00000020	 
%define MF_MENUBREAK	0x00000040	 
%define MF_UNHILITE	0x00000000	 
%define MF_HILITE	0x00000080	 
%define MF_DEFAULT	0x00001000	 
%define MF_SYSMENU	0x00002000	 
%define MF_HELP	0x00004000	 
%define MF_RIGHTJUSTIFY	0x00004000	 
%define MF_MOUSESELECT	0x00008000	 
%define MFT_RADIOCHECK	0x00000200	  
%define MFT_RIGHTORDER	0x00002000	 
%define MFS_GRAYED	0x00000003	  
%define MFS_MASK	0x0000108B	 
%define MFS_HOTTRACKDRAWN	0x10000000	 
%define MFS_CACHEDBMP	0x20000000	 
%define MFS_BOTTOMGAPDROP	0x40000000	 
%define MFS_TOPGAPDROP	0x80000000	 
%define MFS_GAPDROP	0xC0000000	 
%define TPM_LEFTBUTTON	0x0000	 
%define TPM_RIGHTBUTTON	0x0002	 
%define TPM_LEFTALIGN	0x0000	 
%define TPM_CENTERALIGN	0x0004	 
%define TPM_RIGHTALIGN	0x0008	 
%define TPM_TOPALIGN	0x0000	 
%define TPM_VCENTERALIGN	0x0010	 
%define TPM_BOTTOMALIGN	0x0020	 
%define TPM_HORIZONTAL	0x0000	 
%define TPM_VERTICAL	0x0040	 
%define TPM_NONOTIFY	0x0080	 
%define TPM_RETURNCMD	0x0100	 
%define TPM_RECURSE	0x0001	 
%define SC_SIZE	0xF000	 
%define SC_MOVE	0xF010	 
%define SC_MINIMIZE	0xF020	 
%define SC_MAXIMIZE	0xF030	 
%define SC_NEXTWINDOW	0xF040	 
%define SC_PREVWINDOW	0xF050	 
%define SC_CLOSE	0xF060	 
%define SC_VSCROLL	0xF070	 
%define SC_HSCROLL	0xF080	 
%define SC_MOUSEMENU	0xF090	 
%define SC_KEYMENU	0xF100	 
%define SC_ARRANGE	0xF110	 
%define SC_RESTORE	0xF120	 
%define SC_TASKLIST	0xF130	 
%define SC_SCREENSAVE	0xF140	 
%define SC_HOTKEY	0xF150	 
%define SC_DEFAULT	0xF160	 
%define SC_MONITORPOWER	0xF170	 
%define SC_CONTEXTHELP	0xF180	 
%define SC_SEPARATOR	0xF00F	 
%define DI_MASK	0x0001	 
%define DI_IMAGE	0x0002	 
%define DI_NORMAL	0x0003	 
%define DI_COMPAT	0x0004	 
%define DI_DEFAULTSIZE	0x0008	 
%define EN_SETFOCUS	0x0100	 
%define EN_KILLFOCUS	0x0200	 
%define EN_CHANGE	0x0300	 
%define EN_UPDATE	0x0400	 
%define EN_ERRSPACE	0x0500	 
%define EN_MAXTEXT	0x0501	 
%define EN_HSCROLL	0x0601	 
%define EN_VSCROLL	0x0602	 
%define IDC_ARROW	32512	 
%define IDC_IBEAM	32513	 
%define IDC_WAIT	32514	 
%define IDC_CROSS	32515	 
%define IDC_UPARROW	32516	 
%define IDC_SIZE	32640	 
%define IDC_ICON	32641	 
%define IDC_SIZENWSE	32642	 
%define IDC_SIZENESW	32643	 
%define IDC_SIZEWE	32644	 
%define IDC_SIZENS	32645	 
%define IDC_SIZEALL	32646	 
%define IDC_NO	32648	 
%define IDC_HAND	32649	 
%define IDC_APPSTARTING	32650	 
%define IDC_HELP	32651	 
%define CF_TEXT	1	 
%define CF_BITMAP	2	 
%define CF_METAFILEPICT	3	 
%define CF_SYLK	4	 
%define CF_DIF	5	 
%define CF_TIFF	6	 
%define CF_OEMTEXT	7	 
%define CF_DIB	8	 
%define CF_PALETTE	9	 
%define CF_PENDATA	10	 
%define CF_RIFF	11	 
%define CF_WAVE	12	 
%define CF_UNICODETEXT	13	 
%define CF_ENHMETAFILE	14	 
%define CF_HDROP	15	 
%define CF_LOCALE	16	 
%define CF_MAX	17	 
%define CF_OWNERDISPLAY	0x0080	 
%define CF_DSPTEXT	0x0081	 
%define CF_DSPBITMAP	0x0082	 
%define CF_DSPMETAFILEPICT	0x0083	 
%define CF_DSPENHMETAFILE	0x008E	 
%define CF_PRIVATEFIRST	0x0200	 
%define CF_PRIVATELAST	0x02FF	 
%define CF_GDIOBJFIRST	0x0300	 
%define CF_GDIOBJLAST	0x03FF	 
%define GMEM_FIXED	0x0000	 
%define GMEM_MOVEABLE	0x0002	 
%define GMEM_NOCOMPACT	0x0010	 
%define GMEM_NODISCARD	0x0020	 
%define GMEM_ZEROINIT	0x0040	 
%define GMEM_MODIFY	0x0080	 
%define GMEM_DISCARDABLE	0x0100	 
%define GMEM_NOT_BANKED	0x1000	 
%define GMEM_SHARE	0x2000	 
%define GMEM_DDESHARE	0x2000	 
%define GMEM_NOTIFY	0x4000	 

%define GMEM_VALID_FLAGS	0x7F72	 
%define GMEM_INVALID_HANDLE	0x8000	 

%define BM_GETCHECK	0x00F0	 
%define BM_SETCHECK	0x00F1	 
%define BM_GETSTATE	0x00F2	 
%define BM_SETSTATE	0x00F3	 
%define BM_SETSTYLE	0x00F4	 
%define BM_CLICK	0x00F5	 
%define BM_GETIMAGE	0x00F6	 
%define BM_SETIMAGE	0x00F7	 
%define BST_UNCHECKED	0x0000	 
%define BST_CHECKED	0x0001	 
%define BST_INDETERMINATE	0x0002	 
%define BST_PUSHED	0x0004	 
%define BST_FOCUS	0x0008	 
%define EM_GETSEL	0x00B0	 
%define EM_SETSEL	0x00B1	 
%define EM_GETRECT	0x00B2	 
%define EM_SETRECT	0x00B3	 
%define EM_SETRECTNP	0x00B4	 
%define EM_SCROLL	0x00B5	 
%define EM_LINESCROLL	0x00B6	 
%define EM_SCROLLCARET	0x00B7	 
%define EM_GETMODIFY	0x00B8	 
%define EM_SETMODIFY	0x00B9	 
%define EM_GETLINECOUNT	0x00BA	 
%define EM_LINEINDEX	0x00BB	 
%define EM_SETHANDLE	0x00BC	 
%define EM_GETHANDLE	0x00BD	 
%define EM_GETTHUMB	0x00BE	 
%define EM_LINELENGTH	0x00C1	 
%define EM_REPLACESEL	0x00C2	 
%define EM_GETLINE	0x00C4	 
%define EM_LIMITTEXT	0x00C5	 
%define EM_CANUNDO	0x00C6	 
%define EM_UNDO	0x00C7	 
%define EM_FMTLINES	0x00C8	 
%define EM_LINEFROMCHAR	0x00C9	 
%define EM_SETTABSTOPS	0x00CB	 
%define EM_SETPASSWORDCHAR	0x00CC	 
%define EM_EMPTYUNDOBUFFER	0x00CD	 
%define EM_GETFIRSTVISIBLELINE	0x00CE	 
%define EM_SETREADONLY	0x00CF	 
%define EM_SETWORDBREAKPROC	0x00D0	 
%define EM_GETWORDBREAKPROC	0x00D1	 
%define EM_GETPASSWORDCHAR	0x00D2	 
%define EM_SETMARGINS	0x00D3	 
%define EM_GETMARGINS	0x00D4	 
%define EM_GETLIMITTEXT	0x00D5	 
%define EM_POSFROMCHAR	0x00D6	 
%define EM_CHARFROMPOS	0x00D7	 
%define EM_SETIMESTATUS	0x00D8	 
%define EM_GETIMESTATUS	0x00D9	 
%define LOGPIXELSX	88	 
%define LOGPIXELSY	90
%define LF_FACESIZE	32	 
%define OUT_DEFAULT_PRECIS	0	 
%define OUT_STRING_PRECIS	1	 
%define OUT_CHARACTER_PRECIS	2	 
%define OUT_STROKE_PRECIS	3	 
%define OUT_TT_PRECIS	4	 
%define OUT_DEVICE_PRECIS	5	 
%define OUT_RASTER_PRECIS	6	 
%define OUT_TT_ONLY_PRECIS	7	 
%define OUT_OUTLINE_PRECIS	8	 
%define OUT_SCREEN_OUTLINE_PRECIS	9	 
%define CLIP_DEFAULT_PRECIS	0	 
%define CLIP_CHARACTER_PRECIS	1	 
%define CLIP_STROKE_PRECIS	2	 
%define CLIP_MASK	0xf	 
%define CLIP_LH_ANGLES	(1<<4)	 
%define CLIP_TT_ALWAYS	(2<<4)	 
%define CLIP_EMBEDDED	(8<<4)	 
%define DEFAULT_QUALITY	0	 
%define DRAFT_QUALITY	1	 
%define PROOF_QUALITY	2	 
%define NONANTIALIASED_QUALITY	3	 
%define ANTIALIASED_QUALITY	4	 
%define DEFAULT_PITCH	0	 
%define FIXED_PITCH	1	 
%define VARIABLE_PITCH	2	 
%define MONO_FONT	8	 
%define ANSI_CHARSET	0	 
%define DEFAULT_CHARSET	1	 
%define SYMBOL_CHARSET	2	 
%define SHIFTJIS_CHARSET	128	 
%define HANGEUL_CHARSET	129	 
%define HANGUL_CHARSET	129	 
%define GB2312_CHARSET	134	 
%define CHINESEBIG5_CHARSET	136	 
%define OEM_CHARSET	255	 
%define JOHAB_CHARSET	130	 
%define HEBREW_CHARSET	177	 
%define ARABIC_CHARSET	178	 
%define GREEK_CHARSET	161	 
%define TURKISH_CHARSET	162	 
%define VIETNAMESE_CHARSET	163	 
%define THAI_CHARSET	222	 
%define EASTEUROPE_CHARSET	238	 
%define RUSSIAN_CHARSET	204	 
%define MAC_CHARSET	77	 
%define BALTIC_CHARSET	186	 
%define FS_LATIN1	0x00000001	 
%define FS_LATIN2	0x00000002	 
%define FS_CYRILLIC	0x00000004	 
%define FS_GREEK	0x00000008	 
%define FS_TURKISH	0x00000010	 
%define FS_HEBREW	0x00000020	 
%define FS_ARABIC	0x00000040	 
%define FS_BALTIC	0x00000080	 
%define FS_VIETNAMESE	0x00000100	 
%define FS_THAI		0x00010000	 
%define FS_JISJAPAN	0x00020000	 
%define FS_CHINESESIMP	0x00040000	 
%define FS_WANSUNG		0x00080000	 
%define FS_CHINESETRAD	0x00100000	 
%define FS_JOHAB	0x00200000	 
%define FS_SYMBOL	0x80000000	 
%define FF_DONTCARE	(0<<4)  ; Don't care or don't know.
%define FF_ROMAN	(1<<4)  ; Variable stroke width, serifed.
						; Times Roman, Century Schoolbook, etc.
%define FF_SWISS	(2<<4)  ; Variable stroke width, sans-serifed.
                                    		; Helvetica, Swiss, etc.
%define FF_MODERN	(3<<4)  ; Constant stroke width, serifed or sans-serifed.
                                    		; Pica, Elite, Courier, etc.
%define FF_SCRIPT	(4<<4)  ; Cursive, etc.
%define FF_DECORATIVE	(5<<4)  ; Old English, etc.
%define FW_DONTCARE	0	 
%define FW_THIN	100	 
%define FW_EXTRALIGHT	200	 
%define FW_LIGHT	300	 
%define FW_NORMAL	400	 
%define FW_MEDIUM	500	 
%define FW_SEMIBOLD	600	 
%define FW_BOLD	700	 
%define FW_EXTRABOLD	800	 
%define FW_HEAVY	900	  
%define RASTER_FONTTYPE	0x0001	 
%define DEVICE_FONTTYPE	0x002	 
%define TRUETYPE_FONTTYPE	0x004	 
%define WHITE_BRUSH	0	 
%define LTGRAY_BRUSH	1	 
%define GRAY_BRUSH	2	 
%define DKGRAY_BRUSH	3	 
%define BLACK_BRUSH	4	 
%define NULL_BRUSH	5	 
%define WHITE_PEN	6	 
%define BLACK_PEN	7	 
%define NULL_PEN	8	 
%define OEM_FIXED_FONT	10	 
%define ANSI_FIXED_FONT	11	 
%define ANSI_VAR_FONT	12	 
%define SYSTEM_FONT	13	 
%define DEVICE_DEFAULT_FONT	14	 
%define DEFAULT_PALETTE	15	 
%define SYSTEM_FIXED_FONT	16	 
%define DEFAULT_GUI_FONT	17	 
%define DC_BRUSH	18	 
%define DC_PEN	19	 
%define STOCK_LAST	19	 
%define CLR_INVALID	0FFFFFFFFh	 
%define BS_SOLID	0	 
%define BS_NULL	1	 
%define BS_HATCHED	2	 
%define BS_PATTERN	3	 
%define BS_INDEXED	4	 
%define BS_DIBPATTERN	5	 
%define BS_DIBPATTERNPT	6	 
%define BS_PATTERN8X8	7	 
%define BS_DIBPATTERN8X8	8	 
%define BS_MONOPATTERN	9	 
%define HS_HORIZONTAL	0	 
%define HS_VERTICAL	1	 
%define HS_FDIAGONAL	2	 
%define HS_BDIAGONAL	3	 
%define HS_CROSS	4	 
%define HS_DIAGCROSS	5	 
%define PS_SOLID	0	 
%define PS_DASH	1	 
%define PS_DOT	2	 
%define PS_DASHDOT	3	 
%define PS_DASHDOTDOT	4	 
%define PS_NULL	5	 
%define PS_INSIDEFRAME	6	 
%define PS_USERSTYLE	7	 
%define PS_ALTERNATE	8	 
%define PS_STYLE_MASK	00000000Fh	 
%define PS_ENDCAP_ROUND	000000000h	 
%define PS_ENDCAP_SQUARE	000000100h	 
%define PS_ENDCAP_FLAT	000000200h	 
%define PS_ENDCAP_MASK	000000F00h	 
%define PS_JOIN_ROUND	000000000h	 
%define PS_JOIN_BEVEL	000001000h	 
%define PS_JOIN_MITER	000002000h	 
%define PS_JOIN_MASK	00000F000h	 
%define PS_COSMETIC	000000000h	 
%define PS_GEOMETRIC	000010000h	 
%define PS_TYPE_MASK	0000F0000h	 
%define AD_COUNTERCLOCKWISE	1	 
%define AD_CLOCKWISE	2	 
%define EXCEPTION_EXECUTE_HANDLER	1	 
%define EXCEPTION_CONTINUE_SEARCH	0	 
%define EXCEPTION_CONTINUE_EXECUTION	-1
%define MB_OK	000000000h	 
%define MB_OKCANCEL	000000001h	 
%define MB_ABORTRETRYIGNORE	000000002h	 
%define MB_YESNOCANCEL	000000003h	 
%define MB_YESNO	000000004h	 
%define MB_RETRYCANCEL	000000005h	 
%define MB_ICONHAND	000000010h	 
%define MB_ICONQUESTION	000000020h	 
%define MB_ICONEXCLAMATION	000000030h	 
%define MB_ICONASTERISK	000000040h	 
%define MB_USERICON	000000080h	 
%define MB_DEFBUTTON1	000000000h	 
%define MB_DEFBUTTON2	000000100h	 
%define MB_DEFBUTTON3	000000200h	 
%define MB_DEFBUTTON4	000000300h	 
%define MB_APPLMODAL	000000000h	 
%define MB_SYSTEMMODAL	000001000h	 
%define MB_TASKMODAL	000002000h	 
%define MB_HELP	000004000h	 
%define MB_NOFOCUS	000008000h	 
%define MB_SETFOREGROUND	000010000h	 
%define MB_DEFAULT_DESKTOP_ONLY	000020000h	 
%define MB_TOPMOST	000040000h	 
%define MB_RIGHT	000080000h	 
%define MB_RTLREADING	000100000h	 
%define MB_TYPEMASK	00000000Fh	 
%define MB_ICONMASK	0000000F0h	 
%define MB_DEFMASK	000000F00h	 
%define MB_MODEMASK	000003000h	 
%define MB_MISCMASK	00000C000h	 
%define FILE_BEGIN	0	 
%define FILE_CURRENT	1	 
%define FILE_END	2	 
%define PAGE_NOACCESS	001h	 
%define PAGE_READONLY	002h	 
%define PAGE_READWRITE	004h	 
%define PAGE_WRITECOPY	008h	 
%define PAGE_EXECUTE	010h	 
%define PAGE_EXECUTE_READ	020h	 
%define PAGE_EXECUTE_READWRITE	040h	 
%define PAGE_EXECUTE_WRITECOPY	080h	 
%define PAGE_GUARD	0100h	 
%define PAGE_NOCACHE	0200h	 
%define PAGE_WRITECOMBINE	0400h	 
%define MEM_COMMIT	01000h	 
%define MEM_RESERVE	02000h	 
%define MEM_DECOMMIT	04000h	 
%define MEM_RELEASE	08000h	 
%define MEM_FREE	010000h	 
%define MEM_PRIVATE	020000h	 
%define MEM_MAPPED	040000h	 
%define MEM_RESET	080000h	 
%define MEM_TOP_DOWN	0100000h	 
%define MEM_4MB_PAGES	080000000h	 
%define FORMAT_MESSAGE_ALLOCATE_BUFFER	000000100h	 
%define FORMAT_MESSAGE_IGNORE_INSERTS	000000200h	 
%define FORMAT_MESSAGE_FROM_STRING	000000400h	 
%define FORMAT_MESSAGE_FROM_HMODULE	000000800h	 
%define FORMAT_MESSAGE_FROM_SYSTEM	000001000h	 
%define FORMAT_MESSAGE_ARGUMENT_ARRAY	000002000h	 
%define FORMAT_MESSAGE_MAX_WIDTH_MASK	0000000FFh	 

%define GENERIC_READ		080000000h
%define GENERIC_WRITE		040000000h
%define GENERIC_EXECUTE		020000000h
%define GENERIC_ALL	  	    010000000h

%define CREATE_NEW	1	 
%define CREATE_ALWAYS	2	 
%define OPEN_EXISTING	3	 
%define OPEN_ALWAYS	4	 
%define TRUNCATE_EXISTING	5	 
%define INVALID_HANDLE_VALUE	-1	 
%define INVALID_FILE_SIZE	0FFFFFFFFh	 
%define STD_INPUT_HANDLE	-10	 
%define STD_OUTPUT_HANDLE	-11	 
%define STD_ERROR_HANDLE	-12	 
%define FOREGROUND_BLUE	0001h	 
%define FOREGROUND_GREEN	0002h	 
%define FOREGROUND_RED	0004h	 
%define FOREGROUND_INTENSITY	0008h	 
%define BACKGROUND_BLUE	0010h	 
%define BACKGROUND_GREEN	0020h	 
%define BACKGROUND_RED	0040h	 
%define BACKGROUND_INTENSITY	0080h	 
%define ENABLE_PROCESSED_INPUT	00001h	 
%define ENABLE_LINE_INPUT	00002h	 
%define ENABLE_ECHO_INPUT	00004h	 
%define ENABLE_WINDOW_INPUT	00008h	 
%define ENABLE_MOUSE_INPUT	00010h	 
%define ENABLE_PROCESSED_OUTPUT	00001h	 
%define ENABLE_WRAP_AT_EOL_OUTPUT	00002h	 
%define GCL_MENUNAME	(-8)	 
%define GCL_HBRBACKGROUND	(-10)	 
%define GCL_HCURSOR	(-12)	 
%define GCL_HICON	(-14)	 
%define GCL_HMODULE	(-16)	 
%define GCL_CBWNDEXTRA	(-18)	 
%define GCL_CBCLSEXTRA	(-20)	 
%define GCL_WNDPROC	(-24)	 
%define GCL_STYLE	(-26)	 
%define GCW_ATOM	(-32)	 
%define STM_SETICON	00170h	 
%define STM_GETICON	00171h	 
%define STM_SETIMAGE	00172h	 
%define STM_GETIMAGE	00173h	 
%define STN_CLICKED	0	 
%define STN_DBLCLK	1	 
%define STN_ENABLE	2	 
%define STN_DISABLE	3	 
%define IMAGE_BITMAP	0	 
%define IMAGE_ICON	1	 
%define IMAGE_CURSOR	2	 
%define IMAGE_ENHMETAFILE	3	 
%define LR_DEFAULTCOLOR	00000h	 
%define LR_MONOCHROME	00001h	 
%define LR_COLOR	00002h	 
%define LR_COPYRETURNORG	00004h	 
%define LR_COPYDELETEORG	00008h	 
%define LR_LOADFROMFILE	00010h	 
%define LR_LOADTRANSPARENT	00020h	 
%define LR_DEFAULTSIZE	00040h	 
%define LR_VGACOLOR	00080h	 
%define LR_LOADMAP3DCOLORS	01000h	 
%define LR_CREATEDIBSECTION	02000h	 
%define LR_COPYFROMRESOURCE	04000h	 
%define LR_SHARED	08000h	 
%define SW_HIDE	0	 
%define SW_SHOWNORMAL	1	 
%define SW_NORMAL	1	 
%define SW_SHOWMINIMIZED	2	 
%define SW_SHOWMAXIMIZED	3	 
%define SW_MAXIMIZE	3	 
%define SW_SHOWNOACTIVATE	4	 
%define SW_SHOW	5	 
%define SW_MINIMIZE	6	 
%define SW_SHOWMINNOACTIVE	7	 
%define SW_SHOWNA	8	 
%define SW_RESTORE	9	 
%define SW_SHOWDEFAULT	10	 
%define SW_FORCEMINIMIZE	11	 
%define SW_MAX	11	 

%define SM_CXSCREEN              	0
%define SM_CYSCREEN              	1
%define SM_CXVSCROLL             	2
%define SM_CYHSCROLL             	3
%define SM_CYCAPTION             	4
%define SM_CXBORDER              	5
%define SM_CYBORDER              	6
%define SM_CXDLGFRAME            	7
%define SM_CYDLGFRAME            	8
%define SM_CYVTHUMB              	9
%define SM_CXHTHUMB              	10
%define SM_CXICON                	11
%define SM_CYICON                	12
%define SM_CXCURSOR              	13
%define SM_CYCURSOR              	14
%define SM_CYMENU                	15
%define SM_CXFULLSCREEN          	16
%define SM_CYFULLSCREEN          	17
%define SM_CYKANJIWINDOW         	18
%define SM_MOUSEPRESENT          	19
%define SM_CYVSCROLL             	20
%define SM_CXHSCROLL             	21
%define SM_DEBUG                 	22
%define SM_SWAPBUTTON            	23
%define SM_RESERVED1             	24
%define SM_RESERVED2             	25
%define SM_RESERVED3             	26
%define SM_RESERVED4             	27
%define SM_CXMIN                 	28
%define SM_CYMIN                 	29
%define SM_CXSIZE                	30
%define SM_CYSIZE                	31
%define SM_CXFRAME               	32
%define SM_CYFRAME               	33
%define SM_CXMINTRACK            	34
%define SM_CYMINTRACK            	35
%define SM_CXDOUBLECLK           	36
%define SM_CYDOUBLECLK           	37
%define SM_CXICONSPACING         	38
%define SM_CYICONSPACING         	39
%define SM_MENUDROPALIGNMENT     	40
%define SM_PENWINDOWS            	41
%define SM_DBCSENABLED           	42
%define SM_CMOUSEBUTTONS         	43
%define SM_SECURE                	44
%define SM_CXEDGE                	45
%define SM_CYEDGE                	46
%define SM_CXMINSPACING          	47
%define SM_CYMINSPACING          	48
%define SM_CXSMICON              	49
%define SM_CYSMICON              	50
%define SM_CYSMCAPTION           	51
%define SM_CXSMSIZE              	52
%define SM_CYSMSIZE              	53
%define SM_CXMENUSIZE            	54
%define SM_CYMENUSIZE            	55
%define SM_ARRANGE               	56
%define SM_CXMINIMIZED           	57
%define SM_CYMINIMIZED           	58
%define SM_CXMAXTRACK            	59
%define SM_CYMAXTRACK            	60
%define SM_CXMAXIMIZED           	61
%define SM_CYMAXIMIZED           	62
%define SM_NETWORK               	63
%define SM_CLEANBOOT             	67
%define SM_CXDRAG                	68
%define SM_CYDRAG                	69
%define SM_SHOWSOUNDS            	70
%define SM_CXMENUCHECK           	71  ; Use instead of GetMenuCheckMarkDimensions()!
%define SM_CYMENUCHECK           	72
%define SM_SLOWMACHINE           	73
%define SM_MIDEASTENABLED        	74
%define SM_MOUSEWHEELPRESENT     	75
%define SM_XVIRTUALSCREEN        	76
%define SM_YVIRTUALSCREEN        	77
%define SM_CXVIRTUALSCREEN       	78
%define SM_CYVIRTUALSCREEN       	79
%define SM_CMONITORS             	80
%define SM_SAMEDISPLAYFORMAT     	81
%define GWL_WNDPROC	-4	 
%define GWL_HINSTANCE	-6	 
%define GWL_HWNDPARENT	-8	 
%define GWL_STYLE	-16	 
%define GWL_EXSTYLE	-20	 
%define GWL_USERDATA	-21	 
%define GWL_ID	-12	 
%define CW_USEDEFAULT	80000000h	 
%define SWP_NOSIZE	00001h	 
%define SWP_NOMOVE	00002h	 
%define SWP_NOZORDER	00004h	 
%define SWP_NOREDRAW	00008h	 
%define SWP_NOACTIVATE	00010h	 
%define SWP_FRAMECHANGED	00020h	 
%define SWP_SHOWWINDOW	00040h	 
%define SWP_HIDEWINDOW	00080h	 
%define SWP_NOCOPYBITS	00100h	 
%define SWP_NOOWNERZORDER	00200h	 
%define SWP_NOSENDCHANGING	00400h	 

%define SWP_DEFERERASE	02000h	 
%define SWP_ASYNCWINDOWPOS	04000h	 

%define HWND_TOP	0	 
%define HWND_BOTTOM	1	 
%define HWND_TOPMOST	-1	 
%define HWND_NOTOPMOST	-2	 

%define PM_NOREMOVE	00000h	 
%define PM_REMOVE	00001h	 
%define PM_NOYIELD	00002h	 

%define WA_INACTIVE	0	 
%define WA_ACTIVE	1	 
%define WA_CLICKACTIVE	2	 

%define WM_SETFOCUS              	00007h
%define WM_KILLFOCUS             	00008h
%define WM_ENABLE                	0000Ah
%define WM_SETREDRAW             	0000Bh
%define WM_SETTEXT               	0000Ch
%define WM_GETTEXT               	0000Dh
%define WM_GETTEXTLENGTH         	0000Eh
%define WM_PAINT                 	0000Fh
%define WM_CLOSE                 	00010h
%define WM_QUERYENDSESSION       	00011h
%define WM_QUIT                  	00012h
%define WM_QUERYOPEN             	00013h
%define WM_ERASEBKGND            	00014h
%define WM_SYSCOLORCHANGE        	00015h
%define WM_ENDSESSION            	00016h
%define WM_SHOWWINDOW            	00018h
%define WM_WININICHANGE          	0001Ah

%define WM_DEVMODECHANGE         	0001Bh
%define WM_ACTIVATEAPP           	0001Ch
%define WM_FONTCHANGE            	0001Dh
%define WM_TIMECHANGE            	0001Eh
%define WM_CANCELMODE            	0001Fh
%define WM_SETCURSOR             	00020h
%define WM_MOUSEACTIVATE         	00021h
%define WM_CHILDACTIVATE         	00022h
%define WM_QUEUESYNC             	00023h

%define WM_GETMINMAXINFO         	00024h

%define SRCCOPY	000CC0020h	 
%define SRCPAINT	000EE0086h	 
%define SRCAND	0008800C6h	 
%define SRCINVERT	000660046h	 
%define SRCERASE	000440328h	 
%define NOTSRCCOPY	000330008h	 
%define NOTSRCERASE	0001100A6h	 
%define MERGECOPY	000C000CAh	 
%define MERGEPAINT	000BB0226h	 
%define PATCOPY	000F00021h	 
%define PATPAINT	000FB0A09h	 
%define PATINVERT	0005A0049h	 
%define DSTINVERT	000550009h	 
%define BLACKNESS	000000042h	 
%define WHITENESS	000FF0062h	 

%define RDW_INVALIDATE	00001h	 
%define RDW_INTERNALPAINT	00002h	 
%define RDW_ERASE	00004h	 
%define RDW_VALIDATE	00008h	 
%define RDW_NOINTERNALPAINT	00010h	 
%define RDW_NOERASE	00020h	 
%define RDW_NOCHILDREN	00040h	 
%define RDW_ALLCHILDREN	00080h	 
%define RDW_UPDATENOW	00100h	 
%define RDW_ERASENOW	00200h	 
%define RDW_FRAME	00400h	 
%define RDW_NOFRAME	00800h	 


%define WM_PAINTICON                     	00026h
%define WM_ICONERASEBKGND                	00027h
%define WM_NEXTDLGCTL                    	00028h
%define WM_SPOOLERSTATUS                 	0002Ah
%define WM_DRAWITEM                      	0002Bh
%define WM_MEASUREITEM                   	0002Ch
%define WM_DELETEITEM                    	0002Dh
%define WM_VKEYTOITEM                    	0002Eh
%define WM_CHARTOITEM                    	0002Fh
%define WM_SETFONT                       	00030h
%define WM_GETFONT                       	00031h
%define WM_SETHOTKEY                     	00032h
%define WM_GETHOTKEY                     	00033h
%define WM_QUERYDRAGICON                 	00037h
%define WM_COMPAREITEM                   	00039h
%define WM_GETOBJECT                     	0003Dh
%define WM_COMPACTING                    	00041h
%define WM_COMMNOTIFY                    	00044h ; no longer suported
%define WM_WINDOWPOSCHANGING             	00046h
%define WM_WINDOWPOSCHANGED              	00047h

%define WM_POWER                         	00048h

; wParam for WM_POWER window message and DRV_POWER driver notification
%define PWR_OK              	 	1
%define PWR_FAIL            	 	-1
%define PWR_SUSPENDR EST  	 	1
%define PWR_SUSPENDRESUME   	 	2
%define PWR_CRITICALRESUME  	 	3

%define WM_COPYDATA                      	0004Ah
%define WM_CANCELJOURNAL                 	0004Bh

%define WM_NOTIFY                        	0004Eh
%define WM_INPUTLANGCHANGER EST        	00050h
%define WM_INPUTLANGCHANGE               	00051h
%define WM_TCARD                         	00052h
%define WM_HELP                          	00053h
%define WM_USERCHANGED                   	00054h
%define WM_NOTIFYFORMAT                  	00055h

%define NFR_ANSI                         	1
%define NFR_UNICODE                      	2
%define NF_QUERY                         	3
%define NF_R ERY                       	4

%define WM_CONTEXTMENU                   	0007Bh
%define WM_STYLECHANGING                 	0007Ch
%define WM_STYLECHANGED                  	0007Dh
%define WM_DISPLAYCHANGE                 	0007Eh
%define WM_GETICON                       	0007Fh
%define WM_SETICON                       	00080h

%define WM_NCCREATE                      	00081h
%define WM_NCDESTROY                     	00082h
%define WM_NCCALCSIZE                    	00083h
%define WM_NCHITTEST                     	00084h
%define WM_NCPAINT                       	00085h
%define WM_NCACTIVATE                    	00086h
%define WM_GETDLGCODE                    	00087h
%define WM_SYNCPAINT                     	00088h
%define WM_NCMOUSEMOVE                   	000A0h
%define WM_NCLBUTTONDOWN                 	000A1h
%define WM_NCLBUTTONUP                   	000A2h
%define WM_NCLBUTTONDBLCLK               	000A3h
%define WM_NCRBUTTONDOWN                 	000A4h
%define WM_NCRBUTTONUP                   	000A5h
%define WM_NCRBUTTONDBLCLK               	000A6h
%define WM_NCMBUTTONDOWN                 	000A7h
%define WM_NCMBUTTONUP                   	000A8h
%define WM_NCMBUTTONDBLCLK               	000A9h

%define WM_KEYFIRST                      	00100h
%define WM_KEYDOWN                       	00100h
%define WM_KEYUP                         	00101h
%define WM_CHAR                          	00102h
%define WM_DEADCHAR                      	00103h
%define WM_SYSKEYDOWN                    	00104h
%define WM_SYSKEYUP                      	00105h
%define WM_SYSCHAR                       	00106h
%define WM_SYSDEADCHAR                   	00107h
%define WM_KEYLAST                       	00108h

%define WM_IME_STARTCOMPOSITION          	0010Dh
%define WM_IME_ENDCOMPOSITION            	0010Eh
%define WM_IME_COMPOSITION               	0010Fh
%define WM_IME_KEYLAST                   	0010Fh

%define WM_INITDIALOG                    	00110h
%define WM_COMMAND                       	00111h
%define WM_SYSCOMMAND                    	00112h
%define WM_TIMER                         	00113h
%define WM_HSCROLL                       	00114h
%define WM_VSCROLL                       	00115h
%define WM_INITMENU                      	00116h
%define WM_INITMENUPOPUP                 	00117h
%define WM_MENUSELECT                    	0011Fh
%define WM_MENUCHAR                      	00120h
%define WM_ENTERIDLE                     	00121h
%define WM_MENURBUTTONUP                 	00122h
%define WM_MENUDRAG                      	00123h
%define WM_MENUGETOBJECT                 	00124h
%define WM_UNINITMENUPOPUP               	00125h
%define WM_MENUCOMMAND                   	00126h

%define WM_CTLCOLORMSGBOX                	00132h
%define WM_CTLCOLOREDIT                  	00133h
%define WM_CTLCOLORLISTBOX               	00134h
%define WM_CTLCOLORBTN                   	00135h
%define WM_CTLCOLORDLG                   	00136h
%define WM_CTLCOLORSCROLLBAR             	00137h
%define WM_CTLCOLORSTATIC                	00138h

%define WM_MOUSEFIRST                    	00200h
%define WM_MOUSEMOVE                     	00200h
%define WM_LBUTTONDOWN                   	00201h
%define WM_LBUTTONUP                     	00202h
%define WM_LBUTTONDBLCLK                 	00203h
%define WM_RBUTTONDOWN                   	00204h
%define WM_RBUTTONUP                     	00205h
%define WM_RBUTTONDBLCLK                 	00206h
%define WM_MBUTTONDOWN                   	00207h
%define WM_MBUTTONUP                     	00208h
%define WM_MBUTTONDBLCLK                 	00209h

%define WM_MOUSEWHEEL                    	0020Ah
%define WM_MOUSELAST                     	0020Ah

%define WHEEL_DELTA                      	120		; Value for rolling one detent
%define WHEEL_PAGESCROLL                 	0ffffffffh 	; Scroll one page

%define WM_PARENTNOTIFY                  	00210h
%define WM_ENTERMENULOOP                 	00211h
%define WM_EXITMENULOOP                  	00212h

%define WM_NEXTMENU                      	00213h


%define WM_SIZING                        	00214h
%define WM_CAPTURECHANGED                	00215h
%define WM_MOVING                        	00216h

%define WM_POWERBROADCAST                	00218h

%define PBT_APMQUERYSUSPEND              	00000h
%define PBT_APMQUERYSTANDBY              	00001h

%define PBT_APMQUERYSUSPENDFAILED        	00002h
%define PBT_APMQUERYSTANDBYFAILED        	00003h

%define PBT_APMSUSPEND                   	00004h
%define PBT_APMSTANDBY                   	00005h

%define PBT_APMRESUMECRITICAL            	00006h
%define PBT_APMRESUMESUSPEND             	00007h
%define PBT_APMRESUMESTANDBY             	00008h

%define PBTF_APMRESUMEFROMFAILURE        	000000001h

%define PBT_APMBATTERYLOW                	00009h
%define PBT_APMPOWERSTATUSCHANGE         	0000Ah

%define PBT_APMOEMEVENT                  	0000Bh
%define PBT_APMRESUMEAUTOMATIC           	00012h

%define WM_DEVICECHANGE                  	00219h

%define WM_MDICREATE                     	00220h
%define WM_MDIDESTROY                    	00221h
%define WM_MDIACTIVATE                   	00222h
%define WM_MDIRESTORE                    	00223h
%define WM_MDINEXT                       	00224h
%define WM_MDIMAXIMIZE                   	00225h
%define WM_MDITILE                       	00226h
%define WM_MDICASCADE                    	00227h
%define WM_MDIICONARRANGE                	00228h
%define WM_MDIGETACTIVE                  	00229h

%define WM_MDISETMENU                    	00230h
%define WM_ENTERSIZEMOVE                 	00231h
%define WM_EXITSIZEMOVE                  	00232h
%define WM_DROPFILES                     	00233h
%define WM_MDIREFRESHMENU                	00234h

%define WM_IME_SETCONTEXT                	00281h
%define WM_IME_NOTIFY                    	00282h
%define WM_IME_CONTROL                   	00283h
%define WM_IME_COMPOSITIONFULL           	00284h
%define WM_IME_SELECT                    	00285h
%define WM_IME_CHAR                      	00286h
%define WM_IME_R EST                   	00288h
%define WM_IME_KEYDOWN                   	00290h
%define WM_IME_KEYUP                     	00291h

%define WM_MOUSEHOVER                    	002A1h
%define WM_MOUSELEAVE                    	002A3h

%define WM_CUT                           	00300h
%define WM_COPY                          	00301h
%define WM_PASTE                         	00302h
%define WM_CLEAR                         	00303h
%define WM_UNDO                          	00304h
%define WM_RENDERFORMAT                  	00305h
%define WM_RENDERALLFORMATS              	00306h
%define WM_DESTROYCLIPBOARD              	00307h
%define WM_DRAWCLIPBOARD                 	00308h
%define WM_PAINTCLIPBOARD                	00309h
%define WM_VSCROLLCLIPBOARD              	0030Ah
%define WM_SIZECLIPBOARD                 	0030Bh
%define WM_ASKCBFORMATNAME               	0030Ch
%define WM_CHANGECBCHAIN                 	0030Dh
%define WM_HSCROLLCLIPBOARD              	0030Eh
%define WM_QUERYNEWPALETTE               	0030Fh
%define WM_PALETTEISCHANGING             	00310h
%define WM_PALETTECHANGED                	00311h
%define WM_HOTKEY                        	00312h

%define WM_PRINT                         	00317h
%define WM_PRINTCLIENT                   	00318h

%define WM_HANDHELDFIRST                 	00358h
%define WM_HANDHELDLAST                  	0035Fh

%define WM_AFXFIRST                      	00360h
%define WM_AFXLAST                       	0037Fh

%define WM_PENWINFIRST                   	00380h
%define WM_PENWINLAST                    	0038Fh

%define WM_APP                           	08000h

; NOTE: All Message Numbers below 0x0400 are RESERVED.
; Private Window Messages Start Here:

%define WM_USER                          	00400h


%define WMSZ_LEFT	 	 1
%define WMSZ_RIGHT	 	 2
%define WMSZ_TOP	 	 3
%define WMSZ_TOPLEFT	 	 4
%define WMSZ_TOPRIGHT	 	 5
%define WMSZ_BOTTOM	 	 6
%define WMSZ_BOTTOMLEFT	 	 7
%define WMSZ_BOTTOMRIGHT	 	 8
%define HTERROR	 	 (-2)
%define HTTRANSPARENT	 	 (-1)
%define HTNOWHERE	 	 0
%define HTCLIENT	 	 1
%define HTCAPTION	 	 2
%define HTSYSMENU	 	 3
%define HTGROWBOX	 	 4

%define HTMENU	 	 5
%define HTHSCROLL	 6	 
%define HTVSCROLL	 7	 
%define HTMINBUTTON	 8	 
%define HTMAXBUTTON	 9	 
%define HTLEFT	 	 10
%define HTRIGHT	 	 11
%define HTTOP	 	 12
%define HTTOPLEFT	 	13 
%define HTTOPRIGHT	 	 14
%define HTBOTTOM	 	 15
%define HTBOTTOMLEFT	 	16 
%define HTBOTTOMRIGHT	 	 17
%define HTBORDER	 	 18
	 
%define HTOBJECT	 	 19
%define HTCLOSE	 	 20
%define HTHELP	 	 21

; SendMessageTimeout values
%define SMTO_NORMAL         	00000h
%define SMTO_BLOCK          	00001h
%define SMTO_ABORTIFHUNG    	00002h
%define SMTO_NOTIMEOUTIFNOTHUNG 	00008h

; WM_MOUSEACTIVATE Return Codes
%define MA_ACTIVATE	 	 1
%define MA_ACTIVATEANDEAT	 	 2
%define MA_NOACTIVATE	 	 3
%define MA_NOACTIVATEANDEAT	 	 4

; WM_SETICON / WM_GETICON Type Codes
%define ICON_SMALL	 	 0
%define ICON_BIG	 	 1

; Window Styles
%define WS_OVERLAPPED	00000000h	 
%define WS_POPUP	80000000h	 
%define WS_CHILD	40000000h	 
%define WS_MINIMIZE	20000000h	 
%define WS_VISIBLE	10000000h	 
%define WS_DISABLED	08000000h	 
%define WS_CLIPSIBLINGS	04000000h	 
%define WS_CLIPCHILDREN	02000000h	 
%define WS_MAXIMIZE	01000000h	 
%define WS_CAPTION	00C00000h	 
%define WS_BORDER	00800000h	 
%define WS_DLGFRAME	00400000h	 
%define WS_VSCROLL	00200000h	 
%define WS_HSCROLL	00100000h	 
%define WS_SYSMENU	00080000h	 
%define WS_THICKFRAME	00040000h	 
%define WS_GROUP	00020000h	 
%define WS_TABSTOP	00010000h	 

%define WS_MINIMIZEBOX	00020000h	 
%define WS_MAXIMIZEBOX	00010000h	 

%define WS_TILED	WS_OVERLAPPED	 
%define WS_ICONIC	WS_MINIMIZE	 
%define WS_SIZEBOX	WS_THICKFRAME	 

%define WS_OVERLAPPEDWINDOW	WS_OVERLAPPED | WS_CAPTION |  WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX	 
%define WS_TILEDWINDOW	WS_OVERLAPPEDWINDOW

%define WS_POPUPWINDOW	WS_POPUP | WS_BORDER | WS_SYSMENU
%define WS_CHILDWINDOW	WS_CHILD

; Extended Window Styles

%define WS_EX_DLGMODALFRAME      	00000001h
%define WS_EX_NOPARENTNOTIFY     	00000004h
%define WS_EX_TOPMOST            	00000008h
%define WS_EX_ACCEPTFILES        	00000010h
%define WS_EX_TRANSPARENT        	00000020h
%define WS_EX_MDICHILD           	00000040h
%define WS_EX_TOOLWINDOW         	00000080h
%define WS_EX_WINDOWEDGE         	00000100h
%define WS_EX_CLIENTEDGE         	00000200h
%define WS_EX_CONTEXTHELP        	00000400h

%define WS_EX_RIGHT              	00001000h
%define WS_EX_LEFT               	00000000h
%define WS_EX_RTLREADING         	00002000h
%define WS_EX_LTRREADING         	00000000h
%define WS_EX_LEFTSCROLLBAR      	00004000h
%define WS_EX_RIGHTSCROLLBAR     	00000000h

%define WS_EX_CONTROLPARENT      	00010000h
%define WS_EX_STATICEDGE         	00020000h
%define WS_EX_APPWINDOW          	00040000h

%define WS_EX_OVERLAPPEDWINDOW   	WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE
%define WS_EX_PALETTEWINDOW      	WS_EX_WINDOWEDGE | WS_EX_TOOLWINDOW | WS_EX_TOPMOST


%define CS_VREDRAW	00001h	 
%define CS_HREDRAW	00002h	 
%define CS_DBLCLKS	00008h	 
%define CS_OWNDC	00020h	 
%define CS_CLASSDC	00040h	 
%define CS_PARENTDC	00080h	 
%define CS_NOCLOSE	00200h	 
%define CS_SAVEBITS	00800h	 
%define CS_BYTEALIGNCLIENT	01000h	 
%define CS_BYTEALIGNWINDOW	02000h	 
%define CS_GLOBALCLASS	04000h	

%define CS_IME	000010000h	 


%define OFN_READONLY	000000001h	 
%define OFN_OVERWRITEPROMPT	000000002h	 
%define OFN_HIDEREADONLY	000000004h	 
%define OFN_NOCHANGEDIR	000000008h	 
%define OFN_SHOWHELP	000000010h	 
%define OFN_ENABLEHOOK	000000020h	 
%define OFN_ENABLETEMPLATE	000000040h	 
%define OFN_ENABLETEMPLATEHANDLE	000000080h	 
%define OFN_NOVALIDATE	000000100h	 
%define OFN_ALLOWMULTISELECT	000000200h	 
%define OFN_EXTENSIONDIFFERENT	000000400h	 
%define OFN_PATHMUSTEXIST	000000800h	 
%define OFN_FILEMUSTEXIST	000001000h	 
%define OFN_CREATEPROMPT	000002000h	 
%define OFN_SHAREAWARE	000004000h	 
%define OFN_NOREADONLYRETURN	000008000h	 
%define OFN_NOTESTFILECREATE	000010000h	 
%define OFN_NONETWORKBUTTON	000020000h	 
%define OFN_NOLONGNAMES	000040000h	 
%define OFN_EXPLORER	000080000h	 
%define OFN_NODEREFERENCELINKS	000100000h	 
%define OFN_LONGNAMES	000200000h	 
%define OFN_ENABLEINCLUDENOTIFY	000400000h	 
%define OFN_ENABLESIZING	000800000h	
; Return values for the registered message sent to the hook function
; when a sharing violation occurs.  OFN_SHAREFALLTHROUGH allows the
; filename to be accepted, OFN_SHARENOWARN rejects the name but puts
; up no warning (returned when the app has already put up a warning
; message), and OFN_SHAREWARN puts up the default warning message
; for sharing violations.
;
; Note:  Undefined return values map to OFN_SHAREWARN, but are
;        reserved for future use.


%define OFN_SHAREFALLTHROUGH	2	 
%define OFN_SHARENOWARN	1	 
%define OFN_SHAREWARN	0	 

%define CDN_FIRST	0-601	 
%define CDN_LAST	0-699	 

; Notifications when Open or Save dialog status changes
%define CDN_INITDONE           		 	(CDN_FIRST - 00000h)
%define CDN_SELCHANGE           	 	(CDN_FIRST - 00001h)
%define CDN_FOLDERCHANGE        	 	(CDN_FIRST - 00002h)
%define CDN_SHAREVIOLATION      	 	(CDN_FIRST - 00003h)
%define CDN_HELP                	 	(CDN_FIRST - 00004h)
%define CDN_FILEOK              	 	(CDN_FIRST - 00005h)
%define CDN_TYPECHANGE          	 	(CDN_FIRST - 00006h)
%define CDN_INCLUDEITEM         	 	(CDN_FIRST - 00007h)

%define CDM_FIRST       		 	(WM_USER + 100)
%define CDM_LAST        		 	(WM_USER + 200)

; Messages to query information from the Open or Save dialogs

; lParam = pointer to text buffer that gets filled in
; wParam = max number of characters of the text buffer (including NULL)
; return = < 0 if error; number of characters needed (including NULL)
%define CDM_GETSPEC             	 	(CDM_FIRST + 00000h)

; lParam = pointer to text buffer that gets filled in
; wParam = max number of characters of the text buffer (including NULL)
; return = < 0 if error; number of characters needed (including NULL)
%define CDM_GETFILEPATH         	 	(CDM_FIRST + 00001h)

; lParam = pointer to text buffer that gets filled in
; wParam = max number of characters of the text buffer (including NULL)
; return = < 0 if error; number of characters needed (including NULL)
%define CDM_GETFOLDERPATH       	 	(CDM_FIRST + 00002h)

; lParam = pointer to ITEMIDLIST buffer that gets filled in
; wParam = size of the ITEMIDLIST buffer
; return = < 0 if error; length of buffer needed
%define CDM_GETFOLDERIDLIST     	 	(CDM_FIRST + 00003h)

; lParam = pointer to a string
; wParam = ID of control to change
; return = not used
%define CDM_SETCONTROLTEXT      	 	(CDM_FIRST + 00004h)

; lParam = not used
; wParam = ID of control to change
; return = not used
%define CDM_HIDECONTROL         	 	(CDM_FIRST + 00005h)

; lParam = pointer to default extension (no dot)
; wParam = not used
; return = not used
%define CDM_SETDEFEXT           	 	(CDM_FIRST + 00006h)

```