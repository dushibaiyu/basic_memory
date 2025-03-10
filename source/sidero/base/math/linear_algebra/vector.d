module sidero.base.math.linear_algebra.vector;
import sidero.base.math.utils : isClose;
import sidero.base.errors;
import std.traits : isNumeric, isSigned;

export @safe nothrow @nogc:

///
alias Vec2f = Vector!(float, 2);
///
alias Vec2d = Vector!(double, 2);
///
alias Vec3f = Vector!(float, 3);
///
alias Vec3d = Vector!(double, 3);
///
alias Vec4f = Vector!(float, 4);
///
alias Vec4d = Vector!(double, 4);

///
struct Vector(Type, size_t Dimension) {
    static assert(Dimension > 0, "Dimensions must be above zero");

    ///
    Type[Dimension] data;
    alias data this;

export @safe nothrow @nogc:

    ///
    this(scope Type[] data...) scope {
        assert(data.length == this.data.length);

        foreach(i, v; data)
            this.data[i] = v;
    }

    ///
    ref Type x() scope {
        return data[0];
    }

    static if(Dimension > 1) {
        ///
        ref Type y() scope {
            return data[1];
        }
    }

    static if(Dimension > 2) {
        ///
        ref Type z() scope {
            return data[2];
        }
    }

    static if(Dimension > 3) {
        ///
        ref Type w() scope {
            return data[3];
        }
    }

    ///
    static Vector zero() {
        Vector ret;

        foreach(i; 0 .. Dimension)
            ret.data[i] = 0;

        return ret;
    }

    ///
    unittest {
        Vector vec = Vector.zero();

        foreach(v; vec.data)
            assert(v.isClose(0));
    }

    ///
    static Vector one() {
        Vector ret;

        foreach(i; 0 .. Dimension)
            ret.data[i] = 1;

        return ret;
    }

    ///
    unittest {
        Vector vec = Vector.one();

        foreach(v; vec.data)
            assert(v.isClose(1));
    }

    ///
    Vector!(NewType, Dimension) opCast(As : Vector!(NewType, Dimension), NewType)() scope const {
        typeof(return) ret;

        foreach(i, v; this.data)
            ret.data[i] = cast(NewType)v;

        return ret;
    }

    ///
    unittest {
        auto v1 = cast(Vector!(size_t, Dimension))Vector.one;
        auto v2 = cast(Vector!(float, Dimension))Vector.one;
    }

    static if(isSigned!Type) {
        ///
        Vector opUnary(string op : "-")() scope const {
            Vector ret;

            foreach(i; 0 .. Dimension)
                ret.data[i] = -this.data[i];

            return ret;
        }

        ///
        unittest {
            Vector vec1 = Vector.zero, vec2 = Vector.zero;
            vec1.data[0] = 3;
            vec2.data[0] = -3;

            assert(-vec1 == vec2);
        }
    }

    ///
    void opUnary(string op : "++")() scope {
        this += 1;
    }

    ///
    unittest {
        Vector vec = Vector.zero;
        vec++;
        assert(vec == Vector.one);
    }

    ///
    void opUnary(string op : "--")() scope {
        this -= 1;
    }

    ///
    unittest {
        Vector vec = Vector.one;
        vec--;
        assert(vec == Vector.zero);
    }

    ///
    void opOpAssign(string op)(const Type other) scope {
        static if(op == "^^") {
            import core.stdc.math : pow;

            foreach(i, ref v; this.data)
                v = pow(v, other);
        } else
            mixin("this.data[] " ~ op ~ "= other;");
    }

    ///
    unittest {
        Vector temp = Vector.one;
        temp *= 0;
        assert(temp == Vector.zero);
    }

    ///
    void opOpAssign(string op)(const Vector other) scope {
        static if(op == "^^") {
            import core.stdc.math : pow;

            foreach(i, ref v; this.data)
                v = pow(v, other.data[i]);
        } else
            mixin("this.data[] " ~ op ~ "= other.data[];");
    }

    ///
    unittest {
        Vector temp = Vector.one;
        temp *= Vector.zero;
        assert(temp == Vector.zero);
    }

    ///
    Vector opBinary(string op)(const Type other) scope const {
        Vector ret = this;
        ret.opOpAssign!op(other);
        return ret;
    }

    ///
    unittest {
        assert(Vector.one / 1 == Vector.one);
    }

    ///
    Vector opBinary(string op)(const Vector other) scope const {
        Vector ret = this;
        ret.opOpAssign!op(other);
        return ret;
    }

    ///
    unittest {
        assert(Vector.one / Vector.one == Vector.one);
    }

    ///
    void opAssign(const Type input) scope {
        foreach(i; 0 .. Dimension)
            this.data[i] = input;
    }

    ///
    unittest {
        Vector vec;
        vec = 1;
        assert(vec == Vector.one);
    }

    ///
    void opAssign(scope const Type[] input...) scope {
        size_t canDo = Dimension;
        if(input.length < canDo)
            canDo = input.length;

        foreach(i; 0 .. canDo)
            this.data[i] = input[i];

        foreach(i; canDo .. Dimension)
            this.data[i] = 0;
    }

    ///
    unittest {
        Vector vec;
        vec = [0];
        assert(vec == Vector.zero);
    }

    ///
    Vector!(Type, Dimension2) subVector(size_t Dimension2)(size_t offset) scope const {
        const overlapTemp = Dimension - offset;
        const overlap = overlapTemp > Dimension2 ? Dimension2 : overlapTemp;

        Vector!(Type, Dimension2) ret;

        foreach(i; 0 .. overlap)
            ret.data[i] = this.data[offset + i];
        foreach(i; overlap .. Dimension2)
            ret.data[i] = 0;

        return ret;
    }

    ///
    unittest {
        Vector first;
        auto second = first.subVector!(Dimension > 1 ? Dimension : (Dimension + 1))(1);
    }

    /// Retrieve a value based upon index (offset + 1)
    ref Type index(size_t index) scope {
        assert(index >= 1);
        assert(index <= Dimension);
        return this.data[index - 1];
    }

    ///
    unittest {
        Vector vec;
        vec.data[0] = 5;
        assert(vec.index(1).isClose(5));
    }

    /// Ditto
    Type index(size_t index) scope const {
        assert(index >= 1);
        assert(index <= Dimension);
        return this.data[index - 1];
    }

    ///
    unittest {
        Vector vec;
        vec.data[0] = 5;
        const vec2 = vec;
        assert(vec2.index(1).isClose(5));
    }

    ///
    Type sum() scope const {
        import algorithm = std.algorithm.iteration;

        return algorithm.sum(this.data[]);
    }

    ///
    unittest {
        assert(Vector.one.sum == Dimension);
    }

    ///
    Type magnitude() scope const {
        return .magnitude(this.data[]);
    }

    ///
    Vector normalize(const scope Vector other) scope const {
        Vector ret;
        auto got = .normalize(ret.data[], other.data[]);
        assert(got);
        return ret;
    }

    ///
    Type distance(const scope Vector other) scope const {
        auto got = .distance(this.data[], other.data[]);
        assert(got);
        return got.get;
    }

    ///
    Type dotProduct(const scope Vector other) scope const {
        auto got = .dotProduct(this.data[], other.data[]);
        assert(got);
        return got.get;
    }

    ///
    Vector crossProduct(const scope Vector other) scope const {
        Vector ret;

        auto got = .crossProduct(ret.data[], this.data[], other.data[]);
        assert(got);

        return ret;
    }

    ///
    Type standardDeviation() scope const {
        return .standardDeviation(data[]);
    }

    ///
    bool isZeroVector() scope const {
        return .isZeroVector(data[]);
    }

    ///
    bool isOnesVector() scope const {
        return .isOnesVector(data[]);
    }

    ///
    bool isUnitVector() scope const {
        return .isUnitVector(data[]);
    }

    ///
    bool isSparse() scope const {
        return .isSparse(data[]);
    }

    ///
    Vector abs() scope const {
        Vector ret;

        foreach(i, ref v; ret.data)
            v = this.data[i] < 0 ? -this.data[i] : this.data[i];

        return ret;
    }

    ///
    unittest {
        static if(isSigned!Type) {
            assert((-Vector.one).abs == Vector.one);
        }
    }

    ///
    ulong toHash() scope const {
        return hashOf(this.data[]);
    }

    ///
    alias equals = opEquals;

    ///
    bool opEquals(scope const Vector other) scope const {
        foreach(i; 0 .. Dimension) {
            if(!this.data[i].isClose(other.data[i]))
                return false;
        }

        return true;
    }

    ///
    bool equals(scope const Vector other, Type maxRelativeDifference, Type maxAbsoluteDifference = 0) scope const {
        foreach(i; 0 .. Dimension) {
            if(!this.data[i].isClose(other.data[i], maxRelativeDifference, maxAbsoluteDifference))
                return false;
        }

        return true;
    }

    ///
    alias compare = opCmp;

    ///
    int opCmp(scope const Vector other) scope const {
        foreach(i; 0 .. Dimension) {
            if(this.data[i] < other.data[i])
                return -1;
            else if(this.data[i] > other.data[i])
                return 1;
        }

        return 0;
    }
}

///
Vector!(Type, Dimension) min(Type, size_t Dimension)(scope Vector!(Type, Dimension) inputs...) {
    typeof(return) ret;

    foreach(i, ref v; ret.data) {
        v = Type.max;

        foreach(ref input; inputs) {
            if(input.data[i] < v)
                v = input.data[i];
        }
    }

    return ret;
}

///
Vector!(Type, Dimension) max(Type, size_t Dimension)(scope Vector!(Type, Dimension)[] inputs...) {
    import std.traits : isFloatingPoint;

    typeof(return) ret;

    foreach(i, ref v; ret.data) {
        static if(isFloatingPoint!Type) {
            v = Type.min_exp;
        } else {
            v = Type.min;
        }

        foreach(ref input; inputs) {
            if(input.data[i] > v)
                v = input.data[i];
        }
    }

    return ret;
}

///
Type magnitude(Type)(scope const Type[] values) if (isNumeric!Type) {
    import std.algorithm.iteration : sum;
    import core.math : sqrt;

    static struct Handler {
        const(Type)[] values;

        Type front() {
            return values[0] * values[0];
        }

        bool empty() {
            return values.length == 0;
        }

        void popFront() {
            values = values[1 .. $];
        }
    }

    Handler handler;
    handler.values = values;

    return cast(Type)sqrt(cast(double)handler.sum);
}

///
unittest {
    static Values = [1, 0, -3f];
    assert(Values.magnitude.isClose(3.16, 0.01));
}

///
ErrorResult normalize(A, B)(scope A[] output, scope const B[] input) if (isNumeric!A && isNumeric!B) {
    if(output.length != input.length)
        return ErrorResult(RangeException("Input lengths must match output"));

    const temp = cast(A)input.magnitude;

    foreach(i; 0 .. input.length)
        output[i] = input[i] / temp;

    return ErrorResult();
}

///
unittest {
    static Values = [8f, 6f, 7f];

    float[3] output;
    auto got = normalize(output[], Values);

    assert(got);
    assert(output[0].isClose(0.66, 0.01));
    assert(output[1].isClose(0.49, 0.01));
    assert(output[2].isClose(0.57, 0.01));
}

///
Result!CommonType distance(A, B, CommonType = typeof(A.init + B.init))(scope const(A)[] input1, scope const(B)[] input2)
        if (isNumeric!A && isNumeric!B) {
    import std.algorithm.iteration : sum;
    import std.math : sqrt;

    if(input1.length != input2.length)
        return typeof(return)(RangeException("Input lengths must match"));

    static struct Handler {
        const(A)[] input1;
        const(B)[] input2;

        CommonType front() {
            CommonType v = input1[0] - input2[0];
            return v * v;
        }

        bool empty() {
            return input1.length == 0;
        }

        void popFront() {
            input1 = input1[1 .. $];
            input2 = input2[1 .. $];
        }
    }

    Handler handler;
    handler.input1 = input1;
    handler.input2 = input2;

    return typeof(return)(cast(CommonType)sqrt(cast(double)handler.sum));
}

///
unittest {
    static Values1 = [0, -2f, 7], Values2 = [8f, 4, 3];

    auto got = distance(Values1, Values2);
    assert(got);
    assert(got.get.isClose(10.77, 0.01));
}

///
Result!CommonType dotProduct(A, B, CommonType = typeof(A.init + B.init))(scope const A[] a, scope const B[] b)
        if (isNumeric!A && isNumeric!B) {
    if(a.length != b.length)
        return typeof(return)(RangeException("Input lengths must match"));
    else if(a.length == 0)
        return typeof(return)(RangeException("Input lengths must be non-zero"));

    assert(a.length == b.length);
    CommonType ret = 0;

    foreach(i; 0 .. a.length) {
        ret += a[i] * b[i];
    }

    return typeof(return)(ret);
}

///
unittest {
    static Values1 = [1, 2f, 3], Values2 = [1, 5, 7f];

    auto got = dotProduct(Values1, Values2);
    assert(got);
    assert(got.get.isClose(32));
}

///
ErrorResult crossProduct(A, B, C)(scope A[] output, scope const B[] input1, scope const C[] input2)
        if (isNumeric!A && isNumeric!B && isNumeric!B) {

    if(output.length != input1.length || input1.length != input2.length)
        return typeof(return)(RangeException("Input lengths must match output"));
    else if(output.length != 3)
        return typeof(return)(MalformedInputException("Only 3rd dimension is defined for vector cross product"));

    if(output.length == 3) {
        output[0] = (input1[1] * input2[2]) - (input1[2] * input2[1]);
        output[1] = (input1[2] * input2[0]) - (input1[0] * input2[2]);
        output[2] = (input1[0] * input2[1]) - (input1[1] * input2[0]);
    }

    return ErrorResult();
}

///
unittest {
    static Values1 = [1, 2f, 3], Values2 = [1, 5, 7f];

    float[3] output;
    auto got = crossProduct(output[], Values1, Values2);

    assert(got);
    assert(output[0].isClose(-1));
    assert(output[1].isClose(-4));
    assert(output[2].isClose(3));
}

///
Type standardDeviation(Type)(scope const(Type)[] values) if (isNumeric!Type) {
    import std.algorithm.iteration : sum;

    static struct Handler {
        const(Type)[] values;
        Type average;

        Type front() {
            Type v = values[0] - average;
            return v * v;
        }

        bool empty() {
            return values.length == 0;
        }

        void popFront() {
            values = values[1 .. $];
        }
    }

    Handler handler;
    handler.values = values;
    handler.average = sum(values) / values.length;

    return handler.sum / values.length;
}

///
unittest {
    static Values = [1f, 2, 3];
    assert(Values.standardDeviation.isClose(0.6, 0.2));
}

///
bool isZeroVector(Type)(scope const Type[] values) if (isNumeric!Type) {
    uint ret;

    foreach(v; values)
        ret += cast(ubyte)isClose(v, 0);

    return ret == values.length;
}

///
unittest {
    static Values1 = [0, 0f, 0], Values2 = [0, 2f, 1f];

    assert(Values1.isZeroVector);
    assert(!Values2.isZeroVector);
}

///
bool isOnesVector(Type)(scope const Type[] values) if (isNumeric!Type) {
    uint ret;

    foreach(v; values)
        ret += cast(ubyte)isClose(v, 1);

    return ret == values.length;
}

///
unittest {
    static Values1 = [1, 1f, 1], Values2 = [0, 2f, 1f];

    assert(Values1.isOnesVector);
    assert(!Values2.isOnesVector);
}

/// Is unit vector
bool isUnitVector(Type)(scope const Type[] values) if (isNumeric!Type) {
    uint ret0 = 1, ret1;

    foreach(v; values) {
        ret0 += cast(ubyte)isClose(v, 0);
        ret1 += cast(ubyte)isClose(v, 1);
    }

    return ret1 == 1 && ret0 == values.length;
}

///
unittest {
    static Values1 = [0, 1f, 0], Values2 = [1, 2, 3];
    assert(Values1.isUnitVector);
    assert(!Values2.isUnitVector);
}

/// Is sparse
bool isSparse(Type)(scope const Type[] values) if (isNumeric!Type) {
    uint ret;

    foreach(v; values)
        ret += cast(ubyte)isClose(v, 0);

    return ret >= values.length / 3;
}

///
unittest {
    static Values1 = [1f, 0, 0, 2, 0, 0], Values2 = [1, 2, 3];
    assert(Values1.isSparse);
    assert(!Values2.isSparse);
}
