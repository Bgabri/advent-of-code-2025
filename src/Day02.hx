using bglib.utils.PrimitiveTools;
using bglib.utils.Utils;

import bglib.utils.FilePath;

import Math.*;

private typedef Vec = {s:String, e:String};
private typedef Vec3 = {x:Int, y:Int, z:Int};
private typedef A<V> = Array<V>;
private typedef AA<V> = Array<Array<V>>;

// haxe build.hxml 02
private typedef Input = A<Vec>;

class Day02 implements Day {
    var input:Input;

    public function new() {}

    public function part1() {
        var total:Float = 0;
        for (id in input) {
            var s = Std.parseFloat(id.s);
            var e = Std.parseFloat(id.e);
            for (x in 0...floor(e - s) + 1) {
                var x = x + s;
                var ds = floor(log(x) / log(10) + 1);
                if (ds % 2 != 0) continue;
                var h0 = floor(x / (pow(10, ds / 2)));
                var h1 = floor(x - (h0 * pow(10, ds / 2)));
                if (h0 == h1) total += x;
            }
        }
        return total;
    }

    function repeat(x:Float, l:Int, n:Int) {
        var v = 0.;
        var l = pow(10, l);
        for (_ in 0...n) {
            v = v * l + x;
        }
        return v;
    }

    public function part2() {
        var total:Float = 0;
        for (id in input) {
            var s = Std.parseFloat(id.s);
            var e = Std.parseFloat(id.e);
            for (x in 0...floor(e - s) + 1) {
                var x = x + s;
                var ds = floor(log(x) / log(10) + 1);
                for (n in 2...floor(ds + 1)) {
                    if (ds % n != 0) continue;
                    var l = ds.div(n);
                    var head = floor(x / pow(10, ds - l));
                    if (repeat(head, l, n) == x) {
                        total += x;
                        break;
                    }
                }
            }
        }
        return total;
    }

    public function loadFile(file:FilePath) {
        var inp = file.getContent();

        var w = ~/\s/g;
        inp = w.replace(inp, "");
        input = inp.split(",").map(s -> {
            var r = s.split("-");
            return {
                s: r[0],
                e: r[1]
            }
        });

        return this;
    }
}
