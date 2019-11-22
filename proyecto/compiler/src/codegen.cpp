#include "codegen.h"
#include "token.h"
#include "parser.h"
#include <cstring> 

AsmCodeGen::AsmCodeGen(deque<Instr>& code, 
		       deque<int>& deferred, 
		       deque<char*>& deferredid,
		       deque<ProcEntry>& proc, 
		       deque<StrEntry>& strings,
		       int codeSize)
  : current(code.front()){
  this -> code = code;
  this -> deferred = deferred;
  this -> deferredid = deferredid;
  this -> proc = proc;
  this -> strings = strings;
  this -> errors = false;

  strSection = codeSection = NULL;  
  strSectionSize = 0;
  codeSectionSize = codeSize;
}

void AsmCodeGen::compile(const char* filename){
  if(!findMain()){
    cgenErr("main procedure not found", false);
  } else {
    buildDataSection();
    buildCodeSection();
    if(!errors){
      writeCode(filename);
    }
  }
}

void AsmCodeGen::buildCodeSection(){
  codeSection = new char[codeSectionSize];
  int pos = strSectionSize + PREAMBLESIZE;
  int codepos = 0;

  while(!code.empty()){
    Instr i = code.front();
    code.pop_front();
    unsigned char opc = i.getOpcode();

    if(opc == LI){
      int addr;
      if(pos == deferred.front()){
	addr = lookup(deferredid.front());
	deferred.pop_front();
	deferredid.pop_front();
      } else {
	addr = i.getCval();
      }
      codeSection[codepos++] = opc;
      codeSection[codepos++] = i.getDest();
      codeSection[codepos++] = (addr & 0xFF000000) >> 24;
      codeSection[codepos++] = (addr & 0x00FF0000) >> 16;
      codeSection[codepos++] = (addr & 0x0000FF00) >> 8;
      codeSection[codepos++] = addr & 0x000000FF;
      pos += 6;
    } else {
      codeSection[codepos++] = opc;
      codeSection[codepos++] = i.getDest();
      codeSection[codepos++] = i.getOp1();
      codeSection[codepos++] = i.getOp2();
      pos += 4;
    }
  }
}

void AsmCodeGen::buildDataSection(){
  std::deque<StrEntry>::iterator it;
  int pos = 0;
  int j;
  if(strings.size() > 0){
    StrEntry last = strings.back();
    strSectionSize = last.getAddr() + last.getSize() + last.attach() - PREAMBLESIZE;
    strSection = new char[strSectionSize];
    
    for(j = 0, it = strings.begin(); j < strings.size(); j++, it++){
      char *actual = (*it).getStr();
      int l = (*it).getSize();
      l++;
      int i = 0;
      if(actual != NULL){
	while(i < l){
	  strSection[pos++] = actual[i++];
	}
	strSection[pos-1] = '\0';
      } else {
	while(i++ < l){
	  strSection[pos++] = '\0';
	}
      }
    }
  } else {
    strSectionSize = 0;
    strSection = NULL;
  }
}

bool AsmCodeGen::cgenErrors() const {
  return errors;
}

void AsmCodeGen::cgenErr(const char *msg, bool showLine){
  cerr << msg << " ";
  if(showLine)
    cerr << " on line: " << current.getLineNum();
  cerr << endl;
  errors = true;
}

bool AsmCodeGen::findMain(){
  std::deque<ProcEntry>::const_iterator it;
  bool mainFound = false;
  int i;
  for(i = 0, it = proc.begin(); i < proc.size(); ++i, ++it){

    if(strcmp((*it).getId(), "main") == 0){
      i = proc.size();
      mainFound = true;
      mainAddr = (*it).getAddr();
    }
  }
  return mainFound;
}

void AsmCodeGen::nextInstr(){
  
}

int AsmCodeGen::lookup(char *id){
  int i;
  std::deque<ProcEntry>::const_iterator it;
  std::deque<StrEntry>::const_iterator si;

  for(i = 0, it = proc.begin(); i < proc.size(); ++i, ++it){
    if(strcmp((*it).getId(), id) == 0){
      return (*it).getAddr();
    }
  }

  for(i = 0, si = strings.begin(); i < strings.size(); ++i, ++si){
    char *actual = (*si).getId();
    if(strcmp(actual, id) == 0){
      return (*si).getAddr();
    } 
  }
  const char* m = "Identifier undeclared \"";
  const char* m2 = "\"";
  char *msg = new char[strlen(m) + strlen(m2) + strlen(id) + 1];
  strcpy(msg, m);
  strcat(msg, id);
  strcat(msg, m2);
  cgenErr(msg, true);
  return -1;
}

void AsmCodeGen::writeCode(const char *filename){
  ofstream out(filename, ios::out);
  if(!out){
    cgenErr("Couldn't write to destination file", false);
    return;
  }
  char m1, m2, m3, m4;
  m1 = (mainAddr & 0xFF000000) >> 24;
  m2 = (mainAddr & 0xFF0000) >> 16;
  m3 = (mainAddr & 0xFF00) >> 8;
  m4 = mainAddr & 0xFF;

  out << '\x10' << '\0';
  out << m1 << m2 << m3 << m4;
  out << '\x11' << '\0' << '\0' << '\0';

  int written, deberia;

  int i;

  written = PREAMBLESIZE;

  for(i = 0; i < strSectionSize; ++i){
    out << strSection[i];
  }
  written += i;

  for(i = 0; i < codeSectionSize; ++i){
    out << codeSection[i];
  }
  written += i;

  cout << written << " bytes written." << endl;
}

bool AsmCodeGen::codeGenErrors() const {
  return errors;
}
