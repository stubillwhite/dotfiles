"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FileReaderDefault = void 0;
const path_1 = require("path");
const vscode = require("vscode");
const FileReader_1 = require("./FileReader");
class FileReaderDefault {
    static async readIntelliJ(osDestination, context) {
        const defaultXmlUri = vscode.Uri.file(context.asAbsolutePath(path_1.posix.join(this.DEFAULT_PATH, osDestination, 'IntelliJ.xml')));
        return FileReader_1.FileReader.read(defaultXmlUri);
    }
    static async readVSCode(osDestination, context) {
        const defaultJsonUri = vscode.Uri.file(context.asAbsolutePath(path_1.posix.join(this.DEFAULT_PATH, osDestination, 'VSCode.json')));
        return FileReader_1.FileReader.read(defaultJsonUri);
    }
    static async readActionIdCommandMapping(context) {
        const defaultJsonUri = vscode.Uri.file(context.asAbsolutePath(path_1.posix.join(this.RESOURCE_PATH, 'ActionIdCommandMapping.json')));
        return FileReader_1.FileReader.read(defaultJsonUri);
    }
    static async readKeystrokeKeyMapping(context) {
        const defaultJsonUri = vscode.Uri.file(context.asAbsolutePath(path_1.posix.join(this.RESOURCE_PATH, 'KeystrokeKeyMapping.json')));
        return FileReader_1.FileReader.read(defaultJsonUri);
    }
}
exports.FileReaderDefault = FileReaderDefault;
FileReaderDefault.RESOURCE_PATH = 'resource';
FileReaderDefault.DEFAULT_PATH = path_1.posix.join(FileReaderDefault.RESOURCE_PATH, 'default');
//# sourceMappingURL=FileReaderDefault.js.map