#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>


struct Par{  //Estructura para manejar un buffer junto con su tamaño
	int lsize; //.size o .lenght
	unsigned char* str; //Cadena
};

/**
*Escribe un archivo en una cadena.
*@param file - nombre del archivo a leer
*@returns par con la longitud del archivo y la cadena con el archivo completo.
*/
struct Par leer(char* file);

/**
*Realiza una llamada al sistema.
*@param cod - apuntador al codigo de la llamada.
*@param arg - apuntador al argumento de la llamada.
*@param mem - memoria del la maquina.
*@param m - longitud de mem.
*@returns apuntador al resultado de la llamada.
*/
char syscall(unsigned char *mem, int m, int *regs);

/**
*Funcion que simula el funcionamiento del ALU
*/
int ALU(int src1, int src2, unsigned char opCode); //recibe dos enteros o el conteniudo de dos registros y un opCode para saber qué hacer

int ADD(int a, int b);
int SUB(int a, int b);
int MUL(int a, int b);
int DIV(int a, int b);
int FADD(int a, int b);
int FSUB(int a, int b);
int FMUL(int a, int b);
int FDIV(int a, int b);
int AND(int a, int b);
int OR(int a, int b);
int XOR(int a, int b);

int tam(char* str);//Regresa el tamaño de una cadena

int main(int argc, char **argv){
	int mem; //tamaño de la memoria
	char* file; //nombre del archivo
	int PC = 0; //Program Counter que indica en qué posicion del archivo vas
	int NPC; //New Program Counter
	int TIME = 0; //tiempo total en ciclos virtuales
	char EXIT_CODE; //Codigo de finalización del programa. Si es 0 estuvo bien, si es otro hubo un error
	//leer los argumentos
	mem = atoi(argv[2]); //atoi=parseint tamaño de la memoria
	file = argv[3]; //nombre del archivo
	//
	struct Par prg = leer(file); //Se lee el archivo y en org están todas las instrucciones y el tamaño
	if(prg.str == NULL){ 
		printf("Error leyendo el archivo %s\n", file);     //Se comprueba que se leyó bien
		exit(0);
	}
	if(prg.lsize > mem){
		exit(3);          //Comprobar que el ptrograma quepa en la memoria
	}
	//printf("Y\n");
	unsigned char* MEM = calloc(sizeof(unsigned char), mem + 1); //reserva y limpia memoria con calloc
	MEM[mem] = '\0'; //la ultima posicion de la memoria es nula para evitar problemas de lectura inválida
	int* REGS = calloc(sizeof(int), 14); //reserva 14 espacios para los registros con calloc
	REGS[13]=mem-1;
	//cargar el programa en la memoria
	//printf("cargar el programa en la memoria\n");
	memcpy(MEM, prg.str, prg.lsize); //Se copia el programa en la memoria

	unsigned char opCode;  //declaraciones
	unsigned char regDst;
	unsigned char regSrc1;
	unsigned char regSrc2;
	unsigned char aux1;
	unsigned char aux2;
	//long inst;
	*(REGS+13) = mem-1;//el sp empieza apuntando al final de la memoria.
	//printf("Inicia la ejecucion\n");
	int i = 0;
	
	while(1){ //para que ejecute indefinidamente
		
		if(*(REGS +13) < prg.lsize){
			EXIT_CODE = 3;
			break;
		}
		if(PC >= prg.lsize-3){
			EXIT_CODE = 2;
			break;
		}
		//fetch
		opCode = MEM[PC];
		/*
		printf("REGS:\t%d\t%d\tPC: %d\n", i, opCode, PC);
		for (int j = 0; j < 14; j++)
		{
			printf("\t%d: %d\n", j, REGS[j]);
		}
		printf("\n");
		getchar();
		*/
		//printf("%d\t%d\n", opCode, PC);
		if(opCode == 0x10){//si es li
			NPC = PC + 6; //li es la única instruccion que mide 6
			regDst = MEM[PC+1];
			if(regDst < 0 || regDst > 13){ // sino es un regisro valido exit code
				EXIT_CODE = 4;
				break;
			}
			regSrc1 = MEM[PC+2];
			regSrc2 = MEM[PC+3];
			aux1 = MEM[PC+4];
			aux2 = MEM[PC+5]; //para leer toda la instrucción 
			int lit = (regSrc1 << 24)+(regSrc2 << 16)+(aux1 << 8)+(aux2); //inmediat empieza en src1 y termina en aux2
			REGS[regDst] = lit; // << corrimiento hacia la izquierda para acomodar los chars en su respectivo lugar en el integer
			TIME = TIME + 1500; //timpo li le aumento 1500
			//printf("%d\n", REGS[regDst]);
			goto fin;
		}
		regDst = MEM[PC+1]; //empieza todo para una instruccion normal de 4 bytes
		regSrc1 = MEM[PC+2];
		regSrc2 = MEM[PC+3];
		NPC = PC + 4; //la instruccion que sigue está en pc + 4
		if(opCode >= 0 && opCode < 0xB){//es una op que necesita la ALU
			if(regDst < 0 || regDst >13 ||regSrc1 < 0 || regSrc1 >13 ||regSrc2 < 0 || regSrc2 >13){ //checamos que los registros sean validos
				EXIT_CODE = 4;
				break;
			}
			if(opCode == 0x3 && REGS[regSrc2] == 0) { //inst 3 division
				EXIT_CODE = 1; //por dividir entre 0
				break;
			}
			if(opCode == 0x7 && (*(float*)(REGS + regSrc2) == 0)) { //division de flotantes
				EXIT_CODE = 1;
				break;
			}
			REGS[regDst] = ALU(REGS[regSrc1], REGS[regSrc2], opCode); //escribir en el registro destino el resultado de hacer la operacion
			if(opCode == 0x0){
				TIME = TIME + 3;
			}else if(opCode == 0x1){
				TIME = TIME + 4;
			}else if(opCode == 0x2){
				TIME = TIME + 10;
			}else if(opCode == 0x3){
				TIME = TIME + 11;
			}else if(opCode == 0x4){
				TIME = TIME + 4;
			}else if(opCode == 0x5){       //verificar que instruccion fue para aumentar el tiempo y que cada uno tiene un tiempo diferente
				TIME = TIME + 5;
			}else if(opCode == 0x6){
				TIME = TIME + 9;
			}else if(opCode == 0x7){
				TIME = TIME + 10;
			}else if(opCode == 0x8){
				TIME = TIME + 1;
			}else if(opCode == 0x9){
				TIME = TIME + 1;
			}else if(opCode == 0xA){
				TIME = TIME + 1;
			}
			goto fin;
		}else if(opCode == 0xB){//not
			if(regDst < 0 || regDst >13 ||regSrc2 < 0 || regSrc2 >13){
				EXIT_CODE = 4;
				break;
			}
			REGS[regDst] = ~((int)REGS[regSrc2]); //en el registro destino se escribe la negacion de registro fuente 2
			TIME = TIME + 1; //tiempo pdf
		}else if(opCode == 0xC){//loadbyte
			if(regDst < 0 || regDst >13 || regSrc2 < 0 || regSrc2 >13){
				EXIT_CODE = 4;
				break;
			}
			if(REGS[regSrc2] < 0 || REGS[regSrc2] > mem){ //verifica que la direccion de memoria sea valida
				EXIT_CODE = 2;
				break;
			}
			REGS[regDst] = (char)MEM[REGS[regSrc2]]; 
			TIME = TIME + 500;
		}else if(opCode == 0xD){//lw
			if(regDst < 0 || regDst >13 || regSrc2 < 0 || regSrc2 >13){ //registro valido
				EXIT_CODE = 4;
				break;
			}
			if(REGS[regSrc2] < 0 || REGS[regSrc2] > mem-3){ //verifica que la direccion de memoria sea valida
				EXIT_CODE = 2;
				break;
			}
			char tmp1 = (char)MEM[REGS[regSrc2]]; //se leen los cuatro bytes
			char tmp2 = (char)MEM[REGS[regSrc2]+1];
			char tmp3 = (char)MEM[REGS[regSrc2]+2];
			char tmp4 = (char)MEM[REGS[regSrc2]+3];
			REGS[regDst] = (tmp1 << 24) + (tmp2 << 16) + (tmp3 << 8) + tmp4; //corrimiento para acomodar
			TIME = TIME + 1500;
		}else if(opCode == 0xE){//sb
			if(regDst < 0 || regDst >13 || regSrc2 < 0 || regSrc2 >13){
				EXIT_CODE = 4;
				break;
			}
			if(REGS[regDst] < 0 || REGS[regDst] > mem){
				EXIT_CODE = 2;
				break;
			}
			MEM[(int)REGS[regDst]] = (char)REGS[regSrc2]; //se graba en la memoria en la direccin que dice registro destino
			TIME = TIME + 700;
		}else if(opCode == 0xF){//sw
			if(regDst < 0 || regDst >13 || regSrc2 < 0 || regSrc2 >13){
				EXIT_CODE = 4;
				break;
			}
			if(REGS[regDst] < 0 || REGS[regDst] > mem-3){
				EXIT_CODE = 2;
				break;
			}
			char tmp1 = (char)REGS[regSrc2]; //partir el numero que está en src2 en cuatro pedazos 
			char tmp2 = (char)(REGS[regSrc2] >> 8);
			char tmp3 = (char)(REGS[regSrc2] >> 16);
			char tmp4 = (char)(REGS[regSrc2] >> 24);
			MEM[(int)REGS[regDst]] = tmp4;  //se guardan los cuatro pedazos en difenretes direcciones
			MEM[(int)REGS[regDst]+1] = tmp3;
			MEM[(int)REGS[regDst]+2] = tmp2;
			MEM[(int)REGS[regDst]+3] = tmp1;
			TIME = TIME + 2100;
		}else if(opCode == 0x11){//b
			if(regSrc2 < 0 || regSrc2 >13){
				EXIT_CODE = 4;
				break;
			}
			NPC = REGS[regSrc2]; //npc va a hacer lo que diga src2
			TIME = TIME + 1;
			//printf("%d\n", NPC);
			goto fin;
		}else if(opCode == 0x12){//beqz
			if(regDst < 0 || regDst >13 || regSrc2 < 0 || regSrc2 >13){
				EXIT_CODE = 4;
				break;
			}
			//printf("BEQZ: DST:%d %d\t SRC:%d %d\n", regDst, REGS[regDst], regSrc2, REGS[regSrc2]);
			if(REGS[regSrc2] == 0){
				NPC = REGS[regDst];
			}
			TIME = TIME + 4;
			goto fin;
		}else if(opCode == 0x13){//bltz
			if(regDst < 0 || regDst >13 || regSrc2 < 0 || regSrc2 >13){
				EXIT_CODE = 4;
				break;
			}
			//printf("BLTZ: DST:%d %d\t SRC:%d %d\n", regDst, REGS[regDst], regSrc2, REGS[regSrc2]);
			if(REGS[regSrc2] < 0){
				NPC = REGS[regDst];
			}
			TIME = TIME + 5;
			goto fin;
		}else if(opCode == 0x14){//syscall
			char sts = syscall(MEM, mem, REGS); 
			TIME = TIME + 50;
			if(sts == 0){
				//printf("fin de la ejecucion\n");
				EXIT_CODE = 0;
				printf("\n%d\n", TIME);//porque al final de la ejecucion sienpre se imprime el tiempo
				return 0; //se acaba la ejecucion
				
			}else if(sts == 3){
				EXIT_CODE = 3;
				break;
			}else if(sts == 2){
				EXIT_CODE = 2;
				break;
			}else if(sts == 6){
				EXIT_CODE = 6;
				break;
			}
			
		}else{
			EXIT_CODE = 5; //Opcode no válido
			break;
		}

fin:	i++;
		PC = NPC;
		
	} //termina el while y se repite para la siguiente instruccion
	
	FILE *vm;
	vm = fopen("volcado", "wb"); //abro el archivo, lo nombro volcado y se abre en modo writebit
	fputs(MEM, vm); //pongo toda la memoria en el archivo
	fclose(vm);
	return EXIT_CODE;

}

struct Par leer(char* file){ //funcion que al inicio me pasa todo el archivo y me pasa todo el programa
	FILE *f;
	long size;
	unsigned char* buffer;
	struct Par p;
	//abrir archivo
	f = fopen(file, "rb");
	if(!f){
		p.str = NULL;
		return p; //regreso el Par
	}
	//medirlo
	fseek(f, 0L, SEEK_END); //empieza a buscar desde el inicio el fin del archivo
	size = ftell(f); //con size voy a ver en qué posicion se detuvo fseek
	rewind(f);//regresar al inicio del archivo
	p.lsize = size; //
	//reservar la memoria ssufuciente
	buffer = calloc(1, size); //voy a reservar memoria para guardar el archivo
	if(!buffer) { //Sino se reservó la memoria regresa NULL
		fclose(f);
		p.str = NULL;
		return p;
	}
	//leer el archivo si se reservó la memoria
	char q = fread(buffer, size, 1, f); //va a escribir en buffer los primeros size bites del archivo f
	if(1!=q){ //si no regresa 1 no se copió
		fclose(f);
		p.str = NULL;
		return p;
	}
	p.str = buffer;
	//cerrar el archivo
	fclose(f);

	return p;
}

//cod 8
//arg 9
//ret 10
char syscall(unsigned char *mem, int m, int * regs){
	fflush(stdin); //purgar entrada estandar
	fflush(stdout);//purgar la salida estandar
	char str[256];
	if(regs[8]==0x0){ // =x leer entero 
		fgets(str, 256, stdin); // guardar en str (maximo 256 caracteres) lo leido en stdin
		sscanf(str, "%d", &regs[10]); //voy a leer de str un numero  y lo voy a guardar en el registro 10
	}else if(regs[8]==0x1){ //Leer caracter
		fgets(str, 256, stdin);
		sscanf(str, "%c", &regs[10]);
	}else if(regs[8]==0x2){ //Leer flotante
		fgets(str, 256, stdin);
		sscanf(str, "%f", (float*)&regs[10]);
	}else if(regs[8]==0x3){ //leer cadena
		
		//fflush(stdin);
		fgets(str, 256, stdin); // guardar en str (maximo 256 caracteres) lo leido en stdin
		int n = tam(str); //calcular el tamaño de lo que se leyó
		regs[10] = n; // escribir en el regustro 10 el tamaño
		//str[n] = '\0';
		if(regs[9]<0||regs[9]>m-n){ //checo que la direccion de memoria sea válida  m= tamaño de la memoria, n=el tamaño de lo que leí 
			
			return 3; //3 codigo de error
		}
		//printf("%d\n", n);
		memcpy(&mem[regs[9]], str, n); // copio lo leido a la direccion que dice registro 9
		
	}else if(regs[8]==0x4){ //Escribir entero
		printf("%d\n", regs[9]); //escribir un numero el que está en el registro 9
	}else if(regs[8]==0x5){ //Escribir caracter
		printf("%c\n", (char)regs[9]);
	}else if(regs[8]==0x6){ //Escribir flotante
		printf("%f\n", *(float*)&regs[9]);
	}else if(regs[8]==0x7){ //Escribir cadena
		if(regs[9]<0||regs[9]>=m){//direccion inválida
			return 2;//me salgo con codigo 2
		}
		printf("%s\n", (char*)&mem[regs[9]]); //voy a escribir una cadena, la que está ne a direccion de memoria que dice registro 9
	}else if(regs[8]==0x8){ //finalizar ejecucion
		return 0;
	}else{
		return 6;//codigo inválido
	}
	return 1; //Regreso inútil
}

int ALU(int src1, int src2, unsigned char opCode){
	if(opCode == 0x0){ 
		return ADD(src1, src2);
	}else if(opCode == 0x1){
		return SUB(src1, src2);
	}else if(opCode == 0x2){
		return MUL(src1, src2);
	}else if(opCode == 0x3){
		return DIV(src1, src2);
	}else if(opCode == 0x4){
		return FADD(src1, src2);
	}else if(opCode == 0x5){
		return FSUB(src1, src2);
	}else if(opCode == 0x6){
		return FMUL(src1, src2);
	}else if(opCode == 0x7){
		return FDIV(src1, src2);
	}else if(opCode == 0x8){
		return AND(src1, src2);
	}else if(opCode == 0x9){
		return OR(src1, src2);
	}else return XOR(src1, src2);
}

int ADD(int a, int b){
	return a + b;
}

int SUB(int a, int b){
	return a - b;
}

int MUL(int a, int b){
	return a * b;
}

int DIV(int a, int b){
	return a / b;
}

int FADD(int a, int b){
	float c = (*(float*)&a + *(float*)&b);
	return *(int*)&c;
}

int FSUB(int a, int b){
	float c = (*(float*)&a - *(float*)&b);
	return *(int*)&c;
}

int FMUL(int a, int b){
	float c = (*(float*)&a * *(float*)&b);
	return *(int*)&c;
}

int FDIV(int a, int b){
	float c = (*(float*)&a / *(float*)&b);
	return *(int*)&c; //regresa el flotante representado como un entero
}

int AND(int a, int b){
	return a & b;
}

int OR(int a, int b){
	return a | b;
}

int XOR(int a, int b){
	return a ^ b;
}

int tam(char* str){
	char i = *str;
	int n =0; //lee caracter por caracter hasta encontrar el nulo
	while(i!='\0'){ //mientras no sea nulo paso al siguiente y aumento
		i = *(str+n);
		n++;
	}
	return n; //si es nulo salgo del while y regreso el tamaño
}