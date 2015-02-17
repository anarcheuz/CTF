
int main()
{
    code[];
    read(stdin, &n, 4);
    if(n > 1000)
        exit(0);
    for(i=0; n*16 > i; i+=len)
        len = read(stdin, &input+i, 16*n-i);
    for(j=0; j < n; j++)
        sha1(j*16+input, 16, &code+j*20);
    memset(&input, -1, 1000);
    code();
}
