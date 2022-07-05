module sidero.base.internal.unicode.specialcasing;

// Generated do not modify
export extern(C) immutable(void*) sidero_utf_lut_getSpecialCasing2None(dchar input) @trusted nothrow @nogc pure {
    if (input >= 0xDF && input <= 0x1FFC) {
        if (input == 0xDF)
            return cast(void*)&LUT_7F14197C[0 + (input - 223)];
        else if (input >= 0x130 && input <= 0x149)
            return cast(void*)&LUT_7F14197C[1 + (input - 304)];
        else if (input == 0x1F0)
            return cast(void*)&LUT_7F14197C[27 + (input - 496)];
        else if (input >= 0x390 && input <= 0x3B0)
            return cast(void*)&LUT_7F14197C[28 + (input - 912)];
        else if (input == 0x587)
            return cast(void*)&LUT_7F14197C[61 + (input - 1415)];
        else if (input >= 0x1E96 && input <= 0x1E9A)
            return cast(void*)&LUT_7F14197C[62 + (input - 7830)];
        else if (input >= 0x1F50)
            return cast(void*)&LUT_7F14197C[67 + (input - 8016)];
    } else if (input >= 0xFB00 && input <= 0xFB17) {
        return cast(void*)&LUT_7F14197C[240 + (input - 64256)];
    }
    return null;
}
private {
    static immutable LUT_7F14197C = [Ca(null, LUT_7F14197C_DString[0 .. 2], LUT_7F14197C_DString[2 .. 4], 0), Ca(LUT_7F14197C_DString[4 .. 6], null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[6 .. 8], LUT_7F14197C_DString[6 .. 8], 0), Ca(null, LUT_7F14197C_DString[8 .. 10], LUT_7F14197C_DString[8 .. 10], 0), Ca(null, LUT_7F14197C_DString[10 .. 13], LUT_7F14197C_DString[10 .. 13], 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(LUT_7F14197C_DString[13 .. 14], null, null, 1), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[14 .. 17], LUT_7F14197C_DString[14 .. 17], 0), Ca(null, LUT_7F14197C_DString[17 .. 19], LUT_7F14197C_DString[19 .. 21], 0), Ca(null, LUT_7F14197C_DString[21 .. 23], LUT_7F14197C_DString[21 .. 23], 0), Ca(null, LUT_7F14197C_DString[23 .. 25], LUT_7F14197C_DString[23 .. 25], 0), Ca(null, LUT_7F14197C_DString[25 .. 27], LUT_7F14197C_DString[25 .. 27], 0), Ca(null, LUT_7F14197C_DString[27 .. 29], LUT_7F14197C_DString[27 .. 29], 0), Ca(null, LUT_7F14197C_DString[29 .. 31], LUT_7F14197C_DString[29 .. 31], 0), Ca(null, LUT_7F14197C_DString[31 .. 33], LUT_7F14197C_DString[31 .. 33], 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[33 .. 36], LUT_7F14197C_DString[33 .. 36], 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[36 .. 39], LUT_7F14197C_DString[36 .. 39], 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[39 .. 42], LUT_7F14197C_DString[39 .. 42], 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[42 .. 43], LUT_7F14197C_DString[43 .. 45], 0), Ca(null, LUT_7F14197C_DString[45 .. 46], LUT_7F14197C_DString[46 .. 48], 0), Ca(null, LUT_7F14197C_DString[48 .. 49], LUT_7F14197C_DString[49 .. 51], 0), Ca(null, LUT_7F14197C_DString[51 .. 52], LUT_7F14197C_DString[52 .. 54], 0), Ca(null, LUT_7F14197C_DString[54 .. 55], LUT_7F14197C_DString[55 .. 57], 0), Ca(null, LUT_7F14197C_DString[57 .. 58], LUT_7F14197C_DString[58 .. 60], 0), Ca(null, LUT_7F14197C_DString[60 .. 61], LUT_7F14197C_DString[61 .. 63], 0), Ca(null, LUT_7F14197C_DString[63 .. 64], LUT_7F14197C_DString[64 .. 66], 0), Ca(LUT_7F14197C_DString[66 .. 67], null, LUT_7F14197C_DString[43 .. 45], 0), Ca(LUT_7F14197C_DString[67 .. 68], null, LUT_7F14197C_DString[46 .. 48], 0), Ca(LUT_7F14197C_DString[68 .. 69], null, LUT_7F14197C_DString[49 .. 51], 0), Ca(LUT_7F14197C_DString[69 .. 70], null, LUT_7F14197C_DString[52 .. 54], 0), Ca(LUT_7F14197C_DString[70 .. 71], null, LUT_7F14197C_DString[55 .. 57], 0), Ca(LUT_7F14197C_DString[71 .. 72], null, LUT_7F14197C_DString[58 .. 60], 0), Ca(LUT_7F14197C_DString[72 .. 73], null, LUT_7F14197C_DString[61 .. 63], 0), Ca(LUT_7F14197C_DString[73 .. 74], null, LUT_7F14197C_DString[64 .. 66], 0), Ca(null, LUT_7F14197C_DString[74 .. 75], LUT_7F14197C_DString[75 .. 77], 0), Ca(null, LUT_7F14197C_DString[77 .. 78], LUT_7F14197C_DString[78 .. 80], 0), Ca(null, LUT_7F14197C_DString[80 .. 81], LUT_7F14197C_DString[81 .. 83], 0), Ca(null, LUT_7F14197C_DString[83 .. 84], LUT_7F14197C_DString[84 .. 86], 0), Ca(null, LUT_7F14197C_DString[86 .. 87], LUT_7F14197C_DString[87 .. 89], 0), Ca(null, LUT_7F14197C_DString[89 .. 90], LUT_7F14197C_DString[90 .. 92], 0), Ca(null, LUT_7F14197C_DString[92 .. 93], LUT_7F14197C_DString[93 .. 95], 0), Ca(null, LUT_7F14197C_DString[95 .. 96], LUT_7F14197C_DString[96 .. 98], 0), Ca(LUT_7F14197C_DString[98 .. 99], null, LUT_7F14197C_DString[75 .. 77], 0), Ca(LUT_7F14197C_DString[99 .. 100], null, LUT_7F14197C_DString[78 .. 80], 0), Ca(LUT_7F14197C_DString[100 .. 101], null, LUT_7F14197C_DString[81 .. 83], 0), Ca(LUT_7F14197C_DString[101 .. 102], null, LUT_7F14197C_DString[84 .. 86], 0), Ca(LUT_7F14197C_DString[102 .. 103], null, LUT_7F14197C_DString[87 .. 89], 0), Ca(LUT_7F14197C_DString[103 .. 104], null, LUT_7F14197C_DString[90 .. 92], 0), Ca(LUT_7F14197C_DString[104 .. 105], null, LUT_7F14197C_DString[93 .. 95], 0), Ca(LUT_7F14197C_DString[105 .. 106], null, LUT_7F14197C_DString[96 .. 98], 0), Ca(null, LUT_7F14197C_DString[106 .. 107], LUT_7F14197C_DString[107 .. 109], 0), Ca(null, LUT_7F14197C_DString[109 .. 110], LUT_7F14197C_DString[110 .. 112], 0), Ca(null, LUT_7F14197C_DString[112 .. 113], LUT_7F14197C_DString[113 .. 115], 0), Ca(null, LUT_7F14197C_DString[115 .. 116], LUT_7F14197C_DString[116 .. 118], 0), Ca(null, LUT_7F14197C_DString[118 .. 119], LUT_7F14197C_DString[119 .. 121], 0), Ca(null, LUT_7F14197C_DString[121 .. 122], LUT_7F14197C_DString[122 .. 124], 0), Ca(null, LUT_7F14197C_DString[124 .. 125], LUT_7F14197C_DString[125 .. 127], 0), Ca(null, LUT_7F14197C_DString[127 .. 128], LUT_7F14197C_DString[128 .. 130], 0), Ca(LUT_7F14197C_DString[130 .. 131], null, LUT_7F14197C_DString[107 .. 109], 0), Ca(LUT_7F14197C_DString[131 .. 132], null, LUT_7F14197C_DString[110 .. 112], 0), Ca(LUT_7F14197C_DString[132 .. 133], null, LUT_7F14197C_DString[113 .. 115], 0), Ca(LUT_7F14197C_DString[133 .. 134], null, LUT_7F14197C_DString[116 .. 118], 0), Ca(LUT_7F14197C_DString[134 .. 135], null, LUT_7F14197C_DString[119 .. 121], 0), Ca(LUT_7F14197C_DString[135 .. 136], null, LUT_7F14197C_DString[122 .. 124], 0), Ca(LUT_7F14197C_DString[136 .. 137], null, LUT_7F14197C_DString[125 .. 127], 0), Ca(LUT_7F14197C_DString[137 .. 138], null, LUT_7F14197C_DString[128 .. 130], 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[138 .. 140], LUT_7F14197C_DString[140 .. 142], 0), Ca(null, LUT_7F14197C_DString[142 .. 143], LUT_7F14197C_DString[143 .. 145], 0), Ca(null, LUT_7F14197C_DString[145 .. 147], LUT_7F14197C_DString[147 .. 149], 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[149 .. 151], LUT_7F14197C_DString[149 .. 151], 0), Ca(null, LUT_7F14197C_DString[151 .. 154], LUT_7F14197C_DString[154 .. 157], 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(LUT_7F14197C_DString[157 .. 158], null, LUT_7F14197C_DString[143 .. 145], 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[158 .. 160], LUT_7F14197C_DString[160 .. 162], 0), Ca(null, LUT_7F14197C_DString[162 .. 163], LUT_7F14197C_DString[163 .. 165], 0), Ca(null, LUT_7F14197C_DString[165 .. 167], LUT_7F14197C_DString[167 .. 169], 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[169 .. 171], LUT_7F14197C_DString[169 .. 171], 0), Ca(null, LUT_7F14197C_DString[171 .. 174], LUT_7F14197C_DString[174 .. 177], 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(LUT_7F14197C_DString[177 .. 178], null, LUT_7F14197C_DString[163 .. 165], 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[178 .. 181], LUT_7F14197C_DString[178 .. 181], 0), Ca(null, LUT_7F14197C_DString[10 .. 13], LUT_7F14197C_DString[10 .. 13], 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[181 .. 183], LUT_7F14197C_DString[181 .. 183], 0), Ca(null, LUT_7F14197C_DString[183 .. 186], LUT_7F14197C_DString[183 .. 186], 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[186 .. 189], LUT_7F14197C_DString[186 .. 189], 0), Ca(null, LUT_7F14197C_DString[14 .. 17], LUT_7F14197C_DString[14 .. 17], 0), Ca(null, LUT_7F14197C_DString[189 .. 191], LUT_7F14197C_DString[189 .. 191], 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[191 .. 193], LUT_7F14197C_DString[191 .. 193], 0), Ca(null, LUT_7F14197C_DString[193 .. 196], LUT_7F14197C_DString[193 .. 196], 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[196 .. 198], LUT_7F14197C_DString[198 .. 200], 0), Ca(null, LUT_7F14197C_DString[200 .. 201], LUT_7F14197C_DString[201 .. 203], 0), Ca(null, LUT_7F14197C_DString[203 .. 205], LUT_7F14197C_DString[205 .. 207], 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[207 .. 209], LUT_7F14197C_DString[207 .. 209], 0), Ca(null, LUT_7F14197C_DString[209 .. 212], LUT_7F14197C_DString[212 .. 215], 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(LUT_7F14197C_DString[215 .. 216], null, LUT_7F14197C_DString[201 .. 203], 0), Ca(null, LUT_7F14197C_DString[216 .. 218], LUT_7F14197C_DString[218 .. 220], 0), Ca(null, LUT_7F14197C_DString[220 .. 222], LUT_7F14197C_DString[222 .. 224], 0), Ca(null, LUT_7F14197C_DString[224 .. 226], LUT_7F14197C_DString[226 .. 228], 0), Ca(null, LUT_7F14197C_DString[228 .. 231], LUT_7F14197C_DString[231 .. 234], 0), Ca(null, LUT_7F14197C_DString[234 .. 237], LUT_7F14197C_DString[237 .. 240], 0), Ca(null, LUT_7F14197C_DString[240 .. 242], LUT_7F14197C_DString[242 .. 244], 0), Ca(null, LUT_7F14197C_DString[240 .. 242], LUT_7F14197C_DString[242 .. 244], 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, LUT_7F14197C_DString[244 .. 246], LUT_7F14197C_DString[246 .. 248], 0), Ca(null, LUT_7F14197C_DString[248 .. 250], LUT_7F14197C_DString[250 .. 252], 0), Ca(null, LUT_7F14197C_DString[252 .. 254], LUT_7F14197C_DString[254 .. 256], 0), Ca(null, LUT_7F14197C_DString[256 .. 258], LUT_7F14197C_DString[258 .. 260], 0), Ca(null, LUT_7F14197C_DString[260 .. 262], LUT_7F14197C_DString[262 .. 264], 0), ];
    static immutable dstring LUT_7F14197C_DString = cast(dstring)[cast(uint)0x53, 0x73, 0x53, 0x53, 0x69, 0x0307, 0x02BC, 0x4E, 0x4A, 0x030C, 0x0399, 0x0308, 0x0301, 0x03C2, 0x03A5, 0x0308, 0x0301, 0x0535, 0x0582, 0x0535, 0x0552, 0x48, 0x0331, 0x54, 0x0308, 0x57, 0x030A, 0x59, 0x030A, 0x41, 0x02BE, 0x03A5, 0x0313, 0x03A5, 0x0313, 0x0300, 0x03A5, 0x0313, 0x0301, 0x03A5, 0x0313, 0x0342, 0x1F88, 0x1F08, 0x0399, 0x1F89, 0x1F09, 0x0399, 0x1F8A, 0x1F0A, 0x0399, 0x1F8B, 0x1F0B, 0x0399, 0x1F8C, 0x1F0C, 0x0399, 0x1F8D, 0x1F0D, 0x0399, 0x1F8E, 0x1F0E, 0x0399, 0x1F8F, 0x1F0F, 0x0399, 0x1F80, 0x1F81, 0x1F82, 0x1F83, 0x1F84, 0x1F85, 0x1F86, 0x1F87, 0x1F98, 0x1F28, 0x0399, 0x1F99, 0x1F29, 0x0399, 0x1F9A, 0x1F2A, 0x0399, 0x1F9B, 0x1F2B, 0x0399, 0x1F9C, 0x1F2C, 0x0399, 0x1F9D, 0x1F2D, 0x0399, 0x1F9E, 0x1F2E, 0x0399, 0x1F9F, 0x1F2F, 0x0399, 0x1F90, 0x1F91, 0x1F92, 0x1F93, 0x1F94, 0x1F95, 0x1F96, 0x1F97, 0x1FA8, 0x1F68, 0x0399, 0x1FA9, 0x1F69, 0x0399, 0x1FAA, 0x1F6A, 0x0399, 0x1FAB, 0x1F6B, 0x0399, 0x1FAC, 0x1F6C, 0x0399, 0x1FAD, 0x1F6D, 0x0399, 0x1FAE, 0x1F6E, 0x0399, 0x1FAF, 0x1F6F, 0x0399, 0x1FA0, 0x1FA1, 0x1FA2, 0x1FA3, 0x1FA4, 0x1FA5, 0x1FA6, 0x1FA7, 0x1FBA, 0x0345, 0x1FBA, 0x0399, 0x1FBC, 0x0391, 0x0399, 0x0386, 0x0345, 0x0386, 0x0399, 0x0391, 0x0342, 0x0391, 0x0342, 0x0345, 0x0391, 0x0342, 0x0399, 0x1FB3, 0x1FCA, 0x0345, 0x1FCA, 0x0399, 0x1FCC, 0x0397, 0x0399, 0x0389, 0x0345, 0x0389, 0x0399, 0x0397, 0x0342, 0x0397, 0x0342, 0x0345, 0x0397, 0x0342, 0x0399, 0x1FC3, 0x0399, 0x0308, 0x0300, 0x0399, 0x0342, 0x0399, 0x0308, 0x0342, 0x03A5, 0x0308, 0x0300, 0x03A1, 0x0313, 0x03A5, 0x0342, 0x03A5, 0x0308, 0x0342, 0x1FFA, 0x0345, 0x1FFA, 0x0399, 0x1FFC, 0x03A9, 0x0399, 0x038F, 0x0345, 0x038F, 0x0399, 0x03A9, 0x0342, 0x03A9, 0x0342, 0x0345, 0x03A9, 0x0342, 0x0399, 0x1FF3, 0x46, 0x66, 0x46, 0x46, 0x46, 0x69, 0x46, 0x49, 0x46, 0x6C, 0x46, 0x4C, 0x46, 0x66, 0x69, 0x46, 0x46, 0x49, 0x46, 0x66, 0x6C, 0x46, 0x46, 0x4C, 0x53, 0x74, 0x53, 0x54, 0x0544, 0x0576, 0x0544, 0x0546, 0x0544, 0x0565, 0x0544, 0x0535, 0x0544, 0x056B, 0x0544, 0x053B, 0x054E, 0x0576, 0x054E, 0x0546, 0x0544, 0x056D, 0x0544, 0x053D, ];
}

export extern(C) immutable(void*) sidero_utf_lut_getSpecialCasing2Lithuanian(dchar input) @trusted nothrow @nogc pure {
    if (input >= 0x49 && input <= 0x4A)
        return cast(void*)&LUT_C8B9F92E[0 + (input - 73)];
    else if (input >= 0xCC && input <= 0xCD)
        return cast(void*)&LUT_C8B9F92E[2 + (input - 204)];
    else if (input >= 0x128 && input <= 0x12E)
        return cast(void*)&LUT_C8B9F92E[4 + (input - 296)];
    else if (input == 0x307)
        return cast(void*)&LUT_C8B9F92E[11 + (input - 775)];
    return null;
}
private {
    static immutable LUT_C8B9F92E = [Ca(LUT_C8B9F92E_DString[0 .. 2], null, null, 4), Ca(LUT_C8B9F92E_DString[2 .. 4], null, null, 4), Ca(LUT_C8B9F92E_DString[4 .. 7], null, null, 0), Ca(LUT_C8B9F92E_DString[7 .. 10], null, null, 0), Ca(LUT_C8B9F92E_DString[10 .. 13], null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(LUT_C8B9F92E_DString[13 .. 15], null, null, 4), Ca(null, null, null, 3), ];
    static immutable dstring LUT_C8B9F92E_DString = cast(dstring)[cast(uint)0x69, 0x0307, 0x6A, 0x0307, 0x69, 0x0307, 0x0300, 0x69, 0x0307, 0x0301, 0x69, 0x0307, 0x0303, 0x012F, 0x0307, ];
}

export extern(C) immutable(void*) sidero_utf_lut_getSpecialCasing2Turkish(dchar input) @trusted nothrow @nogc pure {
    if (input >= 0x49 && input <= 0x69)
        return cast(void*)&LUT_4E6901CD[0 + (input - 73)];
    else if (input == 0x130)
        return cast(void*)&LUT_4E6901CD[33 + (input - 304)];
    else if (input == 0x307)
        return cast(void*)&LUT_4E6901CD[34 + (input - 775)];
    return null;
}
private {
    static immutable LUT_4E6901CD = [Ca(LUT_4E6901CD_DString[0 .. 1], null, null, 6), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, LUT_4E6901CD_DString[1 .. 2], LUT_4E6901CD_DString[1 .. 2], 0), Ca(LUT_4E6901CD_DString[2 .. 3], null, null, 0), Ca(null, null, null, 5), ];
    static immutable dstring LUT_4E6901CD_DString = cast(dstring)[cast(uint)0x0131, 0x0130, 0x69, ];
}

export extern(C) immutable(void*) sidero_utf_lut_getSpecialCasing2Azeri(dchar input) @trusted nothrow @nogc pure {
    if (input >= 0x49 && input <= 0x69)
        return cast(void*)&LUT_627EDE0E[0 + (input - 73)];
    else if (input == 0x130)
        return cast(void*)&LUT_627EDE0E[33 + (input - 304)];
    else if (input == 0x307)
        return cast(void*)&LUT_627EDE0E[34 + (input - 775)];
    return null;
}
private {
    static immutable LUT_627EDE0E = [Ca(LUT_627EDE0E_DString[0 .. 1], null, null, 6), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, null, null, 0), Ca(null, LUT_627EDE0E_DString[1 .. 2], LUT_627EDE0E_DString[1 .. 2], 0), Ca(LUT_627EDE0E_DString[2 .. 3], null, null, 0), Ca(null, null, null, 5), ];
    static immutable dstring LUT_627EDE0E_DString = cast(dstring)[cast(uint)0x0131, 0x0130, 0x69, ];
}


alias Ca = Casing;

struct Casing {
    dstring lower, title, upper;
    ubyte condition;
}
