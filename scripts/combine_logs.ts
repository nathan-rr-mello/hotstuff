import * as fs from 'fs';
import path from 'path';

if (process.argv.length < 3) {
    console.error("Usage: combine_logs.ts <directory>");
    process.exit(1);
}

const directory = process.argv[2];
const contents = fs.readdirSync(directory, {
    withFileTypes: true,
    recursive: true
})

console.log(contents);

const sortedLogs = contents.filter(filterLogs)
    .flatMap(mapLogs)
    .toSorted(compareLogs)

const outputPath = path.join(directory, 'all_measurements.json');

fs.writeFileSync(outputPath, JSON.stringify(sortedLogs, null, 2), 'utf-8');


function compareLogs(a: Log, b: Log): number {
    const aTimestamp = a.Event?.Timestamp
    const bTimestamp = b.Event?.Timestamp

    if (!aTimestamp && bTimestamp) return -1;
    if (aTimestamp && !bTimestamp) return 1;
    if (!aTimestamp && !bTimestamp) return 0;

    const aDate = new Date(aTimestamp!);
    const bDate = new Date(bTimestamp!);

    return aDate.getTime() - bDate.getTime();
}    

function mapLogs(dir: fs.Dirent<string>): [Log] {

    const filePath = path.join(dir.parentPath, dir.name)
    const fileContent = fs.readFileSync(filePath, 'utf-8');
    const logs = JSON.parse(fileContent) as [Log];
    return logs;
}

function filterLogs(dir: fs.Dirent<string>): boolean {
    return dir.isFile() && dir.name == "measurements.json";
}

interface Log {
    Event?: {
        Timestamp: string;
    }
}
