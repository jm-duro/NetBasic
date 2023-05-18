/*
 * libxlsxwriter
 *
 * Copyright 2014-2015, John McNamara, jmcnamara@cpan.org. See LICENSE.txt.
 */

namespace xlsxwriter

include "std/convert.e"
include "std/dll.e"
include "std/machine.e"
include "std/map.e"

ifdef WINDOWS then
	
	atom libxlsxwriter = open_dll( "libxlsxwriter.dll" )
	
elsifdef LINUX then
	
	atom libxlsxwriter = open_dll( "libxlsxwriter.so" )
	
elsedef
	
	include std/error.e
	error:crash( "This platform is not supported" )
	
end ifdef

constant
	C_UINT8		= C_UCHAR,
	C_UINT16	= C_USHORT,
	C_UINT32	= C_UINT,
	C_INT32		= C_INT,
$

ifdef MEMSTRUCT then
	
	memtype
		object		   as void,
		unsigned int   as lxw_row_t,
		unsigned short as lxw_col_t,
		unsigned char  as uint8_t,
		unsigned short as uint16_t,
		unsigned int   as uint32_t,
	$
	
end ifdef

constant
	_format_set_align					= define_c_proc( libxlsxwriter, "+format_set_align", {C_POINTER,C_UINT8} ),
	_format_set_bg_color				= define_c_proc( libxlsxwriter, "+format_set_bg_color", {C_POINTER,C_INT32} ),
	_format_set_bold					= define_c_proc( libxlsxwriter, "+format_set_bold", {C_POINTER} ),
	_format_set_border					= define_c_proc( libxlsxwriter, "+format_set_border", {C_POINTER,C_UINT8} ),
	_format_set_border_color			= define_c_proc( libxlsxwriter, "+format_set_border_color", {C_POINTER,C_INT32} ),
	_format_set_bottom					= define_c_proc( libxlsxwriter, "+format_set_bottom", {C_POINTER,C_UINT8} ),
	_format_set_bottom_color			= define_c_proc( libxlsxwriter, "+format_set_bottom_color", {C_POINTER,C_INT32} ),
	_format_set_diag_border				= define_c_proc( libxlsxwriter, "+format_set_diag_border", {C_POINTER,C_UINT8} ),
	_format_set_diag_color				= define_c_proc( libxlsxwriter, "+format_set_diag_color", {C_POINTER,C_INT32} ),
	_format_set_diag_type				= define_c_proc( libxlsxwriter, "+format_set_diag_type", {C_POINTER,C_UINT8} ),
	_format_set_fg_color				= define_c_proc( libxlsxwriter, "+format_set_fg_color", {C_POINTER,C_INT32} ),
	_format_set_font_charset			= define_c_proc( libxlsxwriter, "+format_set_font_charset", {C_POINTER,C_UINT8} ),
	_format_set_font_color				= define_c_proc( libxlsxwriter, "+format_set_font_color", {C_POINTER,C_INT32} ),
	_format_set_font_condense			= define_c_proc( libxlsxwriter, "+format_set_font_condense", {C_POINTER} ),
	_format_set_font_extend				= define_c_proc( libxlsxwriter, "+format_set_font_extend", {C_POINTER} ),
	_format_set_font_family				= define_c_proc( libxlsxwriter, "+format_set_font_family", {C_POINTER,C_UINT8} ),
	_format_set_font_name				= define_c_proc( libxlsxwriter, "+format_set_font_name", {C_POINTER,C_POINTER} ),
	_format_set_font_outline			= define_c_proc( libxlsxwriter, "+format_set_font_outline", {C_POINTER} ),
	_format_set_font_scheme				= define_c_proc( libxlsxwriter, "+format_set_font_scheme", {C_POINTER,C_POINTER} ),
	_format_set_font_script				= define_c_proc( libxlsxwriter, "+format_set_font_script", {C_POINTER,C_UINT8} ),
	_format_set_font_shadow				= define_c_proc( libxlsxwriter, "+format_set_font_shadow", {C_POINTER} ),
	_format_set_font_size				= define_c_proc( libxlsxwriter, "+format_set_font_size", {C_POINTER,C_UINT16} ),
	_format_set_font_strikeout			= define_c_proc( libxlsxwriter, "+format_set_font_strikeout", {C_POINTER} ),
	_format_set_hidden					= define_c_proc( libxlsxwriter, "+format_set_hidden", {C_POINTER} ),
	_format_set_indent					= define_c_proc( libxlsxwriter, "+format_set_indent", {C_POINTER,C_CHAR} ),
	_format_set_italic					= define_c_proc( libxlsxwriter, "+format_set_italic", {C_POINTER} ),
	_format_set_left					= define_c_proc( libxlsxwriter, "+format_set_left", {C_POINTER,C_UINT8} ),
	_format_set_left_color				= define_c_proc( libxlsxwriter, "+format_set_left_color", {C_POINTER,C_INT32} ),
	_format_set_num_format				= define_c_proc( libxlsxwriter, "+format_set_num_format", {C_POINTER,C_POINTER} ),
	_format_set_num_format_index		= define_c_proc( libxlsxwriter, "+format_set_num_format_index", {C_POINTER,C_UINT8} ),
	_format_set_pattern					= define_c_proc( libxlsxwriter, "+format_set_pattern", {C_POINTER,C_UINT8} ),
	_format_set_reading_order			= define_c_proc( libxlsxwriter, "+format_set_reading_order", {C_POINTER,C_UINT8} ),
	_format_set_right					= define_c_proc( libxlsxwriter, "+format_set_right", {C_POINTER,C_UINT8} ),
	_format_set_right_color				= define_c_proc( libxlsxwriter, "+format_set_right_color", {C_POINTER,C_INT32} ),
	_format_set_rotation				= define_c_proc( libxlsxwriter, "+format_set_rotation", {C_POINTER,C_SHORT} ),
	_format_set_shrink					= define_c_proc( libxlsxwriter, "+format_set_shrink", {C_POINTER} ),
	_format_set_text_wrap				= define_c_proc( libxlsxwriter, "+format_set_text_wrap", {C_POINTER} ),
	_format_set_theme					= define_c_proc( libxlsxwriter, "+format_set_theme", {C_POINTER,C_UINT8} ),
	_format_set_top						= define_c_proc( libxlsxwriter, "+format_set_top", {C_POINTER,C_UINT8} ),
	_format_set_top_color				= define_c_proc( libxlsxwriter, "+format_set_top_color", {C_POINTER,C_INT32} ),
	_format_set_underline				= define_c_proc( libxlsxwriter, "+format_set_underline", {C_POINTER,C_UINT8} ),
	_format_set_unlocked				= define_c_proc( libxlsxwriter, "+format_set_unlocked", {C_POINTER} ),
	_lxw_get_col						= define_c_func( libxlsxwriter, "+lxw_get_col", {C_POINTER}, C_UINT32 ),
	_lxw_get_col_2						= define_c_func( libxlsxwriter, "+lxw_get_col_2", {C_POINTER}, C_UINT32 ),
	_lxw_get_row						= define_c_func( libxlsxwriter, "+lxw_get_row", {C_POINTER}, C_UINT16 ),
	_lxw_get_row_2						= define_c_func( libxlsxwriter, "+lxw_get_row_2", {C_POINTER}, C_UINT16 ),
	_lxw_quote_sheetname				= define_c_func( libxlsxwriter, "+lxw_quote_sheetname", {C_POINTER}, C_POINTER ),
	_new_workbook						= define_c_func( libxlsxwriter, "+new_workbook", {C_POINTER}, C_POINTER ),
	_new_workbook_opt					= define_c_func( libxlsxwriter, "+new_workbook_opt", {C_POINTER,C_POINTER}, C_POINTER ),
	_workbook_add_format				= define_c_func( libxlsxwriter, "+workbook_add_format", {C_POINTER}, C_POINTER ),
	_workbook_add_worksheet				= define_c_func( libxlsxwriter, "+workbook_add_worksheet", {C_POINTER,C_POINTER}, C_POINTER ),
	_workbook_close						= define_c_func( libxlsxwriter, "+workbook_close", {C_POINTER}, C_UINT8 ),
	_workbook_define_name				= define_c_func( libxlsxwriter, "+workbook_define_name", {C_POINTER,C_POINTER, C_POINTER}, C_UINT8 ),
	_worksheet_activate					= define_c_proc( libxlsxwriter, "+worksheet_activate", {C_POINTER} ),
	_worksheet_autofilter				= define_c_func( libxlsxwriter, "+worksheet_autofilter", {C_POINTER,C_UINT32, C_UINT16,C_UINT32,C_UINT16}, C_CHAR ),
	_worksheet_center_horizontally		= define_c_proc( libxlsxwriter, "+worksheet_center_horizontally", {C_POINTER} ),
	_worksheet_center_vertically		= define_c_proc( libxlsxwriter, "+worksheet_center_vertically", {C_POINTER} ),
	_worksheet_fit_to_pages				= define_c_proc( libxlsxwriter, "+worksheet_fit_to_pages", {C_POINTER,C_UINT16, C_UINT16} ),
	_worksheet_gridlines				= define_c_proc( libxlsxwriter, "+worksheet_gridlines", {C_POINTER,C_UINT8} ),
	_worksheet_merge_range				= define_c_func( libxlsxwriter, "+worksheet_merge_range", {C_POINTER,C_UINT32,C_UINT16,C_UINT32,C_UINT16,C_POINTER,C_POINTER}, C_CHAR ),
	_worksheet_print_across				= define_c_proc( libxlsxwriter, "+worksheet_print_across", {C_POINTER} ),
	_worksheet_print_area				= define_c_func( libxlsxwriter, "+worksheet_print_area", {C_POINTER,C_UINT32,C_UINT16,C_UINT32,C_UINT16}, C_UINT8 ),
	_worksheet_print_row_col_headers	= define_c_proc( libxlsxwriter, "+worksheet_print_row_col_headers", {C_POINTER} ),
	_worksheet_repeat_columns			= define_c_func( libxlsxwriter, "+worksheet_repeat_columns", {C_POINTER,C_UINT16,C_UINT16}, C_UINT8 ),
	_worksheet_repeat_rows				= define_c_func( libxlsxwriter, "+worksheet_repeat_rows", {C_POINTER,C_UINT32,C_UINT32}, C_UINT8 ),
	_worksheet_select					= define_c_proc( libxlsxwriter, "+worksheet_select", {C_POINTER} ),
	_worksheet_set_column				= define_c_func( libxlsxwriter, "+worksheet_set_column", {C_POINTER,C_UINT16,C_UINT16,C_DOUBLE,C_POINTER,C_POINTER}, C_CHAR ),
	_worksheet_set_footer				= define_c_func( libxlsxwriter, "+worksheet_set_footer", {C_POINTER,C_POINTER}, C_UINT8 ),
	_worksheet_set_footer_opt			= define_c_func( libxlsxwriter, "+worksheet_set_footer_opt", {C_POINTER,C_POINTER}, C_UINT8 ),
	_worksheet_set_h_pagebreaks			= define_c_proc( libxlsxwriter, "+worksheet_set_h_pagebreaks", {C_POINTER,C_POINTER} ),
	_worksheet_set_header				= define_c_func( libxlsxwriter, "+worksheet_set_header", {C_POINTER,C_POINTER}, C_UINT8 ),
	_worksheet_set_header_opt			= define_c_func( libxlsxwriter, "+worksheet_set_header_opt", {C_POINTER,C_POINTER}, C_UINT8 ),
	_worksheet_set_landscape			= define_c_proc( libxlsxwriter, "+worksheet_set_landscape", {C_POINTER} ),
	_worksheet_set_margins				= define_c_proc( libxlsxwriter, "+worksheet_set_margins", {C_POINTER,C_DOUBLE,C_DOUBLE,C_DOUBLE,C_DOUBLE} ),
	_worksheet_set_page_view			= define_c_proc( libxlsxwriter, "+worksheet_set_page_view", {C_POINTER} ),
	_worksheet_set_paper				= define_c_proc( libxlsxwriter, "+worksheet_set_paper", {C_POINTER,C_UINT8} ),
	_worksheet_set_portrait				= define_c_proc( libxlsxwriter, "+worksheet_set_portrait", {C_POINTER} ),
	_worksheet_set_print_scale			= define_c_proc( libxlsxwriter, "+worksheet_set_print_scale", {C_POINTER,C_UINT16} ),
	_worksheet_set_row					= define_c_func( libxlsxwriter, "+worksheet_set_row", {C_POINTER,C_UINT32,C_DOUBLE,C_POINTER,C_POINTER}, C_CHAR ),
	_worksheet_set_start_page			= define_c_proc( libxlsxwriter, "+worksheet_set_start_page", {C_POINTER,C_UINT16} ),
	_worksheet_set_v_pagebreaks			= define_c_proc( libxlsxwriter, "+worksheet_set_v_pagebreaks", {C_POINTER,C_POINTER} ),
	_worksheet_write_array_formula		= define_c_func( libxlsxwriter, "+worksheet_write_array_formula", {C_POINTER,C_UINT32,C_UINT16,C_UINT32,C_UINT16,C_POINTER,C_POINTER}, C_CHAR ),
	_worksheet_write_blank				= define_c_func( libxlsxwriter, "+worksheet_write_blank", {C_POINTER,C_UINT32,C_UINT16,C_POINTER}, C_CHAR ),
	_worksheet_write_datetime			= define_c_func( libxlsxwriter, "+worksheet_write_datetime", {C_POINTER,C_UINT32,C_UINT16,C_POINTER,C_POINTER}, C_CHAR ),
	_worksheet_write_formula			= define_c_func( libxlsxwriter, "+worksheet_write_formula", {C_POINTER,C_UINT32,C_UINT16,C_POINTER,C_POINTER}, C_CHAR ),
	_worksheet_write_number				= define_c_func( libxlsxwriter, "+worksheet_write_number", {C_POINTER,C_UINT32,C_UINT16,C_DOUBLE,C_POINTER}, C_CHAR ),
	_worksheet_write_string				= define_c_func( libxlsxwriter, "+worksheet_write_string", {C_POINTER,C_UINT32,C_UINT16,C_POINTER,C_POINTER}, C_CHAR ),
	_worksheet_write_url				= define_c_func( libxlsxwriter, "+worksheet_write_url", {C_POINTER,C_UINT32,C_UINT16,C_POINTER,C_POINTER}, C_CHAR ),
	_worksheet_write_url_opt			= define_c_func( libxlsxwriter, "+worksheet_write_url_opt", {C_POINTER,C_UINT32,C_UINT16,C_POINTER,C_POINTER,C_POINTER,C_POINTER}, C_CHAR ),
$

public constant NULL = dll:NULL

public constant
	LXW_ROW_MAX				= 1048576,
	LXW_COL_MAX				=	16384,
	LXW_COL_META_MAX		=	  128,
	LXW_HEADER_FOOTER_MAX	=	  255,
$

/* The Excel 2007 specification says that the maximum number of page
 * breaks is 1026. However, in practice it is actually 1023. */
public constant LXW_BREAKS_MAX = 1023

/** Default column width in Excel */
public constant LXW_DEF_COL_WIDTH = 8.43

/** Default row height in Excel */
public constant LXW_DEF_ROW_HEIGHT = 15


/**
 * Errors conditions encountered when closing the Workbook and writing the Excel file to disk.
 */
public enum type lxw_close_error
	
	/** No error */
	LXW_CLOSE_ERROR_NONE = 0,
	
	/** Error encountered when creating file zip container */
	LXW_CLOSE_ERROR_ZIP
	
end type

ifdef MEMSTRUCT then
	
	public memstruct stailq_head
		pointer void stqh_first	/* first element */
		pointer void stqh_last	/* addr of last next element */
	end memstruct
	
	public memstruct stailq_entry
		pointer void stqe_next	/* next element */
	end memstruct
	
	/**
	* Struct to represent a date and time in Excel.
	*/
	public memstruct lxw_datetime
		
		int year	/* Year		: 1900 - 9999	 */
		int month	/* Month	:	 1 - 12		 */
		int day		/* Day		:	 1 - 31		 */
		int hour	/* Hour		:	 0 - 23		 */
		int min		/* Minute	:	 0 - 59		 */
		double sec	/* Seconds	:	 0 - 59.999	 */
		
	end memstruct
	
	public constant
		SIZEOF_LXW_DATETIME = sizeof( lxw_datetime )
	
	/**
	* Struct to represent an Excel workbook.
	*/
	public memstruct lxw_workbook
		
		pointer void file
		pointer void worksheets
		pointer void formats
		pointer void defined_names
		pointer void sst
		pointer void properties
		pointer char filename
		pointer void options
		
		uint16_t num_sheets
		uint16_t first_sheet
		uint32_t active_sheet
		uint16_t num_xf_formats
		uint16_t num_format_count
		
		uint16_t font_count
		uint16_t border_count
		uint16_t fill_count
		uint8_t optimize
		
		pointer void used_xf_formats
		
	end memstruct
	
	/**
	* Optional parameters when creating a new Workbook object via new_workbook_opt().
	*/
	public memstruct lxw_workbook_options
		uint8_t constant_memory
	end memstruct
	
	/**
	* Struct to represent an Excel worksheet.
	*/
	public memstruct lxw_worksheet
		
		pointer void file
		pointer void optimize_tmpfile
		pointer void table
		pointer void hyperlinks
		pointer void array
		pointer void merged_ranges
		
		lxw_row_t dim_rowmin
		lxw_row_t dim_rowmax
		lxw_col_t dim_colmin
		lxw_col_t dim_colmax
		
		pointer void sst
		pointer char name
		pointer char quoted_name
		
		uint32_t index
		uint8_t active
		uint8_t selected
		uint8_t hidden
		pointer void active_sheet
		
		pointer void col_options
		uint16_t col_options_max
		
		pointer void col_sizes
		uint16_t col_sizes_max
		
		pointer void col_formats
		uint16_t col_formats_max
		
		uint8_t col_size_changed
		uint8_t optimize
		pointer void optimize_row
		
		uint16_t fit_height
		uint16_t fit_width
		uint16_t horizontal_dpi
		uint16_t hlink_count
		uint16_t page_start
		uint16_t print_scale
		uint16_t rel_count
		uint16_t vertical_dpi
		uint8_t filter_on
		uint8_t fit_page
		uint8_t hcenter
		uint8_t orientation
		uint8_t outline_changed
		uint8_t page_order
		uint8_t page_setup_changed
		uint8_t page_view
		uint8_t paper_size
		uint8_t print_gridlines
		uint8_t print_headers
		uint8_t print_options_changed
		uint8_t screen_gridlines
		uint8_t tab_color
		uint8_t vba_codename
		uint8_t vcenter
		
		double margin_left
		double margin_right
		double margin_top
		double margin_bottom
		double margin_header
		double margin_footer
		
		uint8_t header_footer_changed
		char header[LXW_HEADER_FOOTER_MAX]
		char footer[LXW_HEADER_FOOTER_MAX]
		
		lxw_repeat_rows repeat_rows
		lxw_repeat_cols repeat_cols
		lxw_print_area print_area
		lxw_autofilter autofilter
		
		uint16_t merged_range_count
		
		pointer void hbreaks
		pointer void vbreaks
		pointer void external_hyperlinks
		
		stailq_entry list_pointers
		
	end memstruct
	
	/**
	* Define the queue.h structs for the workbook lists.
	*/
	public memstruct lxw_worksheets
		
		pointer void stqh_first	/* first element */
		pointer void stqh_last	/* addr of last next element */
		
	end memstruct
	
elsedef
	
	ifdef BITS64 then
		
		include std/error.e
		error:crash( "64-bit currentl not supported" )
		
	end ifdef
	
	public constant
		stqh_first			= 0,	/* first element */
		stqh_last			= 4,	/* addr of last next element */
		SIZEOF_STAILQ_HEAD	= 8,
	$
	
	public constant
		stqe_next			= 0,	/* next element */
		SIZEOF_STAILQ_ENTRY	= 4,
	$
	
	public constant
		lxw_datetime__year		=  0, -- int
		lxw_datetime__month		=  4, -- int
		lxw_datetime__day		=  8, -- int
		lxw_datetime__hour		= 12, -- int
		lxw_datetime__min		= 16, -- int
		lxw_datetime__sec		= 20, -- double
		SIZEOF_LXW_DATETIME		= 32,
	$
	
	public constant
		lxw_workbook_options__constant_memory	= 0, -- uint8_t
		SIZEOF_LXW_WORKBOOK_OPTIONS				= 1,
	$
	
	public constant
		lxw_workbook__file						=	0, -- FILE*
		lxw_workbook__worksheets				=	4, -- lxw_worksheets*
		lxw_workbook__formats					=	8, -- lxw_formats*
		lxw_workbook__defined_names				=  12, -- lxw_defined_names*
		lxw_workbook__sst						=  16, -- lxw_sst*
		lxw_workbook__properties				=  20, -- lxw_properties*
		lxw_workbook__filename					=  24, -- const char*
		lxw_workbook__options					=  28, -- lxw_workbook_options*
		lxw_workbook__num_sheets				=  30, -- uint16_t
		lxw_workbook__first_sheet				=  32, -- uint16_t
		lxw_workbook__active_sheet				=  36, -- uint32_t
		lxw_workbook__num_xf_formats			=  40, -- uint16_t
		lxw_workbook__num_format_count			=  42, -- uint16_t
		lxw_workbook__font_count				=  44, -- uint16_t
		lxw_workbook__border_count				=  46, -- uint16_t
		lxw_workbook__fill_count				=  48, -- uint16_t
		lxw_workbook__optimize					=  50, -- uint8_t
		lxw_workbook__used_xf_formats			=  52, -- lxw_hash_table*
		SIZEOF_LXW_WORKBOOK						=  56,
	$
	
	public constant
		lxw_worksheet__file						=	0, -- FILE *
		lxw_worksheet__optimize_tmpfile			=	4, -- FILE *
		lxw_worksheet__table					=	8, -- lxw_table_rows *
		lxw_worksheet__hyperlinks				=  12, -- lxw_table_rows *
		lxw_worksheet__array					=  16, -- lxw_cell**
		lxw_worksheet__merged_ranges			=  20, -- lxw_merged_ranges*
		lxw_worksheet__dim_rowmin				=  24, -- lxw_row_t
		lxw_worksheet__dim_rowmax				=  28, -- lxw_row_t
		lxw_worksheet__dim_colmin				=  32, -- lxw_col_t
		lxw_worksheet__dim_colmax				=  34, -- lxw_col_t
		lxw_worksheet__sst						=  36, -- lxw_sst*
		lxw_worksheet__name						=  40, -- char*
		lxw_worksheet__quoted_name				=  44, -- char*
		lxw_worksheet__index					=  48, -- uint32_t
		lxw_worksheet__active					=  52, -- uint8_t
		lxw_worksheet__selected					=  53, -- uint8_t
		lxw_worksheet__hidden					=  54, -- uint8_t
		lxw_worksheet__active_sheet				=  56, -- uint32_t
		lxw_worksheet__col_options				=  60, -- lxw_col_options**
		lxw_worksheet__col_options_max			=  64, -- uint16_t
		lxw_worksheet__col_sizes				=  68, -- double*
		lxw_worksheet__col_sizes_max			=  72, -- uint16_t
		lxw_worksheet__col_formats				=  76, -- lxw_format**
		lxw_worksheet__col_formats_max			=  80, -- uint16_t
		lxw_worksheet__col_size_changed			=  82, -- uint8_t
		lxw_worksheet__optimize					=  83, -- uint8_t
		lxw_worksheet__optimize_row				=  84, -- lxw_row*
		lxw_worksheet__fit_width				=  90, -- uint16_t
		lxw_worksheet__fit_height				=  88, -- uint16_t
		lxw_worksheet__horizontal_dpi			=  92, -- uint16_t
		lxw_worksheet__hlink_count				=  94, -- uint16_t
		lxw_worksheet__page_start				=  96, -- uint16_t
		lxw_worksheet__print_scale				=  98, -- uint16_t
		lxw_worksheet__rel_count				= 100, -- uint16_t
		lxw_worksheet__vertical_dpi				= 102, -- uint16_t
		lxw_worksheet__filter_on				= 104, -- uint8_t
		lxw_worksheet__fit_page					= 105, -- uint8_t
		lxw_worksheet__hcenter					= 106, -- uint8_t
		lxw_worksheet__orientation				= 107, -- uint8_t
		lxw_worksheet__outline_changed			= 108, -- uint8_t
		lxw_worksheet__page_order				= 109, -- uint8_t
		lxw_worksheet__page_setup_changed		= 110, -- uint8_t
		lxw_worksheet__page_view				= 111, -- uint8_t
		lxw_worksheet__paper_size				= 112, -- uint8_t
		lxw_worksheet__print_gridlines			= 113, -- uint8_t
		lxw_worksheet__print_headers			= 114, -- uint8_t
		lxw_worksheet__print_options_changed	= 115, -- uint8_t
		lxw_worksheet__screen_gridlines			= 116, -- uint8_t
		lxw_worksheet__tab_color				= 117, -- uint8_t
		lxw_worksheet__vba_codename				= 118, -- uint8_t
		lxw_worksheet__vcenter					= 119, -- uint8_t
		lxw_worksheet__margin_left				= 120, -- double
		lxw_worksheet__margin_right				= 128, -- double
		lxw_worksheet__margin_top				= 136, -- double
		lxw_worksheet__margin_bottom			= 144, -- double
		lxw_worksheet__margin_header			= 152, -- double
		lxw_worksheet__margin_footer			= 160, -- double
		lxw_worksheet__header_footer_changed	= 168, -- uint8_t
		lxw_worksheet__header					= 169, -- char[LXW_HEADER_FOOTER_MAX]
		lxw_worksheet__footer					= 424, -- char[LXW_HEADER_FOOTER_MAX]
		lxw_worksheet__repeat_rows				= 680, -- lxw_repeat_rows
		lxw_worksheet__repeat_cols				= 692, -- lxw_repeat_cols
		lxw_worksheet__print_area				= 700, -- lxw_print_area
		lxw_worksheet__autofilter				= 716, -- lxw_autofilter
		lxw_worksheet__merged_range_count		= 732, -- uint16_t
		lxw_worksheet__hbreaks					= 736, -- lxw_row_t*
		lxw_worksheet__vbreaks					= 740, -- lxw_col_t*
		lxw_worksheet__external_hyperlinks		= 744, -- lxw_rel_tuples*
		lxw_worksheet__list_pointers			= 748, -- lxw_worksheet*
		SIZEOF_LXW_WORKSHEET					= 752,
	$
	
	public constant
		lxw_worksheets__stqh_first	= 0, -- pointer
		lxw_worksheets__stqh_last	= 4, -- pointer
		SIZEOF_LXW_WORKSHEETS		= 8,
	$
	
end ifdef

/**
 * Error codes from `worksheet_write*()` functions.
 */
public enum type lxw_write_error
	
	/** No error. */
	LXW_WRITE_ERROR_NONE = 0,
	
	/** Row or column index out of range. */
	LXW_RANGE_ERROR,
	
	/** String exceeds Excel's LXW_STRING_LENGTH_ERROR limit. */
	LXW_STRING_LENGTH_ERROR,
	
	/** Error finding string index. */
	LXW_STRING_HASH_ERROR
	
end type

/**
 * Gridline options using in `worksheet_gridlines()`.
 */
public enum type lxw_gridlines
	
	/** Hide screen and print gridlines. */
	LXW_HIDE_ALL_GRIDLINES = 0,
	
	/** Show screen gridlines. */
	LXW_SHOW_SCREEN_GRIDLINES,
	
	/** Show print gridlines. */
	LXW_SHOW_PRINT_GRIDLINES,
	
	/** Show screen and print gridlines. */
	LXW_SHOW_ALL_GRIDLINES
	
end type

public constant
	LXW_FORMAT_FIELD_LEN		= 128,
	LXW_DEFAULT_FONT_NAME		= "Calibri",
	LXW_DEFAULT_FONT_FAMILY		= 2,
	LXW_DEFAULT_FONT_THEME		= 1,
	LXW_PROPERTY_UNSET			= -1,
	LXW_COLOR_UNSET				= -1,
	LXW_COLOR_MASK				= 0xFFFFFF,
	LXW_MIN_FONT_SIZE			= 1,
	LXW_MAX_FONT_SIZE			= 409,
$

/** Format underline values for format_set_underline(). */
public enum type lxw_format_underlines
	
	/** Single underline */
	LXW_UNDERLINE_SINGLE = 1,
	
	/** Double underline */
	LXW_UNDERLINE_DOUBLE,
	
	/** Single accounting underline */
	LXW_UNDERLINE_SINGLE_ACCOUNTING,
	
	/** Double accounting underline */
	LXW_UNDERLINE_DOUBLE_ACCOUNTING
	
end type

/** Superscript and subscript values for format_set_font_script(). */
public enum type lxw_format_scripts
	
	/** Superscript font */
	LXW_FONT_SUPERSCRIPT = 1,
	
	/** Subscript font */
	LXW_FONT_SUBSCRIPT
	
end type

/** Alignment values for format_set_align(). */
public enum type lxw_format_alignments
	
	/** No alignment. Cell will use Excel's default for the data type */
	LXW_ALIGN_NONE = 0,
	
	/** Left horizontal alignment */
	LXW_ALIGN_LEFT,
	
	/** Center horizontal alignment */
	LXW_ALIGN_CENTER,
	
	/** Right horizontal alignment */
	LXW_ALIGN_RIGHT,
	
	/** Cell fill horizontal alignment */
	LXW_ALIGN_FILL,
	
	/** Justify horizontal alignment */
	LXW_ALIGN_JUSTIFY,
	
	/** Center Across horizontal alignment */
	LXW_ALIGN_CENTER_ACROSS,
	
	/** Left horizontal alignment */
	LXW_ALIGN_DISTRIBUTED,
	
	/** Top vertical alignment */
	LXW_ALIGN_VERTICAL_TOP,
	
	/** Bottom vertical alignment */
	LXW_ALIGN_VERTICAL_BOTTOM,
	
	/** Center vertical alignment */
	LXW_ALIGN_VERTICAL_CENTER,
	
	/** Justify vertical alignment */
	LXW_ALIGN_VERTICAL_JUSTIFY,
	
	/** Distributed vertical alignment */
	LXW_ALIGN_VERTICAL_DISTRIBUTED
	
end type

public enum type lxw_format_diagonal_types
	
	LXW_DIAGONAL_BORDER_UP = 1,
	LXW_DIAGONAL_BORDER_DOWN,
	LXW_DIAGONAL_BORDER_UP_DOWN
	
end type

/** Predefined values for common colors. */
public enum type lxw_defined_colors
	
	/** Black */
	LXW_COLOR_BLACK = 0x000000,
	
	/** Blue */
	LXW_COLOR_BLUE = 0x0000FF,
	
	/** Brown */
	LXW_COLOR_BROWN = 0x800000,
	
	/** Cyan */
	LXW_COLOR_CYAN = 0x00FFFF,
	
	/** Gray */
	LXW_COLOR_GRAY = 0x808080,
	
	/** Green */
	LXW_COLOR_GREEN = 0x008000,
	
	/** Lime */
	LXW_COLOR_LIME = 0x00FF00,
	
	/** Magenta */
	LXW_COLOR_MAGENTA = 0xFF00FF,
	
	/** Navy */
	LXW_COLOR_NAVY = 0x000080,
	
	/** Orange */
	LXW_COLOR_ORANGE = 0xFF6600,
	
	/** Pink */
	LXW_COLOR_PINK = 0xFF00FF,
	
	/** Purple */
	LXW_COLOR_PURPLE = 0x800080,
	
	/** Red */
	LXW_COLOR_RED = 0xFF0000,
	
	/** Silver */
	LXW_COLOR_SILVER = 0xC0C0C0,
	
	/** White */
	LXW_COLOR_WHITE = 0xFFFFFF,
	
	/** Yellow */
	LXW_COLOR_YELLOW = 0xFFFF00
	
end type

/** Pattern value for use with format_set_pattern(). */
public enum type lxw_format_patterns
	
	/** Empty pattern */
	LXW_PATTERN_NONE = 0,
	
	/** Solid pattern */
	LXW_PATTERN_SOLID,
	
	/** Medium gray pattern */
	LXW_PATTERN_MEDIUM_GRAY,
	
	/** Dark gray pattern */
	LXW_PATTERN_DARK_GRAY,
	
	/** Light gray pattern */
	LXW_PATTERN_LIGHT_GRAY,
	
	/** Dark horizontal line pattern */
	LXW_PATTERN_DARK_HORIZONTAL,
	
	/** Dark vertical line pattern */
	LXW_PATTERN_DARK_VERTICAL,
	
	/** Dark diagonal stripe pattern */
	LXW_PATTERN_DARK_DOWN,
	
	/** Reverse dark diagonal stripe pattern */
	LXW_PATTERN_DARK_UP,
	
	/** Dark grid pattern */
	LXW_PATTERN_DARK_GRID,
	
	/** Dark trellis pattern */
	LXW_PATTERN_DARK_TRELLIS,
	
	/** Light horizontal Line pattern */
	LXW_PATTERN_LIGHT_HORIZONTAL,
	
	/** Light vertical line pattern */
	LXW_PATTERN_LIGHT_VERTICAL,
	
	/** Light diagonal stripe pattern */
	LXW_PATTERN_LIGHT_DOWN,
	
	/** Reverse light diagonal stripe pattern */
	LXW_PATTERN_LIGHT_UP,
	
	/** Light grid pattern */
	LXW_PATTERN_LIGHT_GRID,
	
	/** Light trellis pattern */
	LXW_PATTERN_LIGHT_TRELLIS,
	
	/** 12.5% gray pattern */
	LXW_PATTERN_GRAY_125,
	
	/** 6.25% gray pattern */
	LXW_PATTERN_GRAY_0625
	
end type

/** Cell border styles for use with format_set_border(). */
public enum type lxw_format_borders
	
	/** No border */
	LXW_BORDER_NONE,
	
	/** Thin border style */
	LXW_BORDER_THIN,
	
	/** Medium border style */
	LXW_BORDER_MEDIUM,
	
	/** Dashed border style */
	LXW_BORDER_DASHED,
	
	/** Dotted border style */
	LXW_BORDER_DOTTED,
	
	/** Thick border style */
	LXW_BORDER_THICK,
	
	/** Double border style */
	LXW_BORDER_DOUBLE,
	
	/** Hair border style */
	LXW_BORDER_HAIR,
	
	/** Medium dashed border style */
	LXW_BORDER_MEDIUM_DASHED,
	
	/** Dash-dot border style */
	LXW_BORDER_DASH_DOT,
	
	/** Medium dash-dot border style */
	LXW_BORDER_MEDIUM_DASH_DOT,
	
	/** Dash-dot-dot border style */
	LXW_BORDER_DASH_DOT_DOT,
	
	/** Medium dash-dot-dot border style */
	LXW_BORDER_MEDIUM_DASH_DOT_DOT,
	
	/** Slant dash-dot border style */
	LXW_BORDER_SLANT_DASH_DOT
	
end type

function peek_ptr( atom addr )
	
--	ifdef BITS64 then
--		return peek8u( addr )
--	elsedef
		return peek4u( addr )
--	end ifdef
	
end function

procedure poke_int( atom addr, atom value )
	
--	ifdef BITS64 then
--		poke8( addr, value )
--	elsedef
		poke4( addr, value )
--	end ifdef
	
end procedure

procedure poke_dbl( atom addr, atom value )
	poke( addr, atom_to_float64(value) )
end procedure

/**
 * Allocate a datetime structure from a Euphoria datetime value.
 *
 * 'datetime' should be {year, month, day, hour, minute, second}
 */
public function allocate_datetime( sequence datetime, atom cleanup = 0 )
	
	atom ptr = allocate_data( SIZEOF_LXW_DATETIME, cleanup )
	mem_set( ptr, NULL, SIZEOF_LXW_DATETIME )
	
	ifdef MEMSTRUCT then
		-- easy-peasy!
		ptr.lxw_datetime = datetime
		
	elsedef
		-- not-so-easy!
		
		switch length( datetime ) with fallthru do
			
			case 6 then poke_dbl( ptr + lxw_datetime__sec,	 datetime[6] )
			case 5 then poke_int( ptr + lxw_datetime__min,	 datetime[5] )
			case 4 then poke_int( ptr + lxw_datetime__hour,	 datetime[4] )
			case 3 then poke_int( ptr + lxw_datetime__day,	 datetime[3] )
			case 2 then poke_int( ptr + lxw_datetime__month, datetime[2] )
			case 1 then poke_int( ptr + lxw_datetime__year,	 datetime[1] )
			
		end switch
		
	end ifdef
	
	return ptr
end function

/**
 * Allocate a NULL terminated array of 4-byte values.
 */
public function allocate_array4( sequence data, atom cleanup = 0 )
	
	ifdef MEMSTRUCT then
		atom size = sizeof( C_UINT ) * (length(data)+1)
		
--	elsifdef BITS64 then
--		atom size = 8 * (length(data)+1)
		
	elsedef
		atom size = 4 * (length(data)+1)
		
	end ifdef
	
	atom ptr = allocate_data( size, cleanup )
	poke4( ptr, data & {NULL} )
	
	return ptr
end function

/* N.B. We have to track the filename object in memory for the lifetime of each Workbook. */
map m_filename = map:new()

/**
 * Create a new workbook object with (optional) additional workbook options.
 */
public function new_workbook( object filename, atom options = NULL )
	
	atom result = NULL
	
	if atom( filename ) then filename = peek_string( filename ) end if
	if sequence( filename ) then filename = allocate_string( filename ) end if
	
	if options = NULL then
		result = c_func( _new_workbook, {filename} )
		
	else
		result = c_func( _new_workbook_opt, {filename,options} )
		
	end if
	
	map:put( m_filename, result, filename )
	
	return result
end function

/**
 * Create a new workbook object with additional workbook options.
 */
public function new_workbook_opt( object filename, atom options )
	
	if atom( filename ) then filename = peek_string( filename ) end if
	if sequence( filename ) then filename = allocate_string( filename ) end if
	
	atom result = c_func( _new_workbook_opt, {filename,options} )
	
	map:put( m_filename, result, filename )
	
	return result
end function

/**
 * Create a new Format object to format cells in worksheets.
 */
public function workbook_add_format( atom workbook )
	return c_func( _workbook_add_format, {workbook} )
end function

/**
 * Add a new worksheet to a workbook with (optional) the provided name.
 */
public function workbook_add_worksheet( atom workbook, object sheetname = NULL )
	if sequence( sheetname ) then sheetname = allocate_string( sheetname, 1 ) end if
	return c_func( _workbook_add_worksheet, {workbook,sheetname} )
end function

/**
 * Close the Workbook object and write the XLSX file.
 */
public function workbook_close( atom workbook )
	
	atom result = c_func( _workbook_close, {workbook} )
	
	if result = 0 then
		-- clean up the workbook filename object
		
		atom filename = map:get( m_filename, workbook, NULL )
		
		if filename != NULL then
			free( filename )
		end if
		
		map:remove( m_filename, workbook )
		
	end if
	
	return result
end function

/**
 * Return a list of all Worksheets in the Workbook.
 */
public function workbook_get_worksheets( atom workbook )
	
	sequence result = {}
	
	ifdef MEMSTRUCT then
		
		atom worksheets = workbook.lxw_workbook.worksheets
		atom next = worksheets.stailq_head.stqh_first
		
		while next != NULL do
			result = append( result, next )
			next = next.lxw_worksheet.list_pointers.stqe_next
		end while
		
	elsedef
		
		atom worksheets = peek_ptr( workbook + lxw_workbook__worksheets )
		atom next = peek_ptr( worksheets + stqh_first )
		
		while next != NULL do
			result = append( result, next )
			next = peek_ptr( next + lxw_worksheet__list_pointers + stqe_next )
		end while
		
	end ifdef
	
	return result
end function

/**
 * Create a defined name in the workbook to use as a variable.
 */
public function workbook_define_name( atom workbook, object name, object formula )
	
	if sequence( name ) then name = allocate_string( name, 1 ) end if
	if sequence( formula ) then formula = allocate_string( formula, 1 ) end if
	
	return c_func( _workbook_define_name, {workbook,name,formula} )
end function

/**
 * Write a number to a worksheet cell.
 */
public function worksheet_write_number( atom worksheet, sequence cell, atom number, atom format = NULL )
	return c_func( _worksheet_write_number, {worksheet,cell[1],cell[2],number,format} )
end function

/**
 * Write a string to a worksheet cell.
 */
public function worksheet_write_string( atom worksheet, sequence cell, object string, atom format = NULL )
	if sequence( string ) then string = allocate_string( string, 1 ) end if
	return c_func( _worksheet_write_string, {worksheet,cell[1],cell[2],string,format} )
end function

/**
 * Write a formula to a worksheet cell.
 */
public function worksheet_write_formula( atom worksheet, sequence cell, object formula, atom format = NULL )
	if sequence( formula ) then formula = allocate_string( formula, 1 ) end if
	return c_func( _worksheet_write_formula, {worksheet,cell[1],cell[2],formula,format} )
end function

/**
 * Write an array formula to a worksheet cell.
 */
public function worksheet_write_array_formula( atom worksheet, sequence range, object formula, atom format = NULL )
	if sequence( formula ) then formula = allocate_string( formula, 1 ) end if
	return c_func( _worksheet_write_array_formula, {worksheet,range[1],range[2],range[3],range[4],formula,format} )
end function

/**
 * Write a date or time to a worksheet cell.
 */
public function worksheet_write_datetime( atom worksheet, sequence cell, object datetime, atom format = NULL )
	if sequence( datetime ) then datetime = allocate_datetime( datetime, 1 ) end if
	return c_func( _worksheet_write_datetime, {worksheet,cell[1],cell[2],datetime,format} )
end function

/**
 * Write a URL/hyperlink to a worksheet cell.
 */
public function worksheet_write_url( atom worksheet, sequence cell, object url, object string = NULL,
		object tooltip = NULL, atom format = NULL )
	
	if sequence( url ) then url = allocate_string( url, 1 ) end if
	if sequence( string ) then string = allocate_string( string, 1 ) end if
	if sequence( tooltip ) then tooltip = allocate_string( tooltip, 1 ) end if
	
	if string = NULL and tooltip = NULL then
		return c_func( _worksheet_write_url, {worksheet,cell[1],cell[2],url,format} )
	else
		return c_func( _worksheet_write_url_opt, {worksheet,cell[1],cell[2],url,string,tooltip,format} )
	end if
	
end function

/**
 * Write a formatted blank worksheet cell.
 */
public function worksheet_write_blank( atom worksheet, sequence cell, atom format = NULL )
	return c_func( _worksheet_write_blank, {worksheet,cell[1],cell[2],format} )
end function

/**
 * Set the properties for a row of cells.
 */
public function worksheet_set_row( atom worksheet, atom row, atom height, atom format = NULL, atom options = NULL )
	return c_func( _worksheet_set_row, {worksheet,row,height,format,options} )
end function

/**
 * Set the properties for one or more columns of cells.
 */
public function worksheet_set_column( atom worksheet, sequence cols, atom width, atom format = NULL, atom options = NULL )
	return c_func( _worksheet_set_column, {worksheet,cols[1],cols[2],width,format,options} )
end function

/**
 * Merge a range of cells.
 */
public function worksheet_merge_range( atom worksheet, sequence range, object string, atom format = NULL )
	if sequence( string ) then string = allocate_string( string, 1 ) end if
	return c_func( _worksheet_merge_range, {worksheet,range[1],range[2],range[3],range[4],string,format} )
end function

/**
 * Set the autofilter area in the worksheet.
 */
public function worksheet_autofilter( atom worksheet, sequence range )
	return c_func( _worksheet_autofilter, {worksheet,range[1],range[2],range[3],range[4]} )
end function

/**
 * Make a worksheet the active, i.e., visible worksheet.
 */
public procedure worksheet_activate( atom worksheet )
	c_proc( _worksheet_activate, {worksheet} )
end procedure

/**
 * Set a worksheet tab as selected.
 */
public procedure worksheet_select( atom worksheet )
	c_proc( _worksheet_select, {worksheet} )
end procedure

/**
 * Set the page orientation as landscape.
 */
public procedure worksheet_set_landscape( atom worksheet )
	c_proc( _worksheet_set_landscape, {worksheet} )
end procedure

/**
 * Set the page orientation as portrait.
 */
public procedure worksheet_set_portrait( atom worksheet )
	c_proc( _worksheet_set_portrait, {worksheet} )
end procedure

/**
 * Set the page layout to page view mode.
 */
public procedure worksheet_set_page_view( atom worksheet )
	c_proc( _worksheet_set_page_view, {worksheet} )
end procedure

/**
 * Set the paper type for printing.
 *
 *	 | Index | Paper format			| Paper size		|
 *	 | ----- | -------------------- | ----------------- |
 *	 |	0	 | Printer default		| Printer default	|
 *	 |	1	 | Letter				| 8 1/2 x 11 in		|
 *	 |	2	 | Letter Small			| 8 1/2 x 11 in		|
 *	 |	3	 | Tabloid				| 11 x 17 in		|
 *	 |	4	 | Ledger				| 17 x 11 in		|
 *	 |	5	 | Legal				| 8 1/2 x 14 in		|
 *	 |	6	 | Statement			| 5 1/2 x 8 1/2 in	|
 *	 |	7	 | Executive			| 7 1/4 x 10 1/2 in |
 *	 |	8	 | A3					| 297 x 420 mm		|
 *	 |	9	 | A4					| 210 x 297 mm		|
 *	 | 10	 | A4 Small				| 210 x 297 mm		|
 *	 | 11	 | A5					| 148 x 210 mm		|
 *	 | 12	 | B4					| 250 x 354 mm		|
 *	 | 13	 | B5					| 182 x 257 mm		|
 *	 | 14	 | Folio				| 8 1/2 x 13 in		|
 *	 | 15	 | Quarto				| 215 x 275 mm		|
 *	 | 16	 | ---					| 10x14 in			|
 *	 | 17	 | ---					| 11x17 in			|
 *	 | 18	 | Note					| 8 1/2 x 11 in		|
 *	 | 19	 | Envelope 9			| 3 7/8 x 8 7/8		|
 *	 | 20	 | Envelope 10			| 4 1/8 x 9 1/2		|
 *	 | 21	 | Envelope 11			| 4 1/2 x 10 3/8	|
 *	 | 22	 | Envelope 12			| 4 3/4 x 11		|
 *	 | 23	 | Envelope 14			| 5 x 11 1/2		|
 *	 | 24	 | C size sheet			| ---				|
 *	 | 25	 | D size sheet			| ---				|
 *	 | 26	 | E size sheet			| ---				|
 *	 | 27	 | Envelope DL			| 110 x 220 mm		|
 *	 | 28	 | Envelope C3			| 324 x 458 mm		|
 *	 | 29	 | Envelope C4			| 229 x 324 mm		|
 *	 | 30	 | Envelope C5			| 162 x 229 mm		|
 *	 | 31	 | Envelope C6			| 114 x 162 mm		|
 *	 | 32	 | Envelope C65			| 114 x 229 mm		|
 *	 | 33	 | Envelope B4			| 250 x 353 mm		|
 *	 | 34	 | Envelope B5			| 176 x 250 mm		|
 *	 | 35	 | Envelope B6			| 176 x 125 mm		|
 *	 | 36	 | Envelope				| 110 x 230 mm		|
 *	 | 37	 | Monarch				| 3.875 x 7.5 in	|
 *	 | 38	 | Envelope				| 3 5/8 x 6 1/2 in	|
 *	 | 39	 | Fanfold				| 14 7/8 x 11 in	|
 *	 | 40	 | German Std Fanfold	| 8 1/2 x 12 in		|
 *	 | 41	 | German Legal Fanfold | 8 1/2 x 13 in		|
 *
 */
public procedure worksheet_set_paper( atom worksheet, atom paper_type = 0 )
	c_proc( _worksheet_set_paper, {worksheet,paper_type} )
end procedure

/**
 * Set the worksheet margins (in inches) for the printed page.
 */
public procedure worksheet_set_margins( atom worksheet, atom left = -1, atom right = -1, atom top = -1, atom bottom = -1 )
	c_proc( _worksheet_set_margins, {worksheet,left,right,top,bottom} )
end procedure

/**
 * Set the printed page header caption with (optional) additional options.
 *
 *	 | Control		   | Category	   | Description		   |
 *	 | --------------- | ------------- | --------------------- |
 *	 | `&L`			   | Justification | Left				   |
 *	 | `&C`			   |			   | Center				   |
 *	 | `&R`			   |			   | Right				   |
 *	 | `&P`			   | Information   | Page number		   |
 *	 | `&N`			   |			   | Total number of pages |
 *	 | `&D`			   |			   | Date				   |
 *	 | `&T`			   |			   | Time				   |
 *	 | `&F`			   |			   | File name			   |
 *	 | `&A`			   |			   | Worksheet name		   |
 *	 | `&Z`			   |			   | Workbook path		   |
 *	 | `&fontsize`	   | Font		   | Font size			   |
 *	 | `&"font,style"` |			   | Font name and style   |
 *	 | `&U`			   |			   | Single underline	   |
 *	 | `&E`			   |			   | Double underline	   |
 *	 | `&S`			   |			   | Strikethrough		   |
 *	 | `&X`			   |			   | Superscript		   |
 *	 | `&Y`			   |			   | Subscript			   |
 */
public function worksheet_set_header( atom worksheet, object string, atom options = NULL )
	
	if sequence( string ) then string = allocate_string( string, 1 ) end if
	
	if options = NULL then
		return c_func( _worksheet_set_header, {worksheet,string} )
	else
		return c_func( _worksheet_set_header_opt, {worksheet,string,options} )
	end if
	
end function

/**
 * Set the printed page footer caption with (optional) additional options.
 */
public function worksheet_set_footer( atom worksheet, object string, atom options = NULL )
	
	if sequence( string ) then string = allocate_string( string, 1 ) end if
	
	if options = NULL then
		return c_func( _worksheet_set_footer, {worksheet,string} )
	else
		return c_func( _worksheet_set_footer_opt, {worksheet,string,options} )
	end if
	
end function

/**
 * Set the horizontal page breaks on a worksheet.
 */
public procedure worksheet_set_h_pagebreaks( atom worksheet, object breaks )
	if sequence( breaks ) then breaks = allocate_array4( breaks, 1 ) end if
	c_proc( _worksheet_set_h_pagebreaks, {worksheet,breaks} )
end procedure

/**
 * Set the vertical page breaks on a worksheet.
 */
public procedure worksheet_set_v_pagebreaks( atom worksheet, object breaks )
	if sequence( breaks ) then breaks = allocate_array4( breaks, 1 ) end if
	c_proc( _worksheet_set_v_pagebreaks, {worksheet,breaks} )
end procedure

/**
 * Set the order in which pages are printed.
 */
public procedure worksheet_print_across( atom worksheet )
	c_proc( _worksheet_print_across, {worksheet} )
end procedure

/**
 * Set the option to display or hide gridlines on the screen and the printed page.
 */
public procedure worksheet_gridlines( atom worksheet, atom option )
	c_proc( _worksheet_gridlines, {worksheet,option} )
end procedure

/**
 * Center the printed page horizontally.
 */
public procedure worksheet_center_horizontally( atom worksheet )
	c_proc( _worksheet_center_horizontally, {worksheet} )
end procedure

/**
 * Center the printed page vertically.
 */
public procedure worksheet_center_vertically( atom worksheet )
	c_proc( _worksheet_center_vertically, {worksheet} )
end procedure

/**
 * Set the option to print the row and column headers on the printed page.
 */
public procedure worksheet_print_row_col_headers( atom worksheet )
	c_proc( _worksheet_print_row_col_headers, {worksheet} )
end procedure

/**
 * Set the number of rows to repeat at the top of each printed page.
 */
public function worksheet_repeat_rows( atom worksheet, sequence rows )
	return c_func( _worksheet_repeat_rows, {worksheet,rows[1],rows[2]} )
end function

/**
 * Set the number of columns to repeat at the top of each printed page.
 */
public function worksheet_repeat_columns( atom worksheet, sequence cols )
	return c_func( _worksheet_repeat_columns, {worksheet,cols[1],cols[2]} )
end function

/**
 * Set the print area for a worksheet.
 */
public function worksheet_print_area( atom worksheet, sequence range )
	return c_func( _worksheet_print_area, {worksheet,range[1],range[2],range[3],range[4]} )
end function

/**
 * Fit the printed area to a specific number of pages both vertically and horizontally.
 */
public procedure worksheet_fit_to_pages( atom worksheet, atom width, atom height )
	c_proc( _worksheet_fit_to_pages, {worksheet,width,height} )
end procedure

/**
 * Set the start page number when printing.
 */
public procedure worksheet_set_start_page( atom worksheet, atom start_page )
	c_proc( _worksheet_set_start_page, {worksheet,start_page} )
end procedure

/**
 * Set the scale factor for the printed page.
 */
public procedure worksheet_set_print_scale( atom worksheet, atom scale )
	c_proc( _worksheet_set_print_scale, {worksheet,scale} )
end procedure

/**
 * Set the font used in the cell.
 */
public procedure format_set_font_name( atom format, object name )
	if sequence( name ) then name = allocate_string( name, 1 ) end if
	c_proc( _format_set_font_name, {format,name} )
end procedure

/**
 * Set the size of the font used in the cell.
 */
public procedure format_set_font_size( atom format, atom size )
	c_proc( _format_set_font_size, {format,size} )
end procedure

/**
 * Set the color of the font used in the cell.
 */
public procedure format_set_font_color( atom format, atom color )
	c_proc( _format_set_font_color, {format,color} )
end procedure

/**
 * Turn on bold for the format font.
 */
public procedure format_set_bold( atom format )
	c_proc( _format_set_bold, {format} )
end procedure

/**
 * Turn on italic for the format font.
 */
public procedure format_set_italic( atom format )
	c_proc( _format_set_italic, {format} )
end procedure

/**
 * Turn on underline for the format.
 *
 * The available underline styles are:
 * - LXW_UNDERLINE_SINGLE
 * - LXW_UNDERLINE_DOUBLE
 * - LXW_UNDERLINE_SINGLE_ACCOUNTING
 * - LXW_UNDERLINE_DOUBLE_ACCOUNTING
 */
public procedure format_set_underline( atom format, atom style )
	c_proc( _format_set_underline, {format,style} )
end procedure

/**
 * Set the strikeout property of the font.
 */
public procedure format_set_font_strikeout( atom format )
	c_proc( _format_set_font_strikeout, {format} )
end procedure

/**
 * Set the superscript/subscript property of the font.
 *
 * The available script styles are:
 * - LXW_FONT_SUPERSCRIPT
 * - LXW_FONT_SUBSCRIPT
 */
public procedure format_set_font_script( atom format, atom script )
	c_proc( _format_set_font_script, {format,script} )
end procedure

/**
 * Set the number format for a cell.
 */
public procedure format_set_num_format( atom format, object num_format )
	if sequence( num_format ) then num_format = allocate_string( num_format, 1 ) end if
	c_proc( _format_set_num_format, {format,num_format} )
end procedure

/**
 * Set the Excel built-in number format for a cell.
 *
 * The Excel built-in number formats as shown in the table below:
 *
 *	 | Index | Index | Format String										|
 *	 | ----- | ----- | ---------------------------------------------------- |
 *	 | 0	 | 0x00	 | `General`											|
 *	 | 1	 | 0x01	 | `0`													|
 *	 | 2	 | 0x02	 | `0.00`												|
 *	 | 3	 | 0x03	 | `#,##0`												|
 *	 | 4	 | 0x04	 | `#,##0.00`											|
 *	 | 5	 | 0x05	 | `($#,##0_);($#,##0)`									|
 *	 | 6	 | 0x06	 | `($#,##0_);[Red]($#,##0)`							|
 *	 | 7	 | 0x07	 | `($#,##0.00_);($#,##0.00)`							|
 *	 | 8	 | 0x08	 | `($#,##0.00_);[Red]($#,##0.00)`						|
 *	 | 9	 | 0x09	 | `0%`													|
 *	 | 10	 | 0x0a	 | `0.00%`												|
 *	 | 11	 | 0x0b	 | `0.00E+00`											|
 *	 | 12	 | 0x0c	 | `# ?/?`												|
 *	 | 13	 | 0x0d	 | `# ??/??`											|
 *	 | 14	 | 0x0e	 | `m/d/yy`												|
 *	 | 15	 | 0x0f	 | `d-mmm-yy`											|
 *	 | 16	 | 0x10	 | `d-mmm`												|
 *	 | 17	 | 0x11	 | `mmm-yy`												|
 *	 | 18	 | 0x12	 | `h:mm AM/PM`											|
 *	 | 19	 | 0x13	 | `h:mm:ss AM/PM`										|
 *	 | 20	 | 0x14	 | `h:mm`												|
 *	 | 21	 | 0x15	 | `h:mm:ss`											|
 *	 | 22	 | 0x16	 | `m/d/yy h:mm`										|
 *	 | ...	 | ...	 | ...													|
 *	 | 37	 | 0x25	 | `(#,##0_);(#,##0)`									|
 *	 | 38	 | 0x26	 | `(#,##0_);[Red](#,##0)`								|
 *	 | 39	 | 0x27	 | `(#,##0.00_);(#,##0.00)`								|
 *	 | 40	 | 0x28	 | `(#,##0.00_);[Red](#,##0.00)`						|
 *	 | 41	 | 0x29	 | `_(* #,##0_);_(* (#,##0);_(* "-"_);_(@_)`			|
 *	 | 42	 | 0x2a	 | `_($* #,##0_);_($* (#,##0);_($* "-"_);_(@_)`			|
 *	 | 43	 | 0x2b	 | `_(* #,##0.00_);_(* (#,##0.00);_(* "-"??_);_(@_)`	|
 *	 | 44	 | 0x2c	 | `_($* #,##0.00_);_($* (#,##0.00);_($* "-"??_);_(@_)` |
 *	 | 45	 | 0x2d	 | `mm:ss`												|
 *	 | 46	 | 0x2e	 | `[h]:mm:ss`											|
 *	 | 47	 | 0x2f	 | `mm:ss.0`											|
 *	 | 48	 | 0x30	 | `##0.0E+0`											|
 *	 | 49	 | 0x31	 | `@`													|
 *
 * Notes:
 *	-  Numeric formats 23 to 36 are not documented by Microsoft and may differ in international
 *	   versions. The listed date and currency formats may also vary depending on system settings.
 *
 *	- The dollar sign in the above format appears as the defined local currency symbol.
 *
 *	- These formats can also be set via format_set_num_format().
 */
public procedure format_set_num_format_index( atom format, atom index )
	c_proc( _format_set_num_format_index, {format,index} )
end procedure

/**
 * Set the cell unlocked state.
 */
public procedure format_set_unlocked( atom format )
	c_proc( _format_set_unlocked, {format} )
end procedure

/**
 * Hide formulas in a cell.
 */
public procedure format_set_hidden( atom format )
	c_proc( _format_set_hidden, {format} )
end procedure


/**
 * Set the alignment for data in the cell.
 *
 * The following are the available horizontal alignments:
 * - LXW_ALIGN_LEFT
 * - LXW_ALIGN_CENTER
 * - LXW_ALIGN_RIGHT
 * - LXW_ALIGN_FILL
 * - LXW_ALIGN_JUSTIFY
 * - LXW_ALIGN_CENTER_ACROSS
 * - LXW_ALIGN_DISTRIBUTED
 *
 * The following are the available vertical alignments:
 * - LXW_ALIGN_VERTICAL_TOP
 * - LXW_ALIGN_VERTICAL_BOTTOM
 * - LXW_ALIGN_VERTICAL_CENTER
 * - LXW_ALIGN_VERTICAL_JUSTIFY
 * - LXW_ALIGN_VERTICAL_DISTRIBUTED
 */
public procedure format_set_align( atom format, atom align )
	c_proc( _format_set_align, {format,align} )
end procedure

/**
 * Wrap text in a cell.
 */
public procedure format_set_text_wrap( atom format )
	c_proc( _format_set_text_wrap, {format} )
end procedure

/**
 * Set the rotation of the text in a cell.
 */
public procedure format_set_rotation( atom format, atom angle )
	c_proc( _format_set_rotation, {format,angle} )
end procedure

/**
 * Set the cell text indentation level.
 */
public procedure format_set_indent( atom format, atom indent )
	c_proc( _format_set_indent, {format,indent} )
end procedure


/**
 * Turn on the text "shrink to fit" for a cell.
 */
public procedure format_set_shrink( atom format )
	c_proc( _format_set_shrink, {format} )
end procedure

/**
 * Set the background fill pattern for a cell
 *
 *	 | Fill Type					 | Define						|
 *	 | ----------------------------- | ---------------------------- |
 *	 | Solid						 | LXW_PATTERN_SOLID			|
 *	 | Medium gray					 | LXW_PATTERN_MEDIUM_GRAY		|
 *	 | Dark gray					 | LXW_PATTERN_DARK_GRAY		|
 *	 | Light gray					 | LXW_PATTERN_LIGHT_GRAY		|
 *	 | Dark horizontal line			 | LXW_PATTERN_DARK_HORIZONTAL	|
 *	 | Dark vertical line			 | LXW_PATTERN_DARK_VERTICAL	|
 *	 | Dark diagonal stripe			 | LXW_PATTERN_DARK_DOWN		|
 *	 | Reverse dark diagonal stripe	 | LXW_PATTERN_DARK_UP			|
 *	 | Dark grid					 | LXW_PATTERN_DARK_GRID		|
 *	 | Dark trellis					 | LXW_PATTERN_DARK_TRELLIS		|
 *	 | Light horizontal line		 | LXW_PATTERN_LIGHT_HORIZONTAL |
 *	 | Light vertical line			 | LXW_PATTERN_LIGHT_VERTICAL	|
 *	 | Light diagonal stripe		 | LXW_PATTERN_LIGHT_DOWN		|
 *	 | Reverse light diagonal stripe | LXW_PATTERN_LIGHT_UP			|
 *	 | Light grid					 | LXW_PATTERN_LIGHT_GRID		| 
 *	 | Light trellis				 | LXW_PATTERN_LIGHT_TRELLIS	|
 *	 | 12.5% gray					 | LXW_PATTERN_GRAY_125			|
 *	 | 6.25% gray					 | LXW_PATTERN_GRAY_0625		|
 */
public procedure format_set_pattern( atom format, atom index )
	c_proc( _format_set_pattern, {format,index} )
end procedure

/**
 * Set the pattern background color for a cell.
 */
public procedure format_set_bg_color( atom format, atom color )
	c_proc( _format_set_bg_color, {format,color} )
end procedure

/**
 * Set the pattern foreground color for a cell.
 */
public procedure format_set_fg_color( atom format, atom color )
	c_proc( _format_set_fg_color, {format,color} )
end procedure

/**
 * Set the cell border style.
 *
 * The following border styles are available:
 * - LXW_BORDER_THIN
 * - LXW_BORDER_MEDIUM
 * - LXW_BORDER_DASHED
 * - LXW_BORDER_DOTTED
 * - LXW_BORDER_THICK
 * - LXW_BORDER_DOUBLE
 * - LXW_BORDER_HAIR
 * - LXW_BORDER_MEDIUM_DASHED
 * - LXW_BORDER_DASH_DOT
 * - LXW_BORDER_MEDIUM_DASH_DOT
 * - LXW_BORDER_DASH_DOT_DOT
 * - LXW_BORDER_MEDIUM_DASH_DOT_DOT
 * - LXW_BORDER_SLANT_DASH_DOT
 *
 * The 'style' can be a single atom for all borders, or a sequence 
 * of four values for each border, e.g. {left, top, right, bottom}.
 */
public procedure format_set_border( atom format, object style )
	
	if sequence( style ) then
		c_proc( _format_set_left,	{format,style[1]} )
		c_proc( _format_set_top,	{format,style[2]} )
		c_proc( _format_set_right,	{format,style[3]} )
		c_proc( _format_set_bottom, {format,style[4]} )
		
	else
		c_proc( _format_set_border, {format,style} )
		
	end if
	
end procedure

/**
 * Set the cell bottom border style.
 */
public procedure format_set_bottom( atom format, atom style )
	c_proc( _format_set_bottom, {format,style} )
end procedure

/**
 * Set the cell top border style.
 */
public procedure format_set_top( atom format, atom style )
	c_proc( _format_set_top, {format,style} )
end procedure

/**
 * Set the cell left border style.
 */
public procedure format_set_left( atom format, atom style )
	c_proc( _format_set_left, {format,style} )
end procedure

/**
 * Set the cell right border style.
 */
public procedure format_set_right( atom format, atom style )
	c_proc( _format_set_right, {format,style} )
end procedure

/**
 * Set the color of the cell border.
 *
 * The 'color' can be a single atom for all borders, or a sequence 
 * of four values for each border, e.g. {left, top, right, bottom}.
 */
public procedure format_set_border_color( atom format, object color )
	
	if sequence( color ) then
		c_proc( _format_set_left_color,	  {format,color[1]} )
		c_proc( _format_set_top_color,	  {format,color[2]} )
		c_proc( _format_set_right_color,  {format,color[3]} )
		c_proc( _format_set_bottom_color, {format,color[4]} )
		
	else
		c_proc( _format_set_border_color, {format,color} )
		
	end if
	
end procedure

/**
 * Set the color of the bottom cell border.
 */
public procedure format_set_bottom_color( atom format, atom color )
	c_proc( _format_set_bottom_color, {format,color} )
end procedure

/**
 * Set the color of the top cell border.
 */
public procedure format_set_top_color( atom format, atom color )
	c_proc( _format_set_top_color, {format,color} )
end procedure

/**
 * Set the color of the left cell border.
 */
public procedure format_set_left_color( atom format, atom color )
	c_proc( _format_set_left_color, {format,color} )
end procedure

/**
 * Set the color of the right cell border.
 */
public procedure format_set_right_color( atom format, atom color )
	c_proc( _format_set_right_color, {format,color} )
end procedure

public procedure format_set_diag_type( atom format, atom value )
	c_proc( _format_set_diag_type, {format,value} )
end procedure

public procedure format_set_diag_color( atom format, atom color )
	c_proc( _format_set_diag_color, {format,color} )
end procedure

public procedure format_set_diag_border( atom format, atom value )
	c_proc( _format_set_diag_border, {format,value} )
end procedure

public procedure format_set_font_outline( atom format )
	c_proc( _format_set_font_outline, {format} )
end procedure

public procedure format_set_font_shadow( atom format )
	c_proc( _format_set_font_shadow, {format} )
end procedure

public procedure format_set_font_family( atom format, atom value )
	c_proc( _format_set_font_family, {format,value} )
end procedure

public procedure format_set_font_charset( atom format, atom value )
	c_proc( _format_set_font_charset, {format,value} )
end procedure

public procedure format_set_font_scheme( atom format, object scheme )
	if sequence( scheme ) then scheme = allocate_string( scheme, 1 ) end if
	c_proc( _format_set_font_scheme, {format,scheme} )
end procedure

public procedure format_set_font_condense( atom format )
	c_proc( _format_set_font_condense, {format} )
end procedure

public procedure format_set_font_extend( atom format )
	c_proc( _format_set_font_extend, {format} )
end procedure

public procedure format_set_reading_order( atom format, atom value )
	c_proc( _format_set_reading_order, {format,value} )
end procedure

public procedure format_set_theme( atom format, atom value )
	c_proc( _format_set_theme, {format,value} )
end procedure

public function lxw_quote_sheetname( object str )
	if sequence( str ) then str = allocate_string( str, 1 ) end if
	atom ptr = c_func( _lxw_quote_sheetname, {str} )
	return peek_string( ptr )
end function

public function lxw_get_row( object row_str )
	if sequence( row_str ) then row_str = allocate_string( row_str, 1 ) end if
	return c_func( _lxw_get_row, {row_str} )
end function

public function lxw_get_col( object row_str )
	if sequence( row_str ) then row_str = allocate_string( row_str, 1 ) end if
	return c_func( _lxw_get_col, {row_str} )
end function

public function lxw_get_row_2( object row_str )
	if sequence( row_str ) then row_str = allocate_string( row_str, 1 ) end if
	return c_func( _lxw_get_row_2, {row_str} )
end function

public function lxw_get_col_2( object row_str )
	if sequence( row_str ) then row_str = allocate_string( row_str, 1 ) end if
	return c_func( _lxw_get_col_2, {row_str} )
end function

/**
 * Convert an Excel `A1` cell string into a `(row, col)` sequence.
 */
public function CELL( sequence cell )
	atom p_cell = allocate_string( cell, 1 )
	return { lxw_get_row(p_cell), lxw_get_col(p_cell) }
end function

/**
 * Convert an Excel `A:B` column range into a `(col1, col2)` sequence.
 */
public function COLS( sequence cols )
	atom p_cols = allocate_string( cols, 1 )
	return { lxw_get_col(p_cols), lxw_get_col_2(p_cols) }
end function

/**
 * Convert an Excel `A1:B2` range into a `(first_row, first_col, last_row, last_col)` sequence.
 */
public function RANGE( sequence range )
	atom p_range = allocate_string( range, 1 )
	return { lxw_get_row(range), lxw_get_col(range), lxw_get_row_2(range), lxw_get_col_2(range) }
end function

/**
 * Convert an Excel `A1:B2` range into a `(row1, row2)` sequence.
 */
public function ROWS( sequence rows )
	atom p_rows = allocate_string( rows, 1 )
	return { lxw_get_row(p_rows), lxw_get_row_2(p_rows) }
end function
