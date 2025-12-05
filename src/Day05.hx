import haxe.Int64;

using bglib.utils.PrimitiveTools;
using bglib.utils.Utils;

import bglib.utils.FilePath;

import Math.*;

private typedef Vec = {x:Int64, y:Int64};
private typedef Vec3 = {x:Int, y:Int, z:Int};
private typedef A<V> = Array<V>;
private typedef AA<V> = Array<Array<V>>;

// haxe build.hxml 05
private typedef Input = AA<Int>;

class Day05 implements Day {
    var ranges:A<Vec>;
    var ids:A<Int64>;

    public function new() {}

    public function part1() {
        var total = 0;
        for (id in ids) {
            for (range in ranges) {
                if (range.x <= id && id <= range.y) {
                    total++;
                    break;
                }
            }
        }
        return total;
    }

    public function part2() {
        ranges.stableSort((a, b) -> Int64.ucompare(a.x, b.x));

        var total:Int64 = 0;
        var py:Int64 = 0;
        for (r in ranges) {
            if (r.x > py) {
                total += r.y - r.x + 1;
                py = r.y;
            } else if (py < r.y) {
                total += r.y - py;
                py = r.y;
            }
        }
        return total;
    }

    public function loadFile(file:FilePath) {
        var inp = file.getContent().split("\n");
        var i = inp.findIndex(s -> s.length == 0);

        ranges = inp.slice(0, i).map(s -> {
            var vs = s.split("-");
            return {
                x: Int64.parseString(vs[0]),
                y: Int64.parseString(vs[1]),
            }
        });
        ids = inp.slice(i).map(Int64.parseString);

        return this;
    }
}
