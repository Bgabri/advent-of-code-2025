import bglib.utils.FilePath;

interface Day {
    public function loadFile(file:FilePath):Day;
    public function part1():Any;
    public function part2():Any;
}
