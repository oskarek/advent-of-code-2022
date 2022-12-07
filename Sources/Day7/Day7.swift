import Foundation
import Parsing
import Types
import Utils

// MARK: Models

enum DirEntry {
	case directory(String)
	case file(size: Int, name: String)
}

enum Command {
	case goTo(String)
	case goUp
	case goToRoot
	case listContents([DirEntry])
}

struct DirContent {
	var sizeOfFiles: Int
	var subDirs: [String]
}

// MARK: Parsing

extension DirEntry {
	static let parser = OneOf {
		Parse(Self.directory) {
			"dir "
			PrefixUpTo("\n").map(.string)
		}

		Parse(Self.file) {
			Int.parser()
			" "
			PrefixUpTo("\n").map(.string)
		}
	}
}

extension Command {
	static let parser = Parse {
		"$ "
		OneOf {
			Parse {
				"cd "
				OneOf {
					"/".map { Self.goToRoot }
					"..".map { Self.goUp }
					PrefixUpTo("\n").map(.string).map(Self.goTo)
				}
			}

			Parse(Self.listContents) {
				"ls\n"
				LinesOf { DirEntry.parser }
			}
		}
	}
}

// MARK: Solution logic

/// Get the size of a directory.
func sizeOfDir(_ dirName: String, dirMap: [String: DirContent]) -> Int {
	guard let dir = dirMap[dirName] else { return 0 }
	return dir.sizeOfFiles + dir.subDirs.map { sizeOfDir($0, dirMap: dirMap) }.sum
}

/// Build a map that holds the size of each directory.
func buildSizeMap(from commands: [Command]) -> [String: Int] {
	var currPath = ["/"]
	var dirMap: [String: DirContent] = [:]

	for command in commands {
		switch command {
		case .goTo(let string):
			currPath.append(string)

		case .goUp:
			currPath.removeLast()

		case .goToRoot:
			currPath = ["/"]

		case .listContents(let contents):
			let currDir = currPath.joined(separator: "/")
			var subdirs: [String] = []
			var totFileSize = 0
			for entry in contents {
				switch entry {
				case .directory(let string):
					subdirs.append("\(currDir)/\(string)")
				case .file(let size, _):
					totFileSize += size
				}
			}
			dirMap[currDir] = .init(sizeOfFiles: totFileSize, subDirs: subdirs)
		}
	}
	return dirMap.mapWithKeys { dir, _ in sizeOfDir(dir, dirMap: dirMap) }
}

public let solver = Solver(
	parser: LinesOf { Command.parser },
	solve: { commands in
		let sizeMap = buildSizeMap(from: commands)
		return (
			part1: sizeMap.values.filter { $0 <= 100000 }.sum,
			part2: sizeMap.values.sorted(by: <).first { sizeMap["/"]! - $0 <= 40000000 }!
		)
	}
)
