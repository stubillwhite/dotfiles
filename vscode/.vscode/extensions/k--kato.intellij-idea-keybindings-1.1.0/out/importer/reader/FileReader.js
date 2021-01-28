"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FileReader = void 0;
const vscode = require("vscode");
class FileReader {
    static async read(uri) {
        const readData = await vscode.workspace.fs.readFile(uri);
        return Buffer.from(readData).toString('utf8');
    }
}
exports.FileReader = FileReader;
//# sourceMappingURL=FileReader.js.map