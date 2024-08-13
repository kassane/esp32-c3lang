module idf;

def Esp_err_t = int;
def Caps = isz;

// Error codes
const Esp_err_t ESP_OK = 0;
const Esp_err_t ESP_FAIL = -1;
const Esp_err_t ESP_ERR_NO_MEM = 0x101;
const Esp_err_t ESP_ERR_INVALID_ARG = 0x102;
const Esp_err_t ESP_ERR_INVALID_STATE = 0x103;
const Esp_err_t ESP_ERR_INVALID_SIZE = 0x104;
const Esp_err_t ESP_ERR_NOT_FOUND = 0x105;
const Esp_err_t ESP_ERR_NOT_SUPPORTED = 0x106;
const Esp_err_t ESP_ERR_TIMEOUT = 0x107;
const Esp_err_t ESP_ERR_INVALID_RESPONSE = 0x108;
const Esp_err_t ESP_ERR_INVALID_CRC = 0x109;
const Esp_err_t ESP_ERR_INVALID_VERSION = 0x10A;
const Esp_err_t ESP_ERR_INVALID_MAC = 0x10B;
const Esp_err_t ESP_ERR_NOT_FINISHED = 0x10C;
const Esp_err_t ESP_ERR_NOT_ALLOWED = 0x10D;
const Esp_err_t ESP_ERR_WIFI_BASE = 0x3000;
const Esp_err_t ESP_ERR_MESH_BASE = 0x4000;
const Esp_err_t ESP_ERR_FLASH_BASE = 0x6000;
const Esp_err_t ESP_ERR_HW_CRYPTO_BASE = 0xc000;
const Esp_err_t ESP_ERR_MEMPROT_BASE = 0xd000;

const Caps MALLOC_CAP_EXEC = (1 << 0);          //< Memory must be able to run executable code
const Caps MALLOC_CAP_32BIT = (1 << 1);         //< Memory must allow for aligned 32-bit data accesses
const Caps MALLOC_CAP_8BIT = (1 << 2);          //< Memory must allow for 8/16/...-bit data accesses
const Caps MALLOC_CAP_DMA = (1 << 3);           //< Memory must be able to accessed by DMA
const Caps MALLOC_CAP_PID2 = (1 << 4);          //< Memory must be mapped to PID2 memory space (PIDs are not currently used)
const Caps MALLOC_CAP_PID3 = (1 << 5);          //< Memory must be mapped to PID3 memory space (PIDs are not currently used)
const Caps MALLOC_CAP_PID4 = (1 << 6);          //< Memory must be mapped to PID4 memory space (PIDs are not currently used)
const Caps MALLOC_CAP_PID5 = (1 << 7);          //< Memory must be mapped to PID5 memory space (PIDs are not currently used)
const Caps MALLOC_CAP_PID6 = (1 << 8);          //< Memory must be mapped to PID6 memory space (PIDs are not currently used)
const Caps MALLOC_CAP_PID7 = (1 << 9);          //< Memory must be mapped to PID7 memory space (PIDs are not currently used)
const Caps MALLOC_CAP_SPIRAM = (1 << 10);       //< Memory must be in SPI RAM
const Caps MALLOC_CAP_INTERNAL = (1 << 11);     //< Memory must be internal; specifically it should not disappear when flash/spiram cache is switched off
const Caps MALLOC_CAP_DEFAULT = (1 << 12);      //< Memory can be returned in a non-capability-specific memory allocation (e.g. malloc(), calloc()) call
const Caps MALLOC_CAP_IRAM_8BIT = (1 << 13);    //< Memory must be in IRAM and allow unaligned access
const Caps MALLOC_CAP_RETENTION = (1 << 14);    //< Memory must be able to accessed by retention DMA
const Caps MALLOC_CAP_RTCRAM = (1 << 15);       //< Memory must be in RTC fast memory
const Caps MALLOC_CAP_TCM = (1 << 16);          //< Memory must be in TCM memory
const Caps MALLOC_CAP_INVALID = (1 << 31);      //< Memory can't be used / list end marker

// Functions
extern fn char* esp_err_to_name(Esp_err_t err_code);
extern fn char* esp_err_to_name_r(Esp_err_t err_code, char* buf, usz buflen);
extern fn void _esp_error_check_failed(Esp_err_t err_code, char* file, int line, char* function, char* expression);
extern fn void _esp_error_check_failed_without_abort(Esp_err_t err_code, char* file, int line, char* function, char* expression);
extern fn char* esp_get_idf_version();

extern fn void* heap_caps_malloc(usz size, uint caps);
extern fn void heap_caps_free(void* ptr);
extern fn void* heap_caps_realloc(void* ptr, usz size, uint caps);
extern fn void* heap_caps_aligned_alloc(usz alignment, usz size, uint caps);
extern fn void heap_caps_aligned_free(void* ptr);
extern fn void* heap_caps_aligned_calloc(usz alignment, usz n, usz size, uint caps);
extern fn void* heap_caps_calloc(usz n, usz size, uint caps);
extern fn usz heap_caps_get_total_size(uint caps);
extern fn usz heap_caps_get_free_size(uint caps);
extern fn usz heap_caps_get_minimum_free_size(uint caps);
extern fn usz heap_caps_get_largest_free_block(uint caps);
extern fn Esp_err_t heap_caps_monitor_local_minimum_free_size_start();
extern fn Esp_err_t heap_caps_monitor_local_minimum_free_size_stop();
extern fn void heap_caps_dump(Caps caps);
extern fn void heap_caps_dump_all();
extern fn usz heap_caps_get_allocated_size(void* ptr);