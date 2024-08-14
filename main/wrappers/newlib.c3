module newlib;
// based on std::libc
// https://github.com/c3lang/c3c/blob/master/lib/std/libc/libc.c3

// Constants need to be per os/arch
const int EXIT_FAILURE = 1;
const int EXIT_SUCCESS = 0;

distinct ZString = inline char*;
def CFile = void*;
const C_INT_SIZE = $$C_INT_SIZE;
const C_LONG_SIZE = $$C_LONG_SIZE;
const C_SHORT_SIZE = $$C_SHORT_SIZE;
const C_LONG_LONG_SIZE = $$C_LONG_LONG_SIZE;

$assert C_SHORT_SIZE < 32;
$assert C_INT_SIZE < 128;
$assert C_LONG_SIZE < 128;
$assert C_LONG_LONG_SIZE <= 128;
$assert C_SHORT_SIZE <= C_INT_SIZE;
$assert C_INT_SIZE <= C_LONG_SIZE;
$assert C_LONG_SIZE <= C_LONG_LONG_SIZE;

def CShort = $typefrom(signed_int_from_bitsize($$C_SHORT_SIZE));
def CUShort = $typefrom(unsigned_int_from_bitsize($$C_SHORT_SIZE));
def CInt = $typefrom(signed_int_from_bitsize($$C_INT_SIZE));
def CUInt = $typefrom(unsigned_int_from_bitsize($$C_INT_SIZE));
def CLong = $typefrom(signed_int_from_bitsize($$C_LONG_SIZE));
def CULong = $typefrom(unsigned_int_from_bitsize($$C_LONG_SIZE));
def CLongLong = $typefrom(signed_int_from_bitsize($$C_LONG_LONG_SIZE));
def CULongLong = $typefrom(unsigned_int_from_bitsize($$C_LONG_LONG_SIZE));
def CSChar = ichar;
def CUChar = char;

def CChar = $typefrom($$C_CHAR_IS_SIGNED ? ichar.typeid : char.typeid);

// Helper macros
macro typeid signed_int_from_bitsize(usz $bitsize) @private
{
	$switch ($bitsize)
		$case 128: return int128.typeid;
		$case 64: return long.typeid;
		$case 32: return int.typeid;
		$case 16: return short.typeid;
		$case 8: return ichar.typeid;
		$default: $error("Invalid bitsize");
	$endswitch
}

macro typeid unsigned_int_from_bitsize(usz $bitsize) @private
{
	$switch ($bitsize)
		$case 128: return uint128.typeid;
		$case 64: return ulong.typeid;
		$case 32: return uint.typeid;
		$case 16: return ushort.typeid;
		$case 8: return char.typeid;
		$default: $error("Invalid bitsize");
	$endswitch
}

extern fn double atof(char* str);
extern fn int atoi(char* str);
extern fn void* calloc(usz count, usz size);
extern fn void clearerr(CFile stream);
extern fn void exit(CInt status);
extern fn CInt fclose(CFile stream);
extern fn CInt feof(CFile stream);
extern fn CInt ferror(CFile stream);
extern fn CInt fflush(CFile stream);
extern fn CInt fgetc(CFile stream);
extern fn ZString fgets(char* string, CInt n, CFile stream);
extern fn CFile fopen(ZString filename, ZString mode);
extern fn CInt fprintf(CFile stream, ZString format, ...);
extern fn CInt fputc(CInt c, CFile stream);
extern fn CInt fputs(ZString string, CFile stream);
extern fn usz fread(void* ptr, usz size, usz nmemb, CFile stream);
extern fn void* free(void*);
extern fn CFile freopen(ZString filename, ZString mode, CFile stream);
extern fn CInt fscanf(CFile stream, ZString format, ...);
extern fn usz fwrite(void* ptr, usz size, usz nmemb, CFile stream);
extern fn CInt getc(CFile stream);
extern fn CInt getchar();
extern fn ZString getenv(ZString name);
extern fn ZString gets(char* buffer);
extern fn CLong labs(CLong x);
extern fn void* malloc(usz size);
extern fn void* memchr(void* str, CInt c, usz n);
extern fn CInt memcmp(void* buf1, void* buf2, usz count);
extern fn void* memcpy(void* dest, void* src, usz n);
extern fn void* memmove(void* dest, void* src, usz n);
extern fn void* memset(void* dest, CInt value, usz n);
extern fn void perror(ZString string);
extern fn CInt printf(ZString format, ...);
extern fn CInt putc(CInt c, CFile stream);
extern fn CInt putchar(CInt c);
extern fn CInt puts(ZString str);
extern fn CInt raise(CInt signal);
extern fn CInt rand();
extern fn void* realloc(void* ptr, usz size);
extern fn CInt remove(ZString filename);
extern fn CInt rename(ZString old_name, ZString new_name);
extern fn void rewind(CFile stream);
extern fn CInt scanf(ZString format, ...);
extern fn void setbuf(CFile stream, char* buffer);
extern fn int setenv(ZString name, ZString value, CInt overwrite);
extern fn void setvbuf(CFile stream, char* buf, CInt type, usz size);
extern fn CInt snprintf(char* buffer, usz size, ZString format, ...);
extern fn CInt sprintf(char* buffer, ZString format, ...);
extern fn void srand(uint seed);
extern fn CInt sscanf(char* buffer, ZString format, ...);
extern fn ZString strcat(ZString dest, ZString src);
extern fn char* strchr(char* str, CInt c);
extern fn CInt strcmp(ZString str1, ZString str2);
extern fn CInt strcoll(ZString str1, ZString str2);
extern fn usz strcspn(ZString str1, ZString str2);
extern fn ZString strcpy(ZString dst, ZString src);
extern fn ZString strerror(CInt errn);
extern fn usz strlen(ZString str);
extern fn ZString strncat(char* dest, char* src, usz n);
extern fn CInt strncmp(char* str1, char* str2, usz n);
extern fn char* strncpy(char* dst, char* src, usz n);
extern fn CULong stroul(char* str, char** endptr, int base);
extern fn char* strpbrk(ZString str1, ZString str2);
extern fn usz strspn(ZString str1, ZString str2);
extern fn char* strrchr(ZString str, CInt c);
extern fn char* strstr(ZString haystack, ZString needle);
extern fn double strtod(char* str, char** endptr);
extern fn float strtof(char* str, char** endptr);
extern fn ZString strtok(ZString str, ZString delim);
extern fn CLong strtol(char* str, char** endptr, CInt base);
extern fn CULong strtul(char* str, char** endptr, CInt base);
extern fn usz strxfrm(char* dest, ZString src, usz n);
extern fn CInt system(ZString str);
extern fn ZString tmpnam(ZString str);
extern fn CInt ungetc(CInt c, CFile stream);
extern fn CInt unsetenv(ZString name);

extern fn CFile fmemopen(void* ptr, usz size, ZString mode);
extern fn isz getline(char** linep, usz* linecapp, CFile stream);
