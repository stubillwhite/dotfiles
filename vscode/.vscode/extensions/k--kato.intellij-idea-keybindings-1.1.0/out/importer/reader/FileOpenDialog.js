"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FileOpenDialog = void 0;
const vscode = require("vscode");
const FileReader_1 = require("./FileReader");
class FileOpenDialog {
    static async showXml() {
        const readerXmlOptions = {
            canSelectFiles: true,
            filters: {
                XML: ['xml'],
            },
        };
        const xmlUri = await vscode.window.showOpenDialog(readerXmlOptions);
        if (!xmlUri || !xmlUri[0]) {
            return 'USE_DEFAULT';
        }
        return FileReader_1.FileReader.read(xmlUri[0]);
    }
}
exports.FileOpenDialog = FileOpenDialog;
//# sourceMappingURL=FileOpenDialog.js.map