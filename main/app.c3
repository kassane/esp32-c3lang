import newlib;
import idf;

fn void main() @export("app_main")
{
	newlib::printf("Hello, world from C3!\nIDF version: %s\n", idf::esp_get_idf_version());
	
	defer idf::heap_caps_dump_all();
	
	newlib::printf("Malloc test:\n");
	void* ptr = idf::heap_caps_malloc(100, idf::MALLOC_CAP_DMA);
	newlib::printf("Allocated 100 bytes at %p\n", ptr);
	idf::heap_caps_free(ptr);
	newlib::printf("Freeing memory...\n");
	
	newlib::printf("Malloc dump all\n");
}
