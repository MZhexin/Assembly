; �������������������������������������������������������������������������

    .486                      ; force 32 bit code
    .model flat, stdcall      ; memory model & calling convention
    option casemap :none      ; case sensitive

    AsciiDump PROTO :DWORD,:DWORD,:DWORD

    .code

; �������������������������������������������������������������������������

align 16

AsciiDump proc lpsrc:DWORD,lpbuf:DWORD,lnsrc:DWORD

    jmp @F

  align 4
  StringTable:
    db "  0",44,"  1",44,"  2",44,"  3",44,"  4",44,"  5",44,"  6",44,"  7",44
    db "  8",44,"  9",44," 10",44," 11",44," 12",44," 13",44," 14",44," 15",44
    db " 16",44," 17",44," 18",44," 19",44," 20",44," 21",44," 22",44," 23",44
    db " 24",44," 25",44," 26",44," 27",44," 28",44," 29",44," 30",44," 31",44
    db " 32",44," 33",44," 34",44," 35",44," 36",44," 37",44," 38",44," 39",44
    db " 40",44," 41",44," 42",44," 43",44," 44",44," 45",44," 46",44," 47",44
    db " 48",44," 49",44," 50",44," 51",44," 52",44," 53",44," 54",44," 55",44
    db " 56",44," 57",44," 58",44," 59",44," 60",44," 61",44," 62",44," 63",44
    db " 64",44," 65",44," 66",44," 67",44," 68",44," 69",44," 70",44," 71",44
    db " 72",44," 73",44," 74",44," 75",44," 76",44," 77",44," 78",44," 79",44
    db " 80",44," 81",44," 82",44," 83",44," 84",44," 85",44," 86",44," 87",44
    db " 88",44," 89",44," 90",44," 91",44," 92",44," 93",44," 94",44," 95",44
    db " 96",44," 97",44," 98",44," 99",44,"100",44,"101",44,"102",44,"103",44
    db "104",44,"105",44,"106",44,"107",44,"108",44,"109",44,"110",44,"111",44
    db "112",44,"113",44,"114",44,"115",44,"116",44,"117",44,"118",44,"119",44
    db "120",44,"121",44,"122",44,"123",44,"124",44,"125",44,"126",44,"127",44
    db "128",44,"129",44,"130",44,"131",44,"132",44,"133",44,"134",44,"135",44
    db "136",44,"137",44,"138",44,"139",44,"140",44,"141",44,"142",44,"143",44
    db "144",44,"145",44,"146",44,"147",44,"148",44,"149",44,"150",44,"151",44
    db "152",44,"153",44,"154",44,"155",44,"156",44,"157",44,"158",44,"159",44
    db "160",44,"161",44,"162",44,"163",44,"164",44,"165",44,"166",44,"167",44
    db "168",44,"169",44,"170",44,"171",44,"172",44,"173",44,"174",44,"175",44
    db "176",44,"177",44,"178",44,"179",44,"180",44,"181",44,"182",44,"183",44
    db "184",44,"185",44,"186",44,"187",44,"188",44,"189",44,"190",44,"191",44
    db "192",44,"193",44,"194",44,"195",44,"196",44,"197",44,"198",44,"199",44
    db "200",44,"201",44,"202",44,"203",44,"204",44,"205",44,"206",44,"207",44
    db "208",44,"209",44,"210",44,"211",44,"212",44,"213",44,"214",44,"215",44
    db "216",44,"217",44,"218",44,"219",44,"220",44,"221",44,"222",44,"223",44
    db "224",44,"225",44,"226",44,"227",44,"228",44,"229",44,"230",44,"231",44
    db "232",44,"233",44,"234",44,"235",44,"236",44,"237",44,"238",44,"239",44
    db "240",44,"241",44,"242",44,"243",44,"244",44,"245",44,"246",44,"247",44
    db "248",44,"249",44,"250",44,"251",44,"252",44,"253",44,"254",44,"255",44
  @@:

    push ebx
    push esi
    push edi

    lea edx, StringTable
    xor ebx, ebx                    ; line length counter

    mov ecx, lpsrc
    add ecx, lnsrc

    mov esi, lpsrc
    mov edi, lpbuf

    mov [edi], DWORD PTR 0D202020h  ; 3 space padding for alignment + CR
    add edi, 4
    mov [edi], DWORD PTR 2062640Ah  ; LF + "db "
    add edi, 4

    xor eax, eax                    ; avoid stall
    jmp adst

; �=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�

  align 4
  pre:
    mov [edi-1], BYTE PTR 13        ; overwrite comma with CR
    mov [edi], DWORD PTR 2062640Ah  ; write 4 bytes to maintain alignment
    add edi, 4
    xor ebx, ebx                    ; zero character count
  adst:
    mov al, [esi]
    add esi, 1
    cmp esi, ecx                    ; test exit condition
    jg trimit
    push [edx+eax*4]                ; write table entry
    pop [edi]                       ; to address in EDI
    add edi, 4

    cmp ebx, 15                     ; test character count per line
    je pre                          ; jump on less common choice
    add ebx, 1
    jmp adst

; �=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�=�

; -----------------------------------------
; right trim any characters that are not
; decimal numbers, "0" to "9"
; -----------------------------------------
  trimit:
    sub edi, 1
  tloop:
    cmp BYTE PTR [edi], "0"
    jl @F
    cmp BYTE PTR [edi], "9"
    jg @F
    jmp lastbye
  @@:
    sub edi, 1
    jmp tloop

  lastbye:
    mov BYTE PTR [edi+1], 0

    pop edi
    pop esi
    pop ebx

    ret

AsciiDump endp

; �������������������������������������������������������������������������

    end