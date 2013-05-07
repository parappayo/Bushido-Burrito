
from ctypes import *

WORD = c_ushort
DWORD = c_ulong
TCHAR = c_char
LONG = c_long
LPBYTE = POINTER(c_ubyte)
LPTSTR = POINTER(c_char) 
ULONG_PTR = POINTER(c_ulong)
HANDLE = c_void_p
MAX_PATH = 260
TH32CS_SNAPPROCESS = 0x00000002

kernel32 = windll.kernel32

class PROCESSENTRY32(Structure):
	_fields_ = [
		("dwSize",				DWORD),
		("cntUsage",			DWORD),
		("th32ProcessID",		DWORD),
		("th32DefaultHeapID",	ULONG_PTR),
		("th32ModuleID",		DWORD),
		("cntThreads",			DWORD),
		("th32ParentProcessID",	DWORD),
		("pcPriClassBase",		LONG),
		("dwFlags",				DWORD),
		("szExeFile",			TCHAR * MAX_PATH),
	]

def print_process(entry):
	print("id=" + str(entry.th32ProcessID) + "\texe=" + str(entry.szExeFile) + "\tthreads=" + str(entry.cntThreads))

def list_processes():
	process_entry = PROCESSENTRY32()
	process_entry.dwSize = sizeof(PROCESSENTRY32)

	handle = kernel32.CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)

	kernel32.Process32First(handle, byref(process_entry))
	print_process(process_entry)

	while (kernel32.Process32Next(handle, byref(process_entry))):
		print_process(process_entry)

if __name__ == '__main__':
	list_processes()

