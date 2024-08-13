import newlib;
import idf;

fn void main() @export("app_main")
{
	newlib::printf("Hello, world from C3!\nIDF version: %s\n", idf::esp_get_idf_version());
	
	defer idf::heap_caps_dump_all();
	
	newlib::printf("Malloc test:\n");
	void* ptr = idf::heap_caps_malloc(100, idf::MALLOC_CAP_DEFAULT);
	newlib::printf("Allocated 100 bytes at %p\n", ptr);
	idf::heap_caps_free(ptr);
	newlib::printf("Freeing memory...\n");

	newlib::printf("Malloc dump all\n");

	if(idf::xTaskCreate(&taskSample, "taskSample", 10000, null, 1, null) != idf::ESP_OK){
		// TODO: Handle error
		newlib::printf("TaskSample cannot be run!!\n");
	}
}

fn void taskSample(void* arg) @export("taskSample") {
	newlib::printf("TaskSample started\n");
	while(true){
		newlib::printf("TaskSample running, %d\n", counter);
		idf::vTaskDelay(1000 / idf::TICK_PERIOD_MS);
		counter++;
	}
}

int counter = 0;