#include <multiboot.h>
#include <sys/types.h>

static void do_graphics(struct multiboot *mboot);
static void do_text(struct multiboot *mboot);

int
kmain_multiboot(struct multiboot *mboot, u32 mboot_magic)
{
#if 0
	if (mboot_magic != 0x2badb002)
		return 1; // ERROR!
#endif

	if (mboot->framebuffer_type == 1 || mboot->framebuffer_type == 0)
		do_graphics(mboot);
	else if (mboot->framebuffer_type == 2)
		do_text(mboot);
	else
		return 1; // ERROR!

	return 0;
}

static void
do_graphics(struct multiboot *mboot)
{
	unsigned *pixels = (void *)mboot->framebuffer_addr;
	const unsigned width = mboot->framebuffer_width ? : 640;
	const unsigned height = mboot->framebuffer_height ? : 480;
	unsigned x, y;

	// fill the screen with green (BUG! doesn't work!)
	for (y = 0; y < height; y++) {
		for (x = 0; x < width; x++) {
			pixels[x] = 0x00ff00;
		}
		pixels = (void*)((char*)pixels + (width * 4));
	}
}

static void
do_text(struct multiboot *mboot)
{
	unsigned short *screen;

	if (mboot->framebuffer_addr)
		screen = (void*)mboot->framebuffer_addr;
	else
		screen = (void*)0xb8000; // FALLBACK

	const unsigned char msg[] = "Hello World!";
	unsigned i;
	unsigned width = mboot->framebuffer_width ? : 80;
	unsigned height = mboot->framebuffer_height ? : 25;
	unsigned pitch = mboot->framebuffer_pitch ? : width * 2;
	unsigned x = 0, y = 0;

	unsigned short *p = screen;
	for (i = 0; msg[i]; i++) {
		if (x >= width) {
			x = 0;
			y++;
			p = (unsigned short*)((char*)p + pitch);
		}

		if (y >= height) {
			p = screen;
			y = 0;
			x = 0;
		}

		p[x] = msg[i] | 0x1e00;

		x++;
	}
}
