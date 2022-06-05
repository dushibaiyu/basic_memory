/**
Rounds up memory allocation sizes based upon a size.

License: Artistic v2
Authors: Richard (Rikki) Andrew Cattermole
Copyright: 2022 Richard Andrew Cattermole
 */
module sidero.base.memory.allocators.alternatives.quantizer;
import std.typecons : Ternary;

private {
    import sidero.base.memory.allocators.api;

    alias QRC = Quantizer!(RCAllocator, length => length * 2);
}

/**
    Applies rounding (up) function to all sizes provided, but will not return it complete.
 */
struct Quantizer(PoolAllocator, alias roundFunction) {
    ///
    PoolAllocator poolAllocator;

    static if (__traits(hasMember, PoolAllocator, "NeedsLocking")) {
        ///
        enum NeedsLocking = PoolAllocator.NeedsLocking;
    } else {
        ///
        enum NeedsLocking = false;
    }

scope @safe @nogc pure nothrow:

    this(scope return ref Quantizer other) @trusted {
        this.tupleof = other.tupleof;
        other = Quantizer.init;
    }

    ///
    bool isNull() const {
        return poolAllocator.isNull;
    }

    ///
    void[] allocate(size_t size, TypeInfo ti = null) {
        if (isNull)
            return null;
        else {
            void[] ret = poolAllocator.allocate(roundFunction(size), ti);
            return ret[0 .. size];
        }
    }

    ///
    bool reallocate(scope ref void[] array, size_t newSize) {
        if (!isNull && poolAllocator.reallocate(array, roundFunction(newSize))) {
            array = array[0 .. newSize];
            return true;
        } else
            return false;
    }

    ///
    bool deallocate(scope void[] array) {
        if (isNull)
            return false;
        else
            return poolAllocator.deallocate(array);
    }

    static if (__traits(hasMember, PoolAllocator, "owns")) {
        ///
        Ternary owns(scope void[] array) {
            if (isNull)
                return Ternary.no;
            else
                return poolAllocator.owns(array);
        }
    }

    static if (__traits(hasMember, PoolAllocator, "deallocateAll")) {
        ///
        bool deallocateAll() {
            if (isNull)
                return false;
            else
                return poolAllocator.deallocateAll();
        }
    }

    static if (__traits(hasMember, PoolAllocator, "empty")) {
        ///
        bool empty() {
            if (isNull)
                return true;
            else
                return poolAllocator.empty();
        }
    }
}
