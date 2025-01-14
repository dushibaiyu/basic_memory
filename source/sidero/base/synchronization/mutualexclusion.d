/*
Mutal exclusion, locks for thread consistency.

License: Artistic v2
Authors: Richard (Rikki) Andrew Cattermole
Copyright: 2022 Richard Andrew Cattermole
*/
module sidero.base.synchronization.mutualexclusion;
import sidero.base.attributes;
import sidero.base.internal.atomic;

export:

///
struct TestTestSetLockInline {
    private @PrettyPrintIgnore shared(bool) state;

    //@disable this(this);

export @safe @nogc nothrow:
pure:

    /// A much more limited lock method, that is pure.
    void pureLock() scope {
        for(;;) {
            if(atomicLoad(state))
                atomicFence();

            if(cas(state, false, true))
                return;
        }
    }

    ///
    bool tryLock() scope {
        return cas(state, false, true);
    }

    ///
    void unlock() scope {
        atomicStore(state, false);
    }
}
