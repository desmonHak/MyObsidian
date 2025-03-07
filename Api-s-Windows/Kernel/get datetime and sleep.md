```c
#include <stdio.h>
#include <windows.h>

#define KUSER_SHARED_DATA_PTR 0x7FFE0000
#define EPOCH_DIFFERENCE 116444736000000000ULL  // Offset entre 1/1/1601 y 1/1/1970 en 100 ns


typedef struct _KSYSTEM_TIME
{
    ULONG LowPart;
    LONG High1Time;
    LONG High2Time;
} KSYSTEM_TIME, *PKSYSTEM_TIME;
typedef enum _NT_PRODUCT_TYPE
{
         NtProductWinNt = 1,
         NtProductLanManNt = 2,
         NtProductServer = 3
} NT_PRODUCT_TYPE;
typedef enum _ALTERNATIVE_ARCHITECTURE_TYPE
{
         StandardDesign = 0,
         NEC98x86 = 1,
         EndAlternatives = 2
} ALTERNATIVE_ARCHITECTURE_TYPE;
typedef struct _KUSER_SHARED_DATA {
    ULONG                         TickCountLowDeprecated;
    ULONG                         TickCountMultiplier;
    KSYSTEM_TIME                  InterruptTime;
    KSYSTEM_TIME                  SystemTime;
    KSYSTEM_TIME                  TimeZoneBias;
    USHORT                        ImageNumberLow;
    USHORT                        ImageNumberHigh;
    WCHAR                         NtSystemRoot[260];
    ULONG                         MaxStackTraceDepth;
    ULONG                         CryptoExponent;
    ULONG                         TimeZoneId;
    ULONG                         LargePageMinimum;
    ULONG                         AitSamplingValue;
    ULONG                         AppCompatFlag;
    ULONGLONG                     RNGSeedVersion;
    ULONG                         GlobalValidationRunlevel;
    LONG                          TimeZoneBiasStamp;
    ULONG                         NtBuildNumber;
    NT_PRODUCT_TYPE               NtProductType;
    BOOLEAN                       ProductTypeIsValid;
    BOOLEAN                       Reserved0[1];
    USHORT                        NativeProcessorArchitecture;
    ULONG                         NtMajorVersion;
    ULONG                         NtMinorVersion;
    #define 	                  PROCESSOR_FEATURE_MAX   64
    BOOLEAN                       ProcessorFeatures[PROCESSOR_FEATURE_MAX];
    ULONG                         Reserved1;
    ULONG                         Reserved3;
    ULONG                         TimeSlip;
    ALTERNATIVE_ARCHITECTURE_TYPE AlternativeArchitecture;
    ULONG                         BootId;
    LARGE_INTEGER                 SystemExpirationDate;
    ULONG                         SuiteMask;
    BOOLEAN                       KdDebuggerEnabled;
    union {
      UCHAR MitigationPolicies;
      struct {
        UCHAR NXSupportPolicy : 2;
        UCHAR SEHValidationPolicy : 2;
        UCHAR CurDirDevicesSkippedForDlls : 2;
        UCHAR Reserved : 2;
      };
    };
    USHORT                        CyclesPerYield;
    ULONG                         ActiveConsoleId;
    ULONG                         DismountCount;
    ULONG                         ComPlusPackage;
    ULONG                         LastSystemRITEventTickCount;
    ULONG                         NumberOfPhysicalPages;
    BOOLEAN                       SafeBootMode;
    union {
      UCHAR VirtualizationFlags;
      struct {
        UCHAR ArchStartedInEl2 : 1;
        UCHAR QcSlIsSupported : 1;
      };
    };
    UCHAR                         Reserved12[2];
    union {
      ULONG SharedDataFlags;
      struct {
        ULONG DbgErrorPortPresent : 1;
        ULONG DbgElevationEnabled : 1;
        ULONG DbgVirtEnabled : 1;
        ULONG DbgInstallerDetectEnabled : 1;
        ULONG DbgLkgEnabled : 1;
        ULONG DbgDynProcessorEnabled : 1;
        ULONG DbgConsoleBrokerEnabled : 1;
        ULONG DbgSecureBootEnabled : 1;
        ULONG DbgMultiSessionSku : 1;
        ULONG DbgMultiUsersInSessionSku : 1;
        ULONG DbgStateSeparationEnabled : 1;
        ULONG SpareBits : 21;
      } DUMMYSTRUCTNAME2;
    } DUMMYUNIONNAME2;
    ULONG                         DataFlagsPad[1];
    ULONGLONG                     TestRetInstruction;
    LONGLONG                      QpcFrequency;
    ULONG                         SystemCall;
    ULONG                         Reserved2;
    ULONGLONG                     FullNumberOfPhysicalPages;
    ULONGLONG                     SystemCallPad[1];
    union {
      KSYSTEM_TIME TickCount;
      ULONG64      TickCountQuad;
      struct {
        ULONG ReservedTickCountOverlay[3];
        ULONG TickCountPad[1];
      } DUMMYSTRUCTNAME;
    } DUMMYUNIONNAME3;
    ULONG                         Cookie;
    ULONG                         CookiePad[1];
    LONGLONG                      ConsoleSessionForegroundProcessId;
    ULONGLONG                     TimeUpdateLock;
    ULONGLONG                     BaselineSystemTimeQpc;
    ULONGLONG                     BaselineInterruptTimeQpc;
    ULONGLONG                     QpcSystemTimeIncrement;
    ULONGLONG                     QpcInterruptTimeIncrement;
    UCHAR                         QpcSystemTimeIncrementShift;
    UCHAR                         QpcInterruptTimeIncrementShift;
    USHORT                        UnparkedProcessorCount;
    ULONG                         EnclaveFeatureMask[4];
    ULONG                         TelemetryCoverageRound;
    USHORT                        UserModeGlobalLogger[16];
    ULONG                         ImageFileExecutionOptions;
    ULONG                         LangGenerationCount;
    ULONGLONG                     Reserved4;
    ULONGLONG                     InterruptTimeBias;
    ULONGLONG                     QpcBias;
    ULONG                         ActiveProcessorCount;
    UCHAR                         ActiveGroupCount;
    UCHAR                         Reserved9;
    union {
      USHORT QpcData;
      struct {
        UCHAR QpcBypassEnabled;
        UCHAR QpcReserved;
      };
    };
    LARGE_INTEGER                 TimeZoneBiasEffectiveStart;
    LARGE_INTEGER                 TimeZoneBiasEffectiveEnd;
    XSTATE_CONFIGURATION          XState;
    KSYSTEM_TIME                  FeatureConfigurationChangeStamp;
    ULONG                         Spare;
    ULONG64                       UserPointerAuthMask;
    XSTATE_CONFIGURATION          XStateArm64;
    ULONG                         Reserved10[210];
} KUSER_SHARED_DATA, *PKUSER_SHARED_DATA;


// Lectura consistente de KSYSTEM_TIME (se reintenta hasta obtener High1Time == High2Time)
ULONGLONG read_ksystem_time(const KSYSTEM_TIME *kt) {
    LONG high1, high2;
    ULONG low;
    do {
        high1 = kt->High1Time;
        low   = kt->LowPart;
        high2 = kt->High2Time;
    } while (high1 != high2);
    return (((ULONGLONG)high1) << 32) | low;
}

// Lee de forma consistente un valor con signo de KSYSTEM_TIME (útil para TimeZoneBias)
LONGLONG read_signed_ksystem_time(const KSYSTEM_TIME *kt) {
    LONG high1, high2;
    ULONG low;
    do {
        high1 = kt->High1Time;
        low   = kt->LowPart;
        high2 = kt->High2Time;
    } while (high1 != high2);
    return (((LONGLONG)high1) << 32) | low;
}

int is_leap_year(int year) {
    return ((year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0)));
}

int days_in_year(int year) {
    return is_leap_year(year) ? 366 : 365;
}

int days_in_month(int year, int month) {
    static const int mdays[12] = { 31,28,31,30,31,30,31,31,30,31,30,31 };
    if (month == 2 && is_leap_year(year))
        return 29;
    return mdays[month - 1];
}

void unix_time_to_systemtime(ULONGLONG seconds, SYSTEMTIME *st) {
    ULONGLONG days = seconds / 86400;
    ULONGLONG rem = seconds % 86400;

    st->wHour   = (WORD)(rem / 3600);
    st->wMinute = (WORD)((rem % 3600) / 60);
    st->wSecond = (WORD)(rem % 60);
    st->wMilliseconds = 0;

    int year = 1970;
    while (days >= (ULONGLONG)days_in_year(year)) {
        days -= days_in_year(year);
        year++;
    }
    st->wYear = (WORD)year;

    int month = 1;
    while (days >= (ULONGLONG)days_in_month(year, month)) {
        days -= days_in_month(year, month);
        month++;
    }
    st->wMonth = (WORD)month;
    st->wDay = (WORD)(days + 1);
}

void get_current_time() {
    KUSER_SHARED_DATA *kuser = (KUSER_SHARED_DATA*)KUSER_SHARED_DATA_PTR;

    // Leer SystemTime (se asume que es local) y convertirlo a 100ns
    ULONGLONG sysTime100ns = read_ksystem_time(&kuser->SystemTime);
    // Convertir a segundos desde Unix epoch:
    ULONGLONG unix_secs = (sysTime100ns - EPOCH_DIFFERENCE) / 10000000ULL;
    
    SYSTEMTIME st;
    unix_time_to_systemtime(unix_secs, &st);

    // Leer el TimeZoneBias (en 100 ns, con signo)
    LONGLONG bias100ns = read_signed_ksystem_time(&kuser->TimeZoneBias);
    // El bias se define como la cantidad que se debe restar de SystemTime para obtener la hora local.
    // Por ello, el desfase real (offset) respecto a UTC es: offset = - (bias en segundos)
    LONGLONG biasSeconds = bias100ns / 10000000LL;
    LONGLONG offsetSeconds = -biasSeconds; // Ej: si biasSeconds es +18000 (5h), offset es -18000
    char sign = (offsetSeconds < 0) ? '-' : '+';
    LONGLONG absOffset = (offsetSeconds < 0) ? -offsetSeconds : offsetSeconds;
    LONGLONG offsetHours = absOffset / 3600;
    LONGLONG offsetMinutes = (absOffset % 3600) / 60;

    printf("Fecha y hora actual ( no local ): %02d-%02d-%04d %02d:%02d:%02d (UTC%c%02lld:%02lld)\n",
           st.wDay, st.wMonth, st.wYear, 
           st.wHour, st.wMinute, st.wSecond,
           sign, offsetHours, offsetMinutes
    );

    unsigned char val = 1;
    if (sign == '-') { val *= -1; } 
    printf("Fecha y hora actual (  local   ): %02d-%02d-%04d %02d:%02d:%02d\n",
           st.wDay, st.wMonth, st.wYear, 
           st.wHour + val * offsetHours, st.wMinute + val * offsetMinutes, st.wSecond);
}





// Sleep usando InterruptTime (con busy-wait sin llamadas al sistema y sin prints internos)
void sleep_ticks(DWORD milliseconds) {
    KUSER_SHARED_DATA *kuser = (KUSER_SHARED_DATA*)KUSER_SHARED_DATA_PTR;
    ULONGLONG start = read_ksystem_time(&kuser->InterruptTime);
    ULONGLONG end = start + (milliseconds * 10000ULL); // convertir ms a 100 ns

    while (read_ksystem_time(&kuser->InterruptTime) < end) {
        asm("pause"); // Busy-wait sin prints
    }
}

void hex_dump(char* buffer, unsigned int count) {
    unsigned int i;
    for (i = 0; i < count; i += 16) {
        printf("%04X: ", i);
        for (unsigned int j = 0; j < 16 && i + j < count; j++) {
            printf("%02X ", (unsigned char)buffer[i + j]);
        }
        printf("\n");
    }
}


int main() {
    get_current_time();

    printf("Durmiendo 3 segundos...\n");
    sleep_ticks(3000);
    
    printf("Despierto!\n");
    get_current_time();

    hex_dump(KUSER_SHARED_DATA_PTR,32);
    
    return 0;
}


```