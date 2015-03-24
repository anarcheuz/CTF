#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>

/* The only way to design a good sandbox is using a blacklist!
 *
 * The flag is NOT flag.txt, flag, key, key.txt etc...
 */

#define BLACKLIST_SYSCALLS \
	X(read)       \
	X(open)       \
	X(close)      \
	X(mmap)       \
	X(mprotect)   \
	X(munmap)     \
	X(ioctl)      \
	X(pread64)    \
	X(preadv)     \
	X(readv)      \
	X(dup)        \
	X(dup2)       \
	X(clone)      \
	X(fork)       \
	X(execve)     \
	X(fcntl)      \
	X(ptrace)     \
	X(prctl)      \
	X(chroot)

#define X(name)   SCMP_SYS(name),

#define MAX_SHELLCODE_SIZE    0x100

void error(char *msg)
{
	perror(msg);
	exit(1);
}

int main(void)
{
	char shellcode[MAX_SHELLCODE_SIZE + 1];
	char *map;
	int rc;

	map = mmap(NULL, 0x1000, PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

	if (map == MAP_FAILED) {
		error("mmap");
	}

	bzero(map, 0x1000);

	rc = read(0, shellcode, MAX_SHELLCODE_SIZE);
	strncpy(map, shellcode, rc);

	if (mprotect(map, 0x1000, PROT_READ | PROT_EXEC)) {
		error("mprotect");
	}

	((void (*)())map)();

	return 0;
}
