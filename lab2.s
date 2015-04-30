.align 32
SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0

.data
	ciag_wpisany: 
	//.string "0000"
	.space 4096
	.ascii ""
	.set ciag_wpisany_len,5
.data
	bufor:
	.string "000000000000000000000"
	.space 4096
	.ascii ""	
	.set bufor_len,16
.data
	hex: 
	//.string ""
	.ascii ""
	.set hex_len,4
	//.comm ciag_wpisany_len,5
	//.comm bufor_len, 16
	//.comm hex_len,4
.text

.global main
main:
	mov $SYSREAD, %eax 
	mov $STDIN, %ebx 
	mov $ciag_wpisany, %ecx 
	mov $ciag_wpisany_len, %edx 
	int $0x80
	//wczytano liczbe
	mov $(-1),%edx			#licznik
_loop:
	inc %edx			#inkrementuje licznik
	movb ciag_wpisany(%edx),%al	#pobieram aktualna liczbe
	//cmp $0xA,%al			#jezeli jest to enter to koncze
	cmp $3,%edx
	je _zamienNaHex			
	sub $0x30, %eax			#jezeli to nie eneter to odejmuje '0'
_zamiana:
	mov $1, %ecx			#sprawdzam kolejne bajty i zapisuje w formie binarnej do bufora
	and %eax,%ecx
	mov $3,%ebx
	movb %cl,bufor(%ebx,%edx,4)
	mov $2,%ecx
	and %eax,%ecx
	cmp $0,%ecx
	je _nierowne2
	mov $1,%cl
	jmp _kontynuacja2
_nierowne2:
	mov $0,%cl
_kontynuacja2:
	dec %ebx
	movb %cl,bufor(%ebx,%edx,4)
	mov $4,%ecx
	and %eax,%ecx
	cmp $0,%ecx
	je _nierowne4
	mov $1,%cl
	jmp _kontynuacja4
_nierowne4:
	mov $0,%cl
_kontynuacja4:
	dec %ebx
	movb %cl,bufor(%ebx,%edx,4)
	mov $8,%ecx
	and %eax,%ecx
	cmp $0,%cl
	je _nierowne8
	mov $1,%cl
	jmp _kontynuacja8
_nierowne8:
	mov $0 , %cl
_kontynuacja8:
	movb %cl,bufor(,%edx,4)
	jmp _loop
	
/*_pomnoz:
	mov $(-1),%edx
_petlaMnozenia:
	inc %edx
	cmp %edx,bufor_len
	je _zamienNaHex
	mov $1,%ebx
	movb bufor(%ebx,%edx,),%al
	movb %al,bufor(%ebx,%edx,)
	jmp _petlaMnozenia
*/
_zamienNaHex:
	//wczytuje pierwsza liczbe
	


	movb bufor,%al
	shl $3,%al
	mov %al,%bl
	mov $1,%ecx
	movb bufor(%ecx),%al
	shl $2,%al
	add %al,%bl
	inc %ecx
	movb bufor(%ecx),%al
	shl $1,%al
	add %al,%bl
	inc %ecx
	movb bufor(%ecx),%al
	add %al,%bl
	mov $0,%ecx
_wczytajLiczbe:
	inc %ecx
	cmp $3,%ecx 
	je _konczDzialania
	//wczytaj kolejna liczbe
	
	movb bufor(,%ecx,4),%al
	shl $3,%al
	mov %al,%dl
	mov $1,%ebp
	movb bufor(%ebp,%ecx,4),%al
	shl $2,%al
	add %al,%dl
	inc %ebp
	movb bufor(%ebp,%ecx,4),%al
	shl $1,%al
	add %al,%dl
	inc %ebp
	movb bufor(%ebp,%ecx),%al
	add %al,%dl
	






/*	movb bufor(%ecx),%al
	mov $8,%ax
	mul %ax
	mov %al,%dl
	mov $1,%ebp
	movb bufor(%ebp,%ecx),%al
	mov $4,%ax
	mul %ax
	add %al,%dl
	inc %ebp
	movb bufor(%ebp,%ecx,),%al
	mov $4,%ax
	mul %al
	add %al,%dl
	inc %ebp
	movb bufor(%ebp,%ecx,),%al
	add %al,%dl
*/	//%ebx starsza liczba
	//%edx mlodsza liczba
_wykonajDzialania:
	movb %bl,%al
	mov %edx,%ebx
	mov $10,%ebp
	mul %ebp
	add %bl,%al
	mov $16,%ebp
	div %ebp
	dec %ecx
	movb %dl,hex(%ecx)
	inc %ecx
	mov %al,%bl
	jmp _wczytajLiczbe
_konczDzialania:
	movb %ah,hex(%ecx)	
	

	
	
	

		





/*
_zamianaNaBinarny:
	mov %eax,%ebx			#kopiuje wartosc do innego rejestru	
	and $1,%ebx			#sprawdzam reszte

	mov $(-1),%edx	#kopiuje numer ostatniego indeksu w pobranej tablicy
	mov $(-1),%ebx 			#wstawiam aktualny indeks buforu
	mov $0,%eax			#poprzednia wartosc mnozenia
_loop:
	inc %edx			#dekrementuje ostatni indeks
	movb ciag_wpisany(%edx),%cl	#przesuwam bajt do rejestru
	cmp $0xA , %ecx			#sprawdzam czy nie jest enterem	
	je _koniec	
	ljmp sprawdzCzyCyfra
	sub $0x30,%ecx			#od znaku odejmuje '0'
	mov $0xA,%edi	
	mul %edi			#mnoze razy 10
	add %ecx,%eax			#dodaje aktualna pobrana cyfre
	jmp _loop
_koniec:
	mov %eax,%ecx
	mov $SYSWRITE, %eax 
	mov $STDOUT, %ebx 
	#mov $bufor, %ecx 
	mov $bufor_len, %edx 
	
	int $0x80	

_zamianaNaBinarny:
	inc %ebx
	cmp $0x00,%eax			#czy zostalo nam zero jak tak to konczymy
	je _koniec
	shr %eax			#przesuwam w praw,
	jc _zostalaJedynka		#jesli zostala na jedynka to ja dodajemy do bufora
	movb $0x30,bufor(%ebx)
	jmp _zamianaNaBinarny

_zostalaJedynka:
	movb $0x31,bufor(%ebx)
	jmp _zamianaNaBinarny

*/
_koniec:
	mov $(-1),%ecx
_dodajASCII:
	inc %ecx
	cmp $2,%ecx
	je _wypisz  
	movb hex(%ecx), %al
	cmp $10,%al
	jae _litera
	add $0x30,%al
	movb %al,hex(%ecx)
	jmp _dodajASCII	
_litera:
	sub $10,%al
	add $0x41,%al
	movb %al,hex(%ecx)
	jmp _dodajASCII

_wypisz:
	mov $SYSWRITE, %eax 
	mov $STDOUT, %ebx 
	mov $hex, %ecx 
	mov $hex_len, %edx 
	
	int $0x80	

	mov $SYSEXIT, %eax 
	mov $EXIT_SUCCESS, %ebx
	
	int $0x80	
