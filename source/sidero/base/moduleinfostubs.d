module sidero.base.moduleinfostubs;
version (D_BetterC)  : static foreach (Stub; Stubs) {
    mixin(() {
        import std.format : format;

        string ret = "export extern(C) void " ~ Stub.mangleName ~ "() { asm { naked; ";

        void add(ubyte b) {
            ret ~= "db 0x";

            ubyte temp = b & 0xF;
            if (temp > 9)
                ret ~= 'A' + (temp - 10);
            else
                ret ~= '0' + temp;

            temp = (b >> 4) & 0xF;
            if (temp > 9)
                ret ~= 'A' + (temp - 10);
            else
                ret ~= '0' + temp;

            ret ~= ";";
        }

        add(MIname & 0xFF);
        add((MIname >> 8) & 0xFF);
        add(0);
        add(0);

        add(0);
        add(0);
        add(0);
        add(0);

        foreach (c; Stub.moduleName) {
            add(c);
        }
        add(0);

        return ret ~ "}\n}\n";
    }());
}

private:
struct ModuleInfoStub {
    string mangleName;
    string moduleName;
}

enum Stubs = [
        ModuleInfoStub("_D6sidero4base10allocators2gc12__ModuleInfoZ", "sidero.base.allocators.gc"),
        ModuleInfoStub("_D6sidero4base10allocators12__ModuleInfoZ", "sidero.base.allocators"),
        ModuleInfoStub("_D6sidero4base10allocators3api12__ModuleInfoZ", "sidero.base.allocators.api"),
        ModuleInfoStub("_D6sidero4base7console12__ModuleInfoZ", "sidero.base.console"),
        ModuleInfoStub("_D6sidero4base6traits12__ModuleInfoZ", "sidero.base.traits"),
        ModuleInfoStub("_D6sidero4base4text6format12__ModuleInfoZ", "sidero.base.text.format"),
        ModuleInfoStub("_D6sidero4base6errors12__ModuleInfoZ",
                "sidero.base.errors"),
        ModuleInfoStub("_D6sidero4base10containers13readonlyslice12__ModuleInfoZ",
                "sidero.base.containers.readonlyslice"),
        ModuleInfoStub("_D6sidero4base4math14linear_algebra12__ModuleInfoZ",
                "sidero.base.math.linear_algebra"),
        ModuleInfoStub("_D6sidero4base6errors6result__T6ResultTvZQk9__xtoHashFNbNeKxSQChQCdQCbQBx__TQBtTvZQBzZm",
                "sidero.base.errors.result"),
        ModuleInfoStub("_D6sidero4base4hash5utils12__ModuleInfoZ", "sidero.base.hash.utils"),
        ModuleInfoStub("_D6sidero4base4hash3fnv12__ModuleInfoZ", "sidero.base.hash.fnv"),
        ModuleInfoStub("_D6sidero4base9algorithm12__ModuleInfoZ", "sidero.base.algorithm"),
        ModuleInfoStub("_D6sidero4base4text12__ModuleInfoZ", "sidero.base.text")
    ];
