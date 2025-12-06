import haxe.Int64;

using bglib.utils.PrimitiveTools;
using bglib.utils.Utils;

import bglib.utils.FilePath;

import Math.*;

private typedef Vec = {x:Int, y:Int};
private typedef Vec3 = {x:Int, y:Int, z:Int};
private typedef A<V> = Array<V>;
private typedef AA<V> = Array<Array<V>>;

// haxe build.hxml 06
private typedef Input = A<String>;

class Day06 implements Day {
    var input:Input;

    public function new() {}

    public function part1() {
        var reg = ~/(?![\S])\s+(?=[\S])/g; // match spaces between 
        var opers = reg.split(input.pop());
        var nums = input.map(l -> reg.split(l).map(Int64.parseString));

        var acc:A<Int64> = nums.pop();
        for (l in nums) {
            for (i => v in l) {
                if (opers[i] == '*') acc[i] *= v;
                else acc[i] += v;
            }
        }
        return acc.fold((i, r) -> i + r, 0);
    }

    public function part2() {
        var total:Int64 = 0;
        var reg = ~/(?![\S])\s+(?=[\S])/g; // match spaces between 
        var opers = reg.split(input.pop());
        var i = 0;
        var acc:Int64 = opers[i] == '*' ? 1 : 0;

        var input:AA<String> = input.map(l -> l.split(""));
        for (x in 0...input[0].length) {
            var v = 0;
            var sep = true;
            for (y in 0...input.length) {
                var c = input[y][x];
                if (c == ' ') continue;
                sep = false;
                v = v * 10 + c.fastCodeAt(0) - '0'.code;
            }
            if (!sep) {
                if (opers[i] == '*') acc *= v;
                else acc += v;
            } else {
                i++;
                total += acc;
                acc = opers[i] == '*' ? 1 : 0;
            }
        }
        return total + acc;
    }

    public function loadFile(file:FilePath) {
        input = file.getContent().split("\n");
        input = input.filter(l -> l.length != 0);
        return this;
    }
}
