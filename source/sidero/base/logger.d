module sidero.base.logger;
import sidero.base.text;
import sidero.base.attributes;
import sidero.base.allocators;
import sidero.base.errors;
import sidero.base.console;

export @safe nothrow @nogc:

///
enum LoggingTargets : uint {
    /// Default
    None = 0,
    ///
    Console = 1,
    ///
    File = 1 << 1,
    /// Posix, requires some sort of syslog
    Syslog = 1 << 2,
    /// Windows events
    Windows = 1 << 3,
    ///
    Custom = 1 << 4,

    ///
    All = Console | File | Syslog | Windows | Custom,
}

///
enum LogLevel {
    /// Outputs everything
    Trace,
    /// Default, will only output info/warning/error/critical/fatal
    Info,
    /// Will only output warning/error/critical/fatal
    Warning,
    /// Will only output error/critical/fatal
    Error,
    /// Will only output critical/fatal
    Critical,
    /// Will only output fatal; this should (but won't) end the program
    Fatal,
}

///
enum LogRotateFrequency {
    ///
    None,
    ///
    OnStart,
    ///
    Hourly,
    ///
    Daily,
}

///
alias CustomTargetMessage = void delegate(LogLevel level, String_UTF8 dateTime, String_UTF8[2] moduleLine,
        String_UTF8 tags, String_UTF8 levelText, String_UTF8 composite) @safe nothrow @nogc;
///
alias CustomTargetOnRemove = void delegate() @safe nothrow @nogc;

///
alias LoggerReference = ResultReference!Logger;

///
struct Logger {
    private @PrettyPrintIgnore {
        import sidero.base.containers.dynamicarray;
        import sidero.base.internal.meta;

        RCAllocator allocator;
        String_UTF8 name_;

        ubyte[TestTestSetLockInline.sizeof] mutexStorage;
        LogLevel logLevel;
        uint targets;

        String_UTF8 dateTimeFormat;
        String_UTF8 tags;

        ConsoleTarget consoleTarget;
        FileTarget fileTarget;
        DynamicArray!CustomTarget customTargets;

        ref TestTestSetLockInline mutex() scope return nothrow @nogc {
            return *cast(TestTestSetLockInline*)mutexStorage.ptr;
        }

        static int opApplyImpl(Del)(scope Del del) @trusted {
            int result;

            auto getLoggers() @trusted nothrow @nogc {
                return loggers;
            }

            static if (__traits(compiles, { LoggerReference lr; del(lr); })) {
                result = getLoggers.opApply(del);
            } else {
                int handle()(ref ResultReference!String_UTF8 k, ref LoggerReference v) {
                    assert(k);
                    String_UTF8 tempKey = k;

                    return del(tempKey, v);
                }

                result = getLoggers.opApply(&handle!());
            }

            return result;
        }
    }

export:

    static {
        ///
        mixin OpApplyCombos!("LoggerReference", "String_UTF8", ["@safe", "nothrow", "@nogc"], "opApply", "opApplyImpl", true);
    }

@safe nothrow @nogc:

    this(return scope ref Logger other) scope {
        this.tupleof = other.tupleof;
        assert(this.name_.isNull, "Don't copy the Logger around directly, use it only by the LoggerReference");
    }

    ///
    String_UTF8 name() scope @trusted {
        return this.name_;
    }

    ///
    void setLevel(LogLevel level) scope {
        mutex.pureLock;
        logLevel = level;
        mutex.unlock;
    }

    /// See_Also: LoggingTargets
    void setTargets(uint targets = LoggingTargets.None) scope {
        mutex.lock;
        this.targets = targets;
        mutex.unlock;
    }

    ///
    void setTags(scope return String_UTF8 tags) scope {
        mutex.lock;
        this.tags = tags;
        mutex.unlock;
    }

    ///
    void setTags(scope return String_UTF16 tags) scope {
        this.setTags(tags.byUTF8);
    }

    ///
    void setTags(scope return String_UTF32 tags) scope {
        this.setTags(tags.byUTF8);
    }

    ///
    String_UTF8 toString() scope {
        return this.name;
    }

    ///
    static LoggerReference forName(return scope String_UTF8 name, return scope RCAllocator allocator = RCAllocator.init) @trusted {
        if (name.length == 0)
            return typeof(return)(MalformedInputException("Name must not be empty"));

        mutexForCreation.pureLock;

        LoggerReference ret = loggers[name];
        if (ret) {
            mutexForCreation.unlock;
            return ret;
        }

        if (allocator.isNull)
            allocator = globalAllocator();

        if (loggers.isNull) {
            loggers = ConcurrentHashMap!(String_UTF8, Logger)(globalAllocator());
            loggers.cleanupUnreferencedNodes;
        }

        loggers[name] = Logger.init;
        ret = loggers[name];
        assert(ret);
        ret.allocator = allocator;
        ret.name_ = name;
        ret.dateTimeFormat = GDateTime.ISO8601Format;
        ret.logLevel = LogLevel.Info;

        mutexForCreation.unlock;
        return ret;
    }

    ///
    void trace(string moduleName = __MODULE__, int line = __LINE__, Args...)(Args args) scope {
        if (logLevel > LogLevel.Trace)
            return;

        mutex.pureLock;
        message!(moduleName, line)(LogLevel.Trace, args);
        mutex.unlock;
    }

    ///
    void info(string moduleName = __MODULE__, int line = __LINE__, Args...)(Args args) scope {
        if (logLevel > LogLevel.Warning)
            return;

        mutex.pureLock;
        message!(moduleName, line)(LogLevel.Info, args);
        mutex.unlock;
    }

    ///
    void warning(string moduleName = __MODULE__, int line = __LINE__, Args...)(Args args) scope {
        if (logLevel > LogLevel.Warning)
            return;

        mutex.pureLock;
        message!(moduleName, line)(LogLevel.Warning, args);
        mutex.unlock;
    }

    ///
    void error(string moduleName = __MODULE__, int line = __LINE__, Args...)(Args args) scope {
        if (logLevel > LogLevel.Error)
            return;

        mutex.pureLock;
        message!(moduleName, line)(LogLevel.Error, args);
        mutex.unlock;
    }

    ///
    void critical(string moduleName = __MODULE__, int line = __LINE__, Args...)(Args args) scope {
        if (logLevel > LogLevel.Critical)
            return;

        mutex.pureLock;
        message!(moduleName, line)(LogLevel.Critical, args);
        mutex.unlock;
    }

    ///
    void fatal(string moduleName = __MODULE__, int line = __LINE__, Args...)(Args args) scope {
        mutex.pureLock;
        message!(moduleName, line)(LogLevel.Fatal, args);
        mutex.unlock;
    }

private:
    void message(string moduleName, int line, Args...)(LogLevel level, Args args) scope {
        import sidero.base.datetime.time.clock;
        import std.conv : text;

        StringBuilder_UTF8 dateTimeText = accurateDateTime().format(this.dateTimeFormat);
        enum ModuleLine = " `" ~ moduleName ~ ":" ~ line.text ~ "` ";

        static immutable LevelTag = [
            "TRACE", "INFO", "WARNING", "ERROR", "CRITICAL", "FATAL", " TRACE", " INFO", " WARNING", " ERROR", " CRITICAL",
            " FATAL"
        ];

        void handleConsole() {
            import sidero.base.console;

            auto fg = consoleTarget.consoleColors[level][0], bg = consoleTarget.consoleColors[level][1];

            writeln(resetDefaultBeforeApplying().deliminateArgs(false).prettyPrintingActive(true).foreground(fg)
                    .background(bg).useErrorStream(consoleTarget.useErrorStream[level]), dateTimeText, ModuleLine,
                    tags, LevelTag[level + (tags.isNull ? 0 : 6)], resetDefaultBeforeApplying(), ": ", args, resetDefaultBeforeApplying());
        }

        if (targets & LoggingTargets.Console)
            handleConsole;

    }
}

pragma(crt_destructor) extern (C) void deinitializeLogging() @trusted {
    version (Posix) {
        import core.sys.posix.syslog : closelog;

        if (haveSysLog) {
            closelog;
            haveSysLog = false;
        }
    } else version (Windows) {
        import core.sys.windows.windows : DeregisterEventSource;

        if (windowsEventHandle !is null) {
            DeregisterEventSource(windowsEventHandle);
            windowsEventHandle = null;
        }
    }
}

private:
import sidero.base.containers.map.concurrenthashmap;
import sidero.base.parallelism.mutualexclusion : TestTestSetLockInline;
import sidero.base.internal.filesystem;
import sidero.base.datetime;

__gshared {
    TestTestSetLockInline mutexForCreation;
    ConcurrentHashMap!(String_UTF8, Logger) loggers;
}

struct ConsoleTarget {
    ConsoleColor[2][6] consoleColors = [
        [ConsoleColor.Yellow, ConsoleColor.Unknown], [ConsoleColor.Green, ConsoleColor.Unknown],
        [ConsoleColor.Magenta, ConsoleColor.Unknown], [ConsoleColor.Red, ConsoleColor.Yellow],
        [ConsoleColor.Red, ConsoleColor.Cyan], [ConsoleColor.Red, ConsoleColor.Blue],
    ];
    bool[6] useErrorStream = [false, false, false, true, true, true];
}

struct FileTarget {
    String_UTF8 rootLogDirectory;

    GDate logRotateLastDate;
    LogRotateFrequency logRotateFrequency;

    FileAppender logStream;

@safe nothrow @nogc:

    this(return scope ref FileTarget other) scope {
    }
}

struct CustomTarget {
    CustomTargetMessage messageDel;
    CustomTargetOnRemove onRemoveDel;

@safe nothrow @nogc:

     ~this() scope {
        if (onRemoveDel !is null)
            onRemoveDel();
    }
}

__gshared {
    String_UTF8 processName;
    bool haveSysLog;
}

version (Windows) {
    import core.sys.windows.windows : HANDLE;

    __gshared HANDLE windowsEventHandle;
} else version (Posix) {
    import core.sys.posix.syslog : LOG_DEBUG, LOG_INFO, LOG_NOTICE, LOG_WARNING, LOG_ERR;

    static PrioritySyslogForLevels = [LOG_DEBUG, LOG_INFO, LOG_NOTICE, LOG_WARNING, LOG_ERR, LOG_ERR];
}
