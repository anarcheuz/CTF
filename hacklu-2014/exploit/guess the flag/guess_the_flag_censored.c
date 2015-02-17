// challenge: guess the flag! :D
// (actually, please DON'T just try to bruteforce it)

// compile with `gcc -o guess_the_flag guess_the_flag.c -std=gnu99 -g`

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdint.h>
#include <sys/stat.h>
#include <fcntl.h>

int is_flag_correct(char *flag_hex /* the user's guess in hex */) {
  if (strlen(flag_hex) != 100) {
    printf("bad input, that hexstring should be 100 chars, but was %d chars long!\n", (int)strlen(flag_hex));
    exit(0);
  }

  char bin_by_hex[256] = { /* table for looking up the value of a hex character – -1 means invalid */
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
     0,  1,  2,  3,  4,  5,  6,  7,  8,  9, -1, -1, -1, -1, -1, -1, /* 0-9 */
    -1, 10, 11, 12, 13, 14, 15, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* A-F */
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, 10, 11, 12, 13, 14, 15, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* a-f */
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
  };

  /* the correct flag was censored out */
  char flag[50] = "flag{0123456789abcdef0123456789abcdef0123456789ab}";

  // decode flag_hex into given_flag so we can compare them
  char given_flag[50];
  bzero(given_flag, 50);
  for (int i=0; i<50; i++) {
    char value1 = bin_by_hex[flag_hex[i*2  ]];
    char value2 = bin_by_hex[flag_hex[i*2+1]];
    if (value1 == -1 || value2 == -1) {
      printf("bad input – one of the characters you supplied was not a valid hex character!\n");
      exit(0);
    }
    given_flag[i] = (value1<<4) | value2;
  }

  // timing-safe comparison of the two flags
  char diff = 0;
  for (int i=0; i<50; i++) {
    diff |= (flag[i] ^ given_flag[i]);
  }

  return (diff == 0);
}

void rtrim(char *str) {
  for (char *p = str+strlen(str)-1; p>=str; p--) {
    if (!strchr(" \r\n", *p)) break;
    *p = '\0';
    p--;
  }
}

void handle(int s) {
  alarm(120);

  // Let's handle the socket like a normal terminal or so. Makes the code much
  // nicer. :)
  if (dup2(s, 0)==-1 || dup2(s, 1)==-1) exit(1);
  setbuf(stdout, NULL);

  printf("Welcome to the super-secret flag guess validation service!\n"
         "Unfortunately, it only works for the flag for this challenge though.\n"
         "The correct flag is 50 characters long, begins with `flag{` and\n"
         "ends with `}` (without the quotes). All characters in the flag\n"
         "are lowercase hex (so they are in [0-9a-f]).\n"
         "\n"
         "Before you can submit your flag guess, you have to encode the\n"
         "whole guess with hex again (including the `flag{` and the `}`).\n"
         "This protects the flag from corruption through network nodes that\n"
         "can't handle non-hex traffic properly, just like in email.\n"
         "\n");
  while (1) {
    printf("guess> ");
    char inbuf[4096];
    if (fgets(inbuf, 4096, stdin) == NULL) return;
    rtrim(inbuf);
    int correct = is_flag_correct(inbuf);
    if (correct) {
      printf("Yaaaay! You guessed the flag correctly! But do you still remember what you entered? If not, feel free to try again!\n");
    } else {
      printf("Nope.\n");
    }
  }
}

int main(void) {
  int s = socket(AF_INET6, SOCK_STREAM, 0);
  if (s == -1) perror("unable to create server socket"), exit(1);
  struct sockaddr_in6 bind_addr = {
    .sin6_family = AF_INET6,
    .sin6_port = htons(1412)
  };
  if (bind(s, (struct sockaddr *)&bind_addr, sizeof(bind_addr))) perror("unable to bind socket"), exit(1);
  if (listen(s, 0x10)) perror("deaf"), exit(1);

  while (1) {
    int s_ = accept(s, NULL, NULL);
    if (s_ == -1) {
      perror("accept failed, is this bad?"); /* On Error Resume Next */
      continue;
    }
    pid_t child_pid = fork();
    if (child_pid == -1) {
      perror("can't fork! that's bad, I think.");
      close(s_);
      sleep(1);
      continue;
    }
    if (child_pid == 0) close(s), handle(s_), exit(0);
    close(s_);
  }
}
