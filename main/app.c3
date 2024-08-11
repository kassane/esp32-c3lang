extern fn int printf(char* format, ...);

fn void app_main() @export("app_main")
{
	printf("Hello, world from C3!\n");
}
