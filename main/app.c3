
extern fn int printf(char* format, ...);

fn void app_main() @export("app_main")
{
	printf("Hello World C3 language!\n");
}
