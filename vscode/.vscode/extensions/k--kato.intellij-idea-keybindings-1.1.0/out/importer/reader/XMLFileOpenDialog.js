"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.XMLFileOpenDialog = void 0;
const vscode = require("vscode");
const FileReader_1 = require("./FileReader");
class XMLFileOpenDialog {
    static async show() {
        const readerXmlOptions = {
            canSelectFiles: true,
            filters: {
                XML: ['xml'],
            },
        };
        const xmlUri = await vscode.window.showOpenDialog(readerXmlOptions);
        if (!xmlUri || !xmlUri[0]) {
            throw Error('Canceled');
        }
        return FileReader_1.FileReader.read(xmlUri[0]);
    }
}
exports.XMLFileOpenDialog = XMLFileOpenDialog;
//# sourceMappingURL=XMLFileOpenDialog.js.map