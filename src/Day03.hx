import haxe.Int64;

using bglib.utils.PrimitiveTools;
using bglib.utils.Utils;

import bglib.utils.FilePath;

import Math.*;

private typedef Vec = {x:Int, y:Int};
private typedef Vec3 = {x:Int, y:Int, z:Int};
private typedef A<V> = Array<V>;
private typedef AA<V> = Array<Array<V>>;

// haxe build.hxml 03
private typedef Input = AA<Int>;

class Day03 implements Day {
    var input:Input;

    public function new() {}

    public function part1() {
        var total = 0;
        for (pack in input) {
            var b1 = -1;
            var b0 = -1;

            var maxi = -1;
            for (i => b in pack) {
                if (b > b1 && i != pack.length - 1) {
                    b1 = b;
                    maxi = i;
                }
            }

            maxi++;
            for (i in maxi...pack.length) {
                var b = pack[i];
                if (b > b0) b0 = b;
            }

            total += b1 * 10 + b0;
        }
        return total;
    }

    public function part2() {
        var total:Int64 = 0;
        for (pack in input) {
            var maxi = -1;
            var jolt:Int64 = 0;
            for (n in 0...12) {
                var b0 = -1;
                for (i in maxi...pack.length - 11 + n) {
                    var b = pack[i];
                    if (b > b0) {
                        b0 = b;
                        maxi = i + 1;
                    }
                }
                jolt = jolt * 10 + b0;
            }
            total += jolt;
        }
        return total;
    }

    public function loadFile(file:FilePath) {
        var inp = file.getContent();

        input = inp.split("\n").map((line) -> line.split("").map(Std.parseInt));
        input = input.filter(v -> v.length != 0);

        return this;
    }
}
