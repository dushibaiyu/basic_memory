module sidero.base.system;
import sidero.base.containers.readonlyslice;
import sidero.base.text;
import sidero.base.text.unicode.characters.database : UnicodeLanguage;
import sidero.base.traits : isUTFReadOnly, isUTFBuilder;
import sidero.base.attributes : hidden;

export @safe nothrow @nogc:

version (Posix) {
    ///
    enum PathSeperator = '/';
} else version (Windows) {
    ///
    enum PathSeperator = '\\';
} else
    static assert(0, "Unimplemented");

///
struct EnvironmentVariables {
export @safe nothrow @nogc:

    ///
    static String_ASCII opIndex(scope String_ASCII key) @trusted nothrow @nogc {
        import sidero.base.allocators.api;
        import std.algorithm : countUntil;
        import core.stdc.string : strlen;

        if (key.isNull)
            return String_ASCII.init;
        if (!key.isPtrNullTerminated)
            key = key.dup();

        RCAllocator allocator = globalAllocator();

        version (Windows) {
            import core.sys.windows.winbase : GetEnvironmentVariableA;
            import core.sys.windows.winnt : LPSTR;

            for (;;) {
                const valueSize = GetEnvironmentVariableA(cast(LPSTR)key.ptr, null, 0);

                if (valueSize <= 1)
                    return String_ASCII.init;

                ubyte[] buffer = allocator.makeArray!ubyte(valueSize);
                const valueSize2 = GetEnvironmentVariableA(cast(LPSTR)key.ptr, cast(LPSTR)buffer.ptr, cast(uint)buffer.length);

                if (valueSize2 + 1 != valueSize) {
                    allocator.dispose(buffer);
                    continue;
                }

                return String_ASCII(buffer[0 .. valueSize2], allocator, buffer);
            }
        } else version (Posix) {
            import core.stdc.stdlib : getenv;

            char* got = getenv(cast(char*)key.ptr);

            if (got is null)
                return String_ASCII.init;

            size_t length = strlen(cast(char*)got);

            return String_ASCII(cast(String_ASCII.LiteralType)got[0 .. length]).dup;
        } else
            static assert(0, "Unimplemented");
    }

    ///
    static String_UTF8 opIndex(scope StringBuilder_UTF8 key) {
        return opIndex(key.asReadOnly);
    }

    ///
    static String_UTF16 opIndex(scope StringBuilder_UTF16 key) {
        return opIndex(key.asReadOnly);
    }

    ///
    static String_UTF32 opIndex(scope StringBuilder_UTF32 key) {
        return opIndex(key.asReadOnly);
    }

    ///
    static Other opIndex(Other)(scope Other key) @trusted if (isUTFReadOnly!Other) {
        import sidero.base.allocators.api;
        import std.algorithm : countUntil;
        import core.stdc.string : strlen;

        if (key.isNull)
            return typeof(return).init;

        RCAllocator allocator = globalAllocator();

        version (Windows) {
            import core.sys.windows.winbase : GetEnvironmentVariableW;
            import core.sys.windows.winnt : LPWSTR;

            static if (is(Char == wchar)) {
                String_UTF16 toUse = key;
            } else {
                String_UTF16 toUse = key.byUTF16;
            }

            if (!toUse.isPtrNullTerminated || toUse.isEncodingChanged)
                toUse = toUse.dup();

            for (;;) {
                const valueSize = GetEnvironmentVariableW(cast(LPWSTR)toUse.ptr, null, 0);

                if (valueSize <= 1)
                    return typeof(return).init;

                wchar[] buffer = allocator.makeArray!wchar(valueSize);
                const valueSize2 = GetEnvironmentVariableW(cast(LPWSTR)toUse.ptr, cast(LPWSTR)buffer.ptr, cast(uint)buffer.length);

                if (valueSize2 + 1 != valueSize) {
                    allocator.dispose(buffer);
                    continue;
                }

                return typeof(return)(buffer[0 .. valueSize2], allocator, buffer);
            }
        } else version (Posix) {
            import core.stdc.stdlib : getenv;

            static if (is(Char == char)) {
                String_UTF8 toUse = key;
            } else {
                String_UTF8 toUse = key.byUTF8;
            }

            if (!toUse.isPtrNullTerminated || toUse.isEncodingChanged)
                toUse = toUse.dup();

            char* got = getenv(cast(char*)toUse.ptr);

            if (got is null)
                return typeof(return).init;

            size_t length = strlen(cast(char*)got);

            return typeof(return)(got[0 .. length]).dup;
        } else
            static assert(0, "Unimplemented");
    }

    ///
    static void opIndexAssign(scope String_ASCII value, scope String_ASCII key) @trusted {
        if (key.isNull)
            return;

        if (!key.isPtrNullTerminated)
            key = key.dup();
        if (!value.isNull && !value.isPtrNullTerminated)
            value = value.dup();

        version (Windows) {
            import core.sys.windows.winbase : SetEnvironmentVariableA;
            import core.sys.windows.winnt : LPCH;

            SetEnvironmentVariableA(cast(LPCH)key.ptr, cast(LPCH)value.ptr);
        } else version (Posix) {
            import core.sys.posix.stdlib : setenv, unsetenv;

            if (!value.isNull)
                setenv(cast(char*)key.ptr, cast(char*)value.ptr);
            else
                unsetenv(cast(char*)key.ptr);
        } else
            static assert(0, "Unimplemented");
    }

    ///
    static void opIndexAssign(Input1, Input2)(scope Input1 value, scope Input2 key)
            if (isUTFReadOnly!Input1 && isUTFBuilder!Input2) {
        opIndexAssign(value, key.asReadOnly);
    }

    ///
    static void opIndexAssign(Input1, Input2)(scope Input1 value, scope Input2 key)
            if (isUTFBuilder!Input1 && isUTFReadOnly!Input2) {
        opIndexAssign(value.asReadOnly, key);
    }

    ///
    static void opIndexAssign(Input1, Input2)(scope Input1 value, scope Input2 key)
            if (isUTFBuilder!Input1 && isUTFBuilder!Input2) {
        opIndexAssign(value.asReadOnly, key.asReadOnly);
    }

    ///
    static void opIndexAssign(Input1, Input2)(scope Input1 value, scope Input2 key) @trusted
            if (isUTFReadOnly!Input1 && isUTFReadOnly!Input2) {
        if (key.isNull)
            return;

        version (Windows) {
            import core.sys.windows.winbase : SetEnvironmentVariableW;
            import core.sys.windows.winnt : LPWCH;

            String_UTF16 toUseK = key.byUTF16;
            if (!toUseK.isPtrNullTerminated || toUseK.isEncodingChanged)
                toUseK = toUseK.dup();

            String_UTF16 toUseV = value.byUTF16;
            if (!toUseV.isPtrNullTerminated || toUseV.isEncodingChanged)
                toUseV = toUseV.dup();

            SetEnvironmentVariableW(cast(LPWCH)toUseK.ptr, cast(LPWCH)toUseV.ptr);
        } else version (Posix) {
            import core.sys.posix.stdlib : setenv, unsetenv;

            String_UTF8 toUseK = key.byUTF8;
            if (!toUseK.isPtrNullTerminated || toUseK.isEncodingChanged)
                toUseK = toUseK.dup();

            String_UTF8 toUseV = value.byUTF8;
            if (!toUseK.isPtrNullTerminated || toUseK.isEncodingChanged)
                toUseV = toUseV.dup();

            if (!value.isNull)
                setenv(cast(char*)toUseK.ptr, cast(char*)toUseV.ptr);
            else
                unsetenv(cast(char*)toUseK.ptr);
        } else
            static assert(0, "Unimplemented");
    }

    ///
    static int opApply(scope int delegate(ref String_UTF8 key) @safe nothrow @nogc del) @trusted {
        return opApply((scope ref String_UTF8 key, scope ref String_UTF8 value) {
            String_UTF8 key2 = key.dup;
            return del(key2);
        });
    }

    ///
    static int opApply(scope int delegate(scope ref String_UTF8 key) @safe nothrow @nogc del) @trusted {
        return opApply((scope ref String_UTF8 key, scope ref String_UTF8 value) => del(key));
    }

    ///
    static int opApply(scope int delegate(ref String_UTF8 key, ref String_UTF8 value) @safe nothrow @nogc del) @trusted {
        return opApply((scope ref String_UTF8 key, scope ref String_UTF8 value) {
            String_UTF8 key2 = key.dup, value2 = value.dup;

            return del(key2, value2);
        });
    }

    ///
    static int opApply(scope int delegate(scope ref String_UTF8 key, scope ref String_UTF8 value) @safe nothrow @nogc del) @trusted {
        int result;

        version (Windows) {
            import core.sys.windows.winbase : GetEnvironmentStringsW, FreeEnvironmentStringsW;
            import core.sys.windows.winnt : LPWCH;
            import core.stdc.wctype : wcslen;

            LPWCH got = GetEnvironmentStringsW();
            LPWCH next = got;
            size_t offset;

            while ((offset = wcslen(next)) > 0 && !result) {
                String_UTF8 current = String_UTF8(next[0 .. offset]), key = current[0 .. current.indexOf("=")],
                    value = current[key.length + 1 .. $];

                if (!key.isNull)
                    result = del(key, value);

                next += offset + 1;
            }

            FreeEnvironmentStringsW(got);
        } else version (Posix) {
            import core.stdc.string : strlen;
            import core.sys.posix.unistd : environ;

            char** envir = environ;

            while (*envir !is null && !result) {
                size_t length = strlen(*envir);

                String_UTF8 current = String_UTF8((*envir)[0 .. length]), key = current[0 .. current.indexOf("=")],
                    value = current[key.length + 1 .. $];

                if (!key.isNull)
                    result = del(key, value);

                envir++;
            }
        } else
            static assert(0, "Unimplemented");

        return result;
    }
}

///
unittest {
    foreach (arg; EnvironmentVariables) {
        assert(arg != "SideroBaseTextEnv");
    }

    assert(EnvironmentVariables[String_UTF8("SideroBaseTextEnv")].isNull);

    EnvironmentVariables[String_UTF8("SideroBaseTextEnv")] = String_UTF8("hi");
    assert(EnvironmentVariables[String_UTF8("SideroBaseTextEnv")] == "hi");

    bool found;
    foreach (key, value; EnvironmentVariables) {
        if (key == "SideroBaseTextEnv") {
            assert(!found);
            found = true;

            assert(value == "hi");
        }
    }
    assert(found);

    EnvironmentVariables[String_ASCII("SideroBaseTextEnv")] = String_ASCII();
    assert(EnvironmentVariables[String_ASCII("SideroBaseTextEnv")].isNull);
}

/// Has a terminating path seperator
String_UTF8 currentWorkingDirectory() @trusted {
    import sidero.base.allocators.api;
    import core.stdc.string : strlen;

    RCAllocator allocator = globalAllocator();

    version (Windows) {
        import core.sys.windows.winbase : GetCurrentDirectoryW;
        import core.sys.windows.winnt : LPWSTR;

        for (;;) {
            auto length = GetCurrentDirectoryW(0, cast(LPWSTR)null);
            wchar[] buffer = allocator.makeArray!wchar(length + 1);

            auto length2 = GetCurrentDirectoryW(cast(uint)buffer.length, cast(LPWSTR)buffer.ptr);

            if (length2 + 1 == length) {
                if (buffer[length2] != PathSeperator) {
                    buffer[length2] = PathSeperator;
                    length2++;
                    buffer[length2] = '\0';
                }

                return String_UTF8(buffer[0 .. length2], allocator, buffer);
            } else {
                allocator.dispose(buffer);
            }
        }
    } else version (Posix) {
        import core.sys.posix.unistd : getcwd;

        size_t bufferLength = 255;
        char[] buffer = allocator.makeArray!char(bufferLength);

        for (;;) {
            auto got = getcwd(buffer.ptr, buffer.length);

            if (got is null) {
                bufferLength += 256;

                if (allocator.reallocate(buffer, bufferLength - 2))
                    continue;

                allocator.dispose(buffer);
                buffer = allocator.makeArray!char(bufferLength);
                continue;
            }

            size_t length = strlen(got);

            if (got[length] != PathSeperator) {
                got[length] = PathSeperator;
                length++;
                got[length] = '\0';
            }

            return String_UTF8(got[0 .. length], allocator, buffer);
        }
    } else
        static assert(0, "Unimplemented");
}

///
void currentWorkingDirectory(scope String_ASCII value) @trusted {
    if (value.isNull)
        return;
    else if (!value.isPtrNullTerminated)
        value = value.dup();

    version (Windows) {
        import core.sys.windows.winbase : SetCurrentDirectoryA;

        SetCurrentDirectoryA(cast(char*)value.ptr);
    } else version (Posix) {
        import core.sys.posix.unistd : chdir;

        chdir(cast(char*)value.ptr);
    } else
        static assert(0, "Unimplemented");
}

///
unittest {
    assert(!currentWorkingDirectory().isNull);
    assert(currentWorkingDirectory().endsWith([PathSeperator]));
    currentWorkingDirectory = String_ASCII();
}

///
void currentWorkingDirectory(Input)(scope Input value) @trusted if (isUTFBuilder!Input) {
    version (Windows) {
        currentWorkingDirectory(value.byUTF16.asReadOnly);
    } else {
        currentWorkingDirectory(value.byUTF8.asReadOnly);
    }
}

///
void currentWorkingDirectory(Input)(scope Input value) @trusted if (isUTFReadOnly!Input) {
    if (value.isNull)
        return;

    version (Windows) {
        import core.sys.windows.winbase : SetCurrentDirectoryW;

        String_UTF16 toUse = value.byUTF16;

        if (!toUse.isPtrNullTerminated || toUse.isEncodingChanged)
            toUse = toUse.dup();

        SetCurrentDirectoryW(cast(wchar*)toUse.ptr);
    } else version (Posix) {
        import core.sys.posix.unistd : chdir;

        static if (is(Char == char)) {
            String_UTF8 toUse = value;
        } else {
            String_UTF8 toUse = value.byUTF8;
        }

        if (!toUse.isPtrNullTerminated || toUse.isEncodingChanged)
            toUse = toUse.dup();

        chdir(cast(char*)toUse.ptr);
    } else
        static assert(0, "Unimplemented");
}

///
unittest {
    assert(!currentWorkingDirectory().isNull);
    assert(currentWorkingDirectory().endsWith([PathSeperator]));
    currentWorkingDirectory = String_UTF8();
}

///
Slice!String_UTF8 commandLineArguments() @trusted {
    return _commandLineArguments;
}

///
struct Locale {
export:
    ///
    this(return scope ref Locale other) scope @safe nothrow @nogc {
        this.tupleof = other.tupleof;
    }

    ///
    String_UTF8 full;
    ///
    String_UTF8 language;
    /// I.e. country
    String_UTF8 territory;

    ///
    UnicodeLanguage unicodeLanguage;
}

///
Locale locale(bool refresh = false) @trusted {
    initMutex.pureLock;

    Locale locale = getLocaleImpl(refresh);

    if (refresh && !isUnicodeLanguageOverridden)
        handleUnicodeLanguage;

    initMutex.unlock;
    return locale;
}

///
void locale(String_UTF8 specifier) @trusted {
    initMutex.pureLock;

    Locale locale;
    locale.full = specifier;

    handleLocale(locale);

    initMutex.unlock;
}

///
UnicodeLanguage unicodeLanguage() @trusted {
    static int reentrantCall; // TLS check for reentrant nature

    reentrantCall++;
    UnicodeLanguage ret = UnicodeLanguage.Unknown;

    if (reentrantCall == 1) {
        initMutex.pureLock;

        if (!haveGlobalLocale && !isUnicodeLanguageOverridden)
            handleUnicodeLanguage;

        ret = _unicodeLanguage;
        initMutex.unlock;
    }

    reentrantCall--;
    return ret;
}

///
void unicodeLanguage(UnicodeLanguage language) @trusted {
    initMutex.pureLock;

    isUnicodeLanguageOverridden = true;
    _unicodeLanguage = language;

    initMutex.unlock;
}

/// Initializes system info
pragma(crt_constructor) extern (C) void initializeSystemInfo() @trusted {
    import sidero.base.containers.dynamicarray;
    import core.stdc.string : strlen;
    import core.stdc.wchar_ : wcslen;

    initMutex.lock;
    DynamicArray!String_UTF8 ret = DynamicArray!String_UTF8(0);

    scope (exit) {
        _commandLineArguments = ret.asReadOnly;
        initMutex.unlock;
    }

    void handle(String_UTF8 arg) {
        if (!arg.isPtrNullTerminated)
            arg = arg.dup;

        ret ~= arg;
    }

    version (Posix) {
        import core.stdc.stdio : FILE, fopen, fclose, fread;

        enum FilePath = "/proc/self/cmdline";
        FILE* file = fopen(FilePath, "rb");

        if (file !is null) {
            StringBuilder_UTF8 temp = StringBuilder_UTF8(globalAllocator());

            size_t length, length2;
            char[100] buffer;

            while ((length = fread(buffer.ptr, 1, buffer.length, file)) > 0) {
                char[] wasRead = buffer[length];

                while ((length2 = strlen(wasRead.ptr)) > 0) {
                    char[] current = wasRead[0 .. length2];

                    temp ~= current;

                    if (length2 == wasRead.length) {
                        // we didn't max out
                    } else {
                        // we maxed out so we're done for this one.
                        handle(temp.asReadOnly);
                        temp.clear;
                    }

                    wasRead = wasRead[length2 .. $];
                }
            }

            if (temp.length > 0)
                handle(temp.asReadOnly);

            fclose(file);
        }
    } else version (Windows) {
        import core.sys.windows.winbase : GetCommandLineW;

        wchar* got = GetCommandLineW();
        wchar[] temp = got[0 .. wcslen(got)];

        while (temp.length > 0) {
            size_t length;
            char delim = ' ';

            foreach (wchar c; temp) {
                if (c == ' ' || c == '\t')
                    length++;
                else
                    break;
            }

            temp = temp[length .. $];

            if (temp.length > 0) {
                if (temp[0] == '"')
                    delim = '"';

                length = 0;
                foreach (wchar c; temp) {
                    length++;
                    if (c == delim)
                        break;
                }

                wchar[] current = temp[0 .. length];
                temp = temp[length .. $];

                if (delim == '"' && length >= 2) {
                    current = current[1 .. $];
                    if (current[$ - 1] == '"')
                        current = current[0 .. $ - 1];
                }

                handle(String_UTF8(cast(wstring)current));
            }
        }
    } else
        static assert(0, "Unimplemented getting command line arguments");
}

private @hidden:
import sidero.base.parallelism.mutualexclusion : TestTestSetLockInline;

enum {
    LOCALE_NAME_MAX_LENGTH = 85
}

version (Windows) {
    import core.sys.windows.winnt : LPWSTR;

    extern (Windows) int GetUserDefaultLocaleName(LPWSTR, int);
}

__gshared {
    TestTestSetLockInline initMutex;

    Locale globalLocale;
    bool haveGlobalLocale;

    UnicodeLanguage _unicodeLanguage;
    bool isUnicodeLanguageOverridden;

    Slice!String_UTF8 _commandLineArguments;
}

Locale getLocaleImpl(ref bool refresh) @trusted {
    Locale locale;

    if (!refresh) {
        if (!haveGlobalLocale) {
            refresh = true;
        } else {
            locale = globalLocale;
        }
    }

    if (refresh) {
        locale.full = EnvironmentVariables[String_UTF8("LANG")];

        if (locale.full.isNull) {
            version (Windows) {
                wchar[LOCALE_NAME_MAX_LENGTH] buffer = void;
                auto length = GetUserDefaultLocaleName(buffer.ptr, cast(int)buffer.length);

                locale.full = String_UTF8(buffer[0 .. length]).dup;
            } else version (Posix) {
                import core.stdc.locale : setlocale, LC_ALL;
                import core.stdc.string : strlen;

                char* sl = setlocale(LC_ALL, null);
                size_t length = strlen(sl);

                if (sl !is null && length > 0) {
                    String_UTF8 actualC = String_UTF8(sl[0 .. length]);

                    if (actualC != "C" && actualC != "POSIX")
                        locale.full = actualC.dup;
                }
            }
        }

        handleLocale(locale);
    }

    return locale;
}

UnicodeLanguage unicodeLanguageFromLocale(ref Locale locale) {
    static assert(__traits(allMembers, UnicodeLanguage).length == 4, "Update UnicodeLanguage detection from environment");

    if (locale.language == "lt" || locale.language == "lit")
        return UnicodeLanguage.Lithuanian;
    else if (locale.language == "tr" || locale.language == "tur")
        return UnicodeLanguage.Turkish;
    else if (locale.language == "az" || locale.language == "aze")
        return UnicodeLanguage.Azeri;
    else
        return UnicodeLanguage.Unknown;
}

void handleUnicodeLanguage() @trusted {
    bool refreshed;
    Locale locale = getLocaleImpl(refreshed);

    _unicodeLanguage = locale.unicodeLanguage;
}

void handleLocale(ref Locale locale) @trusted {
    // just guess if we don't have anything in environment to know from
    if (locale.full.isNull)
        locale.full = String_UTF8("en");

    auto soFar = locale.full;

    ptrdiff_t offsetTerritory1 = soFar.indexOf("_"), offsetTerritory2 = soFar.indexOf("-"),
        offsetCodeset = soFar.indexOf("."), offsetModifier = soFar.indexOf("@");

    if (offsetTerritory1 >= 0)
        locale.language = soFar[0 .. offsetTerritory1];
    else if (offsetTerritory2 >= 0)
        locale.language = soFar[0 .. offsetTerritory2];
    else if (offsetCodeset >= 0)
        locale.language = soFar[0 .. offsetCodeset];
    else if (offsetModifier >= 0)
        locale.language = soFar[0 .. offsetModifier];
    else
        locale.language = soFar;

    soFar = soFar[locale.language.length > 0 ? locale.language.length: 0 .. $];
    if (soFar.length > 0)
        soFar = soFar[1 .. $];

    offsetCodeset = soFar.indexOf(".");
    offsetModifier = soFar.indexOf("@");

    if (offsetCodeset >= 0)
        locale.territory = soFar[0 .. offsetCodeset];
    else if (offsetModifier >= 0)
        locale.territory = soFar[0 .. offsetModifier];
    else
        locale.territory = soFar;

    locale.unicodeLanguage = unicodeLanguageFromLocale(locale);

    globalLocale = locale;
    haveGlobalLocale = true;
}
