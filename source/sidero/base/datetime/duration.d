module sidero.base.datetime.duration;
import sidero.base.text;
import sidero.base.traits;
import sidero.base.attributes;

export @safe nothrow @nogc:

///
struct Duration {
    private @PrettyPrintIgnore {
        enum NanoSecondsInDay = 24 * 60 * 60 * 1_000_000_000L;
        long days_;
        long nanoSeconds_;
    }

    ///
    static immutable string DefaultFormat = "%a", HumanDeltaFormat = "%D";

export @safe nothrow @nogc:

    ///
    this(long day, long nanoSecond) {
        Duration temp = day.days + nanoSecond.nanoSeconds;
        days_ = temp.days_;
        nanoSeconds_ = temp.nanoSeconds_;
    }

    ///
    long days() scope const {
        return this.days_;
    }

    ///
    long nanoSeconds() scope const {
        return this.nanoSeconds_ - (this.totalMicroSeconds * 1_000);
    }

    ///
    long microSeconds() scope const {
        return (this.nanoSeconds_ - (this.totalMilliSeconds * 1_000_000)) / 1_000;
    }

    ///
    long milliSeconds() scope const {
        return (this.nanoSeconds_ - (this.totalSeconds * 1_000_000_000)) / 1_000_000;
    }

    ///
    long seconds() scope const {
        return (this.nanoSeconds_ - (this.totalMinutes * 60_000_000_000)) / 1_000_000_000;
    }

    ///
    long minutes() scope const {
        return (this.nanoSeconds_ - (this.totalHours * 3_600_000_000_000)) / 60_000_000_000;
    }

    ///
    long hours() scope const {
        return this.nanoSeconds_ / 3_600_000_000_000;
    }

    ///
    long totalNanoSeconds() scope const {
        return this.nanoSeconds_;
    }

    ///
    long totalMicroSeconds() scope const {
        return this.nanoSeconds_ / 1_000;
    }

    ///
    long totalMilliSeconds() scope const {
        return this.nanoSeconds_ / 1_000_000;
    }

    ///
    long totalSeconds() scope const {
        return this.nanoSeconds_ / 1_000_000_000;
    }

    ///
    long totalMinutes() scope const {
        return this.nanoSeconds_ / 60_000_000_000;
    }

    ///
    long totalHours() scope const {
        return this.nanoSeconds_ / 3_600_000_000_000;
    }

    ///
    Duration opUnary(string op : "-")() scope const {
        Duration temp = this;
        temp.days_ *= -1;
        temp.nanoSeconds_ *= -1;

        return temp;
    }

    ///
    Duration opBinary(string op : "+")(scope const Duration other) scope const {
        Duration temp = this;

        temp.days_ += other.days_;
        temp.nanoSeconds_ += other.nanoSeconds_;

        while (temp.nanoSeconds_ <= -NanoSecondsInDay) {
            temp.nanoSeconds_ -= NanoSecondsInDay;
            temp.days_--;
        }

        while (temp.nanoSeconds_ >= NanoSecondsInDay) {
            temp.nanoSeconds_ -= NanoSecondsInDay;
            temp.days_++;
        }

        return temp;
    }

    ///
    Duration opBinary(string op : "-")(scope const Duration other) scope const {
        Duration temp = other;
        temp.days_ *= -1;
        temp.nanoSeconds_ *= -1;

        return this + temp;
    }

    ///
    bool opEquals(scope const Duration other) scope const {
        return this.days_ == other.days_ && this.nanoSeconds_ == other.nanoSeconds_;
    }

    ///
    int opCmp(scope const Duration other) scope const {
        if (this.days_ < other.days_)
            return -1;
        else if (this.days_ > other.days_)
            return 1;

        if (this.nanoSeconds_ < other.nanoSeconds_)
            return -1;
        else if (this.nanoSeconds_ > other.nanoSeconds_)
            return 1;

        return 0;
    }

    ///
    String_UTF8 toString() scope const @trusted {
        StringBuilder_UTF8 ret;
        toString(ret);
        return ret.asReadOnly;
    }

    ///
    void toString(Builder)(scope ref Builder sink) scope const if (isBuilderString!Builder) {
        this.format(sink, DefaultFormat);
    }

    /// Supports R(sign +/-), r(sign +), d(ays), h(ours), m(inutes), s(econds), i(milliseconds), u(microseconds), n(anoseconds), a(daptive), Human D(elta)
    StringBuilder_UTF8 format(FormatString)(scope FormatString specification, bool usePercentageEscape = true) scope const
            if (isSomeString!FormatString) {
        StringBuilder_UTF8 ret;
        this.format(ret, specification, usePercentageEscape);
        return ret;
    }

    /// Ditto
    StringBuilder_UTF8 format(FormatChar)(scope String_UTF!FormatChar specification, bool usePercentageEscape = true) scope const {
        StringBuilder_UTF8 ret;
        this.format(ret, specification, usePercentageEscape);
        return ret;
    }

    /// Ditto
    void format(Builder, FormatString)(scope ref Builder builder, scope FormatString specification, bool usePercentageEscape = true) scope const @trusted
            if (isBuilderString!Builder && isSomeString!FormatString) {
        this.format(builder, String_UTF!(Builder.Char)(specification), usePercentageEscape);
    }

    /// Ditto
    void format(Builder, Format)(scope ref Builder builder, scope Format specification, bool usePercentageEscape = true) scope const @trusted
            if (isBuilderString!Builder && isReadOnlyString!Format) {
        import sidero.base.allocators;

        if (builder.isNull)
            builder = typeof(builder)(globalAllocator());

        bool isEscaped;

        if (usePercentageEscape) {
            foreach (c; specification.byUTF32()) {
                if (isEscaped) {
                    isEscaped = false;
                    if (this.formatValue(builder, c))
                        continue;
                } else if (c == '%') {
                    isEscaped = true;
                    continue;
                }

                builder ~= [c];
            }
        } else {
            foreach (c; specification.byUTF32()) {
                if (isEscaped) {
                    typeof(c)[1] str = [c];
                    builder ~= str;
                    isEscaped = false;
                } else if (c == '\\') {
                    isEscaped = true;
                } else if (this.formatValue(builder, c)) {
                } else {
                    builder ~= [c];
                }
            }
        }
    }

    /// Ditto
    bool formatValue(Builder)(scope ref Builder builder, dchar specification) scope const if (isBuilderString!Builder) {
        switch (specification) {
        case 'R':
            if (this.days_ < 0 || this.nanoSeconds_ < 0)
                builder ~= "-";
            else
                builder ~= "+";
            break;
        case 'r':
            if (this.days_ < 0 || this.nanoSeconds_ < 0)
                builder ~= "-";
            break;

        case 'a':
            if (this.days_ < 0 || this.nanoSeconds_ < 0)
                builder ~= "-";

            auto days = this.days, hours = this.hours, minutes = this.minutes, seconds = this.seconds,
                milliSecs = this.milliSeconds, microSecs = this.microSeconds, nanoSecs = this.nanoSeconds;

            if (days < 0)
                days *= -1;
            if (hours < 0)
                hours *= -1;
            if (minutes < 0)
                minutes *= -1;
            if (seconds < 0)
                seconds *= -1;
            if (milliSecs < 0)
                milliSecs *= -1;
            if (microSecs < 0)
                microSecs *= -1;
            if (nanoSecs < 0)
                nanoSecs *= -1;

            bool gotOne;

            if (days != 0) {
                gotOne = true;
                builder.formattedWrite("%s days", days);
            }

            if (hours != 0) {
                if (gotOne)
                    builder ~= " ";
                gotOne = true;
                builder.formattedWrite("%s hours", hours);
            }

            if (minutes != 0) {
                if (gotOne)
                    builder ~= " ";
                gotOne = true;
                builder.formattedWrite("%s minutes", minutes);
            }

            if (seconds != 0) {
                if (gotOne)
                    builder ~= " ";
                gotOne = true;
                builder.formattedWrite("%s seconds", seconds);
            }

            if (milliSecs != 0) {
                if (gotOne)
                    builder ~= " ";
                gotOne = true;
                builder.formattedWrite("%s milliseconds", milliSecs);
            }

            if (microSecs != 0) {
                if (gotOne)
                    builder ~= " ";
                gotOne = true;
                builder.formattedWrite("%s microseconds", microSecs);
            }

            if (nanoSecs != 0) {
                if (gotOne)
                    builder ~= " ";
                gotOne = true;
                builder.formattedWrite("%s nanoseconds", nanoSecs);
            }

            if (!gotOne) {
                builder ~= "0";
            }
            break;

        case 'd':
            builder.formattedWrite("%s", this.days_ < 0 ? -this.days_ : this.days_);
            break;

        case 'h':
            auto hours = this.hours;
            builder.formattedWrite("%s", hours < 0 ? -hours : hours);
            break;
        case 'm':
            auto minutes = this.minutes;
            builder.formattedWrite("%s", minutes < 0 ? -minutes : minutes);
            break;
        case 's':
            auto seconds = this.seconds;
            builder.formattedWrite("%s", seconds < 0 ? -seconds : seconds);
            break;
        case 'i':
            auto milliSecs = this.milliSeconds;
            builder.formattedWrite("%s", milliSecs < 0 ? -milliSecs : milliSecs);
            break;
        case 'u':
            auto microSecs = this.microSeconds;
            builder.formattedWrite("%s", microSecs < 0 ? -microSecs : microSecs);
            break;
        case 'n':
            auto nanoSecs = this.nanoSeconds;
            builder.formattedWrite("%s", nanoSecs < 0 ? -nanoSecs : nanoSecs);
            break;

        case 'D':
            const years = cast(long)(this.days_ / 365.25);

            if (years != 0) {
                if (this.days_ < 0)
                    builder.formattedWrite("%s years ago", -years);
                else
                    builder.formattedWrite("in %s years", years);
            } else if (this.days_ != 0) {
                if (this.days_ < 0)
                    builder.formattedWrite("%s days ago", -this.days_);
                else
                    builder.formattedWrite("in %s days", this.days_);
            } else {
                auto hours = this.hours;
                auto minutes = this.minutes;

                if (hours != 0) {
                    if (this.nanoSeconds_ < 0)
                        builder.formattedWrite("%s hours ago", -hours);
                    else
                        builder.formattedWrite("in %s hours", hours);
                } else if (minutes != 0) {
                    if (this.nanoSeconds_ < 0)
                        builder.formattedWrite("%s minutes ago", -minutes);
                    else
                        builder.formattedWrite("in %s minutes", minutes);
                } else if (this.nanoSeconds_ < 0) {
                    builder ~= "less than a minute ago";
                } else {
                    builder ~= "in less than a minute";
                }
            }
            break;

        default:
            return false;
        }

        return true;
    }

    ///
    unittest {
        assert(.days(2922).format(HumanDeltaFormat) == "in 8 years");
        assert(.days(-1461).format(HumanDeltaFormat) == "4 years ago");
        assert(.days(8L).format(HumanDeltaFormat) == "in 8 days");
        assert(.days(-5L).format(HumanDeltaFormat) == "5 days ago");
        assert(.hours(3).format(HumanDeltaFormat) == "in 3 hours");
        assert(.hours(-2).format(HumanDeltaFormat) == "2 hours ago");
        assert(.minutes(5).format(HumanDeltaFormat) == "in 5 minutes");
        assert(.minutes(-6).format(HumanDeltaFormat) == "6 minutes ago");
        assert(.seconds(32).format(HumanDeltaFormat) == "in less than a minute");
        assert(.seconds(-21).format(HumanDeltaFormat) == "less than a minute ago");
    }

    ///
    bool formattedWrite(scope ref StringBuilder_ASCII builder, scope FormatSpecifier format) @safe nothrow @nogc {
        return false;
    }

    ///
    bool formattedWrite(scope ref StringBuilder_UTF8 builder, scope FormatSpecifier format) @safe nothrow @nogc {
        if (format.fullFormatSpec.length == 0)
            return false;

        this.format(builder, format.fullFormatSpec);
        return true;
    }

    ///
    static Duration zero() {
        return Duration.init;
    }

    ///
    static Duration min() {
        Duration temp;
        temp.days_ = long.min;
        temp.nanoSeconds_ = (-NanoSecondsInDay) + 1;
        return temp;
    }

    ///
    static Duration max() {
        Duration temp;
        temp.days_ = long.max;
        temp.nanoSeconds_ = NanoSecondsInDay - 1;
        return temp;
    }
}

///
Duration days(long amount) {
    Duration ret;
    ret.days_ = amount;
    return ret;
}

///
Duration hours(long amount) {
    Duration temp;
    temp.nanoSeconds_ = amount * 3_600_000_000_000;
    return Duration.init + temp;
}

///
Duration minutes(long amount) {
    Duration temp;
    temp.nanoSeconds_ = amount * 60_000_000_000;
    return Duration.init + temp;
}

///
Duration seconds(long amount) {
    Duration temp;
    temp.nanoSeconds_ = amount * 1_000_000_000;
    return Duration.init + temp;
}

///
Duration milliSeconds(long amount) {
    Duration temp;
    temp.nanoSeconds_ = amount * 1_000_000;
    return Duration.init + temp;
}

///
Duration microSeconds(long amount) {
    Duration temp;
    temp.nanoSeconds_ = amount * 1_000;
    return Duration.init + temp;
}

///
Duration nanoSeconds(long amount) {
    Duration temp;
    temp.nanoSeconds_ = amount;
    return Duration.init + temp;
}
