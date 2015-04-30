.align 32
SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0

.data
	ciag_wpisany: 
		.string ""
		.space 4096

ciag_wpisany_len: .word 4096

.data
	bufor:
		.string ""
		.space 16384
			
bufor_len: .word 16384

.data
	hex:
		.string ""
		.space 4096
		
hex_len: .word 4096

.text

.global main
main:
	mov $SYSREAD, %eax 
	mov $STDIN, %ebx 
	mov $ciag_wpisany, %ecx 
	mov $ciag_wpisany_len, %edx 
	int $0x80
	
	mov $(-1),%ebx					/*ustawiam licznik na -1*/
_ileWpisano:
	inc %ebx						/*inkrementuje licznik*/
	movb ciag_wpisany(%ebx),%al		/*kopiuje aktualny znak*/
	cmp $10,%eax					/*sprawdzam czy jest to znak nowej linii*/
	jne _ileWpisano					/*jezeli to nie znak nowej linii to iteruj dalej*/
	
	/*znam dlugosc wpisanego slowa dlatego ustawiam dlugosci poszczegolnych stringow*/
	
	mov %ebx,ciag_wpisany_len		/*zmieniam dlugosc ciagu wpisanego*/
	mov %ebx,hex_len				/*zmieniam dlugosc slowa szesnastkowego*/
	shl $2,%ebx						
	mov %ebx,bufor_len				/*ustawiam dlugosc slowa binarnego*/
	
	
_wypisz:
	mov $SYSWRITE, %eax 
	mov $STDOUT, %ebx 
	mov ciag_wpisany_len, %ecx 
	mov ciag_wpisany_len, %edx 
	
	int $0x80	

	mov $SYSEXIT, %eax 
	mov $EXIT_SUCCESS, %ebx
	
	int $0x80	
